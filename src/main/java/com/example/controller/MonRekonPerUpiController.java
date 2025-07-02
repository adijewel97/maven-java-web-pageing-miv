package com.example.controller;

import com.example.service.DbService;
import com.example.service.MonRekonPerUpiService;
import com.example.utils.LoggerUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

// Untuk Excel
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;


@WebServlet(name = "MonRekonPerUpiController", urlPatterns = {"/mon-rekon-bankvsperupi"})
public class MonRekonPerUpiController extends HttpServlet {
    private MonRekonPerUpiService service;
    private static final Logger logger = LoggerUtil.getLogger(MonRekonPerUpiController.class);
    private final Gson gson = new Gson();

    // private static final String ACT_JENIS_LAPORAN = "handleGetJenisLaporan";
    // private static final String ACT_SUMBER_DATA = "handleGetsumberdata";

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            DbService dbService = new DbService();
            service = new MonRekonPerUpiService(dbService.getDataSource());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal inisialisasi koneksi DB di init()", e);
            throw new ServletException("Gagal inisialisasi koneksi DB", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String act = req.getParameter("act");

        if ("detailData".equalsIgnoreCase(act)) {
            handleGetDetailData(req, resp);
            return;
        }

        if ("exportExcelAll".equalsIgnoreCase(act)) {
            exportAllMonDft(req, resp);
            return;
        }

        // Default handler jika act tidak dikenali
        prosesMonPerUpi(req, resp);
    }


