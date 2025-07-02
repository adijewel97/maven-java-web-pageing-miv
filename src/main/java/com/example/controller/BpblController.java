package com.example.controller;

import com.example.service.BpblService;
import com.example.service.DbService;
import com.example.utils.LoggerUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BpblController extends HttpServlet {
    private BpblService service;
    private static final Logger logger = LoggerUtil.getLogger(BpblController.class);
    private final Gson gson = new Gson();

    private static final String ACT_JENIS_LAPORAN = "handleGetJenisLaporan";
    private static final String ACT_SUMBER_DATA = "handleGetsumberdata";

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            DbService dbService = new DbService();
            service = new BpblService(dbService.getDataSource());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal inisialisasi koneksi DB di init()", e);
            throw new ServletException("Gagal inisialisasi koneksi DB", e);
        }
    }

    @Override
    // protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
 
        String act = req.getParameter("act");
        logger.info("DEBUG: act = " + act);

        if (ACT_JENIS_LAPORAN.equalsIgnoreCase(act)) {
            handleGetJenisLaporan(req, resp);
            return;
        }

        if (ACT_SUMBER_DATA.equalsIgnoreCase(act)) {
            handleGetsumberdata(req, resp);
            return;
        }

        // Default: proses data utama
        prosesDataUtama(req, resp);
    }

    private void prosesDataUtama(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Ambil parameter dasar dari request
        String drawParam = req.getParameter("draw");
        String startParam = req.getParameter("start");
        String lengthParam = req.getParameter("length");
        String searchValue = Optional.ofNullable(req.getParameter("search[value]")).orElse("");
        String orderColumnIndex = req.getParameter("order[0][column]");
        String orderDir = Optional.ofNullable(req.getParameter("order[0][dir]")).orElse("asc");

        String vkd_sumberdata = req.getParameter("vkd_sumberdata");
        String vtahun         = Optional.ofNullable(req.getParameter("vtahun")).filter(s -> !s.isEmpty()).orElse("2025");
        String vdata          = req.getParameter("vdata");
        String voption        = Optional.ofNullable(req.getParameter("voption")).filter(s -> !s.isEmpty()).orElse("PROVINSI");
        String vidoption      = req.getParameter("vidoption");
        String vidkolektif    = req.getParameter("vidkolektif");
        boolean all           = "true".equalsIgnoreCase(req.getParameter("all"));

        int draw = parseIntOrDefault(drawParam, 1);
        int start = parseIntOrDefault(startParam, 0);
        int length = parseIntOrDefault(lengthParam, 10);
        int page = (start / length) + 1;

        if (all) {
            page = 1;
            length = Integer.MAX_VALUE; // Atur sesuai kebutuhan, misalnya unlimited
        }

        logger.info("=== prosesDataUtama Parameters ===");
        logger.info("draw: " + draw);
        logger.info("start: " + start);
        logger.info("length: " + length);
        logger.info("page: " + page);
        logger.info("searchValue: " + searchValue);
        logger.info("vtahun: " + vtahun);
        logger.info("vdata: " + vdata);
        logger.info("voption: " + voption);
        logger.info("vidoption: " + vidoption);
        logger.info("vidkolektif: " + vidkolektif);
        logger.info("all: " + all);
        logger.info("orderColumnIndex: " + orderColumnIndex);
        logger.info("orderDir: " + orderDir);

        // Daftar kolom database sesuai urutan kolom data tanpa nomor urut di client
        String[] columns = {
            "TOTAL_COUNT", 
            "DATA", 
            "ID_KOLEKTIF", 
            "IDURUT_BPBL", 
            "TANGGAL_USULAN", 
            "KODE_PENGUSUL", 
            "NAMA_PELANGGAN", 
            "NIK", 
            "ALAMAT", 
            "KD_PROV", 
            "KD_PROV_USULAN", 
            "PROVINSI", 
            "PROVINSI_USULAN", 
            "KD_KAB", 
            "KD_KAB_USULAN", 
            "KABUPATENKOTA", 
            "KABUPATENKOTA_USULAN", 
            "KD_KEC", 
            "KD_KEC_USULAN", 
            "KECAMATAN", 
            "KECAMATAN_USULAN", 
            "KD_KEL", 
            "KD_KEL_USULAN", 
            "DESAKELURAHAN", 
            "DESAKELURAHAN_USULAN", 
            "UNITUPI", 
            "NAMA_UNITUPI", 
            "UNITAP", 
            "NAMA_UNITAP", 
            "UNITUP", 
            "NAMA_UNITUP", 
            "STATUS_UPLOAD", 
            "STATUS_DATA", 
            "USER_ID", 
            "TGL_UPLOAD", 
            "NAMA_FILE_UPLOAD", 
            "PATH_FILE", 
            "DOKUMEN_UPLOAD", 
            "PATH_DOKUMEN", 
            "SURAT_VALDES", 
            "PRIORITAS", 
            "VERIFIKASI_DJK", 
            "SUMBER_DATA", 
            "KETERANGAN", 
            "TAHUN", 
            "TGL_KOREKSI", 
            "USERID_KOREKSI", 
            "NAMA_FILE_KOREKSI", 
            "PATH_FILE_KOREKSI", 
            "USERID_VERIFIKASI", 
            "STATUS_VERIFIKASI", 
            "TGL_VERIFIKASI", 
            "STATUS_KIRIM", 
            "STATUS_CUTOFF", 
            "ROW_NUMBER", 
        };

        // Default orderBy sesuai voption
        String orderByDefault = switch (voption.toUpperCase()) {
            case "PROVINSI" -> "KD_PROV";
            case "UPI" -> "UNITUPI";
            case "PENGUSUL" -> "KD_PROV";
            default -> "UNITUP";
        };

        // Karena DataTables menambahkan kolom nomor urut sebagai kolom ke-0, indeks kolom sebenarnya data server mulai dari 1
        String orderBy = orderByDefault;
        if (orderColumnIndex != null) {
            try {
                int colIndex = Integer.parseInt(orderColumnIndex);
                if (colIndex > 0 && colIndex < columns.length + 1) {  
                    // Kurangi 1 karena kolom 0 adalah nomor urut yang tidak ada di columns
                    orderBy = columns[colIndex - 1];
                } else {
                    orderBy = orderByDefault;
                }
            } catch (NumberFormatException e) {
                logger.warning("orderColumnIndex bukan angka: " + orderColumnIndex);
                orderBy = orderByDefault;
            }
        }

        orderDir = orderDir.equalsIgnoreCase("desc") ? "DESC" : "ASC";

        logger.info("Final orderBy: " + orderBy + ", orderDir: " + orderDir);

        List<Map<String, Object>> data = Collections.emptyList();
        int totalCount = 0;

        try {
            List<String> pesanOutput = new ArrayList<>();
            data = service.getBpblData(
                page, length,
                orderDir, orderBy,
                searchValue,
                vkd_sumberdata,
                vtahun,
                vdata,
                voption,
                vidoption,
                vidkolektif,
                pesanOutput
            );

            if (!data.isEmpty()) {
                Object totalCountObj = data.get(0).get("TOTAL_COUNT");
                totalCount = parseTotalCount(totalCountObj, data.size());
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal mendapatkan data", e);
        }

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("draw", draw);
        jsonResponse.put("recordsTotal", totalCount);
        jsonResponse.put("recordsFiltered", totalCount);
        jsonResponse.put("data", data);

        resp.setContentType("application/json");
        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(jsonResponse));
        }
    }

    private void handleGetJenisLaporan(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> responseData = new HashMap<>();
        List<String> pesanOutput = new ArrayList<>();

        try {
            List<Map<String, Object>> listJenis = service.getcombojenislaporan(pesanOutput);

            responseData.put("status", "success");
            responseData.put("data", listJenis != null ? listJenis : Collections.emptyList());
            responseData.put("pesan", pesanOutput.isEmpty() ? "" : pesanOutput.get(0));
        } catch (Exception e) {
            logger.severe("Kesalahan saat memproses Jenis Laporan: " + e.getMessage());
            responseData.put("status", "error");
            responseData.put("data", Collections.emptyList());
            responseData.put("pesan", "Terjadi kesalahan: " + e.getMessage());
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(responseData));
            out.flush();
        }
    }

    private void handleGetsumberdata(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> responseData = new HashMap<>();
        List<String> pesanOutput = new ArrayList<>();

        try {
            List<Map<String, Object>> listSumber = service.getcombosumberdata(pesanOutput); // <-- ganti jika beda method
            responseData.put("status", "success");
            responseData.put("data", listSumber != null ? listSumber : Collections.emptyList());
            responseData.put("pesan", pesanOutput.isEmpty() ? "" : pesanOutput.get(0));
        } catch (Exception e) {
            logger.severe("Kesalahan saat memproses Sumber Data: " + e.getMessage());
            responseData.put("status", "error");
            responseData.put("data", Collections.emptyList());
            responseData.put("pesan", "Terjadi kesalahan: " + e.getMessage());
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(responseData));
            out.flush();
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return value != null ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int parseTotalCount(Object totalCountObj, int fallback) {
        if (totalCountObj instanceof Number) {
            return ((Number) totalCountObj).intValue();
        } else if (totalCountObj != null) {
            try {
                return Integer.parseInt(totalCountObj.toString());
            } catch (NumberFormatException ignored) {}
        }
        return fallback;
    }
}