    private void prosesMonPerUpi(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String vbln_usulan = req.getParameter("vbln_usulan");
        // String vtahun = req.getParameter("vtahun");
        int vkode;

        // WAJIB untuk DataTables server-side
        int draw = Integer.parseInt(req.getParameter("draw") != null ? req.getParameter("draw") : "1");

        logger.info("vbln_usulan: " + vbln_usulan);
        // logger.info("vtahun: " + vtahun);

        List<Map<String, Object>> data = Collections.emptyList();
        int totalCount = 0;
        String pesan;

       try {
            List<String> pesanOutput = new ArrayList<>();
            data = service.getDataMPerPerUpi(vbln_usulan, pesanOutput);
            logger.info("Jumlah data dikembalikan: " + data.size());

            String pesanRaw = pesanOutput.isEmpty() ? "" : pesanOutput.get(0).toLowerCase().trim();
            if (pesanRaw.contains("kesalahan")) {
                vkode = 402;
                pesan = "Error:"+pesanOutput.get(0);
                data = new ArrayList<>();
            } else {
                totalCount = data.size();
                vkode = 200;
                pesan = "Sukses: Tampikan data";
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error: Gagal mendapatkan data: " + e.getMessage(), e);
            vkode = 402;
            pesan = "Error: Terjadi kesalahan: " + e.getMessage();
        }

        // Format JSON sesuai DataTables server-side
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("draw", draw); // WAJIB
        jsonResponse.put("recordsTotal", totalCount); // WAJIB
        jsonResponse.put("recordsFiltered", totalCount); // WAJIB
        jsonResponse.put("data", data); // WAJIB
        jsonResponse.put("status", "success");
        jsonResponse.put("kode", vkode);
        jsonResponse.put("pesan", pesan);


        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(jsonResponse));
        }
    }

    private String safeStr(Object val) {
        return val == null ? "" : val.toString();
    }


    private void handleGetDetailData(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int draw = Integer.parseInt(req.getParameter("draw"));
        int startIndex = Integer.parseInt(req.getParameter("start")); // dari DataTables: 0, 10, 20, ...
        int length = Integer.parseInt(req.getParameter("length"));
        int start = (startIndex / length) + 1; // konversi ke nomor halaman Oracle: 1, 2, 3, ...

        String sortColumnIndex = req.getParameter("order[0][column]");
        String sortDir = req.getParameter("order[0][dir]");
        String searchValue = req.getParameter("search[value]");

        // Ambil nama kolom untuk sorting
        String sortBy = req.getParameter("columns[" + sortColumnIndex + "][data]");
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "KD_DIST"; // default kolom sort
            sortDir = "ASC";
        }

        // Filter tambahan dari form
        String vbln_usulan = req.getParameter("vbln_usulan");
        String vkd_bank = req.getParameter("vkd_bank");
        String vkd_dist = req.getParameter("vkd_dist");

        logger.info("draw = " + draw);
        logger.info("offset (startIndex) = " + startIndex);
        logger.info("limit (length) = " + length);
        logger.info("sortBy = " + sortBy + " " + sortDir);
        logger.info("searchValue = " + searchValue);
        logger.info("vbln_usulan = " + vbln_usulan);
        logger.info("vkd_bank = " + vkd_bank);
        logger.info("vkd_dist = " + vkd_dist);


        List<String> pesanOutput = new ArrayList<>();

        // List<Map<String, Object>> data = service.getDataMDftPerUpi(
        //     start, length, sortBy, sortDir, searchValue,
        //     vbln_usulan, vkd_bank, vkd_dist, pesanOutput
        // );
        List<Map<String, Object>> data = service.getDataMDftPerUpi(
            start, length, sortBy, sortDir, searchValue, vbln_usulan, vkd_bank, vkd_dist, pesanOutput
        );

        System.out.println("Jumlah data yang dikembalikan untuk ekspor: " + data.size());


        // Ambil total dari TOTAL_COUNT kolom (karena sudah disediakan di setiap baris)
        int totalRecords = 0;
        if (!data.isEmpty() && data.get(0).get("TOTAL_COUNT") != null) {
            totalRecords = Integer.parseInt(data.get(0).get("TOTAL_COUNT").toString());
        }

        // Format ke JSON response untuk DataTables
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("draw", draw);
        jsonResponse.put("recordsTotal", totalRecords);
        jsonResponse.put("recordsFiltered", totalRecords);
        jsonResponse.put("data", data);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(jsonResponse));
        }
    }

    private void exportAllMonDft(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String vbln_usulan = req.getParameter("vbln_usulan");
        String vkd_bank = req.getParameter("vkd_bank");
        String vkd_dist = req.getParameter("vkd_dist");

        List<String> pesanOutput = new ArrayList<>();
        int start = 1;
        int length = 1_000_000; // cukup besar untuk ambil semua
        String sortBy = "URUT";
        String sortDir = "ASC";
        String search = "";

        // Panggil service
        List<Map<String, Object>> dataList = service.getDataMDftPerUpi(
            start, length, sortBy, sortDir, search, vbln_usulan, vkd_bank, vkd_dist, pesanOutput
        );

        // Buat file Excel
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        Sheet sheet = workbook.createSheet("REKON");

        // Header kolom
        String[] headers = {
            "NO", "PRODUK", "TGLAPPROVE", "KD_DIST", "VA", "SATKER",
            "PLN_NOUSULAN", "PLN_IDPEL", "PLN_BLTH", "PLN_LUNAS_H0", "PLN_RPTAG", "PLN_RPBK",
            "PLN_TGLBAYAR", "PLN_JAMBAYAR", "PLN_USERID", "PLN_KDBANK",
            "BANK_KETERANGAN", "BANK_NOUSULAN", "BANK_IDPEL", "BANK_BLTH",
            "BANK_RPTAG", "BANK_RPBK", "BANK_TGLBAYAR", "BANK_JAMBAYAR", "BANK_USERID", "BANK_KDBANK",
            "SELISIH_RPTAG", "SELISIH_BK", "KETERANGAN"
        };

        // Tulis header
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            headerRow.createCell(i).setCellValue(headers[i]);
        }

        // Isi data
        int rowNum = 1;
        for (Map<String, Object> rowMap : dataList) {
            Row row = sheet.createRow(rowNum);
            int col = 0;
            row.createCell(col++).setCellValue(rowNum); // NO
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PRODUK")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("TGLAPPROVE")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("KD_DIST")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("VA")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("SATKER")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_NOUSULAN")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_IDPEL")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_BLTH")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_LUNAS_H0")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_RPTAG")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_RPBK")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_TGLBAYAR")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_JAMBAYAR")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_USERID")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("PLN_KDBANK")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_KETERANGAN")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_NOUSULAN")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_IDPEL")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_BLTH")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_RPTAG")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_RPBK")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_TGLBAYAR")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_JAMBAYAR")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_USERID")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("BANK_KDBANK")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("SELISIH_RPTAG")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("SELISIH_BK")));
            row.createCell(col++).setCellValue(safeStr(rowMap.get("KETERANGAN")));
            rowNum++;
        }

        // Set response untuk download file
        String fileName = "REKON_DETAIL_" + vbln_usulan + ".xlsx";
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // Kirim ke client
        workbook.write(resp.getOutputStream());
        workbook.close();
        workbook.dispose();
    }

    // private void handleGetJenisLaporan(HttpServletRequest request, HttpServletResponse response) throws IOException {
    //     Map<String, Object> responseData = new HashMap<>();
    //     List<String> pesanOutput = new ArrayList<>();

    //     try {
    //         List<Map<String, Object>> listJenis = service.getcombojenislaporan(pesanOutput);
    //         responseData.put("status", "success");
    //         responseData.put("data", listJenis != null ? listJenis : Collections.emptyList());
    //         responseData.put("pesan", pesanOutput.isEmpty() ? "" : pesanOutput.get(0));
    //     } catch (Exception e) {
    //         logger.log(Level.SEVERE, "Kesalahan saat mengambil jenis laporan", e);
    //         responseData.put("status", "error");
    //         responseData.put("data", Collections.emptyList());
    //         responseData.put("pesan", "Terjadi kesalahan: " + e.getMessage());
    //     }

       
    public static void main(String[] args) {
        try {
            // Setup
            DbService dbService = new DbService();
            MonRekonPerUpiService service = new MonRekonPerUpiService(dbService.getDataSource());

            // Cek mode run: "rekap" atau "detail"
            String mode = "detail"; //(args.length > 0) ? args[0] : "rekap";

            List<String> pesanOutput = new ArrayList<>();

            if ("detail".equalsIgnoreCase(mode)) {
                System.out.println("== TEST MODE: DETAIL ==");

                // Parameter detail
                int start = 1;
                int length = 10;
                String sortBy = "KD_DIST";
                String sortDir = "ASC";
                String search = "";
                String vbln_usulan = "202505";
                String vkd_bank = "200";
                String vkd_dist = "11";

                List<Map<String, Object>> detail = service.getDataMDftPerUpi(
                        start, length, sortBy, sortDir, search,
                        vbln_usulan, vkd_bank, vkd_dist, pesanOutput
                );

                System.out.println("Jumlah data detail: " + detail.size());

                for (Map<String, Object> row : detail) {
                    System.out.println(row);
                }

            } else {
                System.out.println("== TEST MODE: REKAP ==");

                String vbln_usulan = "202505";
                List<Map<String, Object>> rekap = service.getDataMPerPerUpi(vbln_usulan, pesanOutput);

                for (Map<String, Object> row : rekap) {
                    System.out.println(row);
                }
            }

            System.out.println("Pesan Output: " + (pesanOutput.isEmpty() ? "Tidak ada pesan" : pesanOutput.get(0)));

        } catch (Exception e) {
            System.err.println("Error saat testing: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
