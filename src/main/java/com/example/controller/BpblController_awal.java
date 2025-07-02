package com.example.controller;

import com.example.service.BpblService;
import com.example.service.DbService;
import com.example.utils.LoggerUtil;
import com.google.gson.Gson;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BpblController_awal extends HttpServlet {
    private BpblService service;
    private static final Logger logger = LoggerUtil.getLogger(BpblController_awal.class);
    private Gson gson = new Gson();

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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Ambil parameter DataTables
        String drawParam = req.getParameter("draw");
        String startParam = req.getParameter("start");
        String lengthParam = req.getParameter("length");
        String searchValue = req.getParameter("search[value]");
        String orderColumnIndex = req.getParameter("order[10][column]");
        String orderDir = req.getParameter("order[10][dir]");

        // Ambil parameter vtahun dan voption dari request (combo box)
        String vtahun  = req.getParameter("vtahun");
        String voption = req.getParameter("voption");
        String vdata   = req.getParameter("vdata");
        String vidkolektif   = req.getParameter("vidkolektif");

        // Beri nilai default jika null
        if (vtahun == null || vtahun.isEmpty()) {
            vtahun = "2025";
        }
        if (voption == null || voption.isEmpty()) {
            voption = "PROVINSI";
        }

        int draw = (drawParam != null) ? Integer.parseInt(drawParam) : 1;
        int start = (startParam != null) ? Integer.parseInt(startParam) : 0;
        int length = (lengthParam != null) ? Integer.parseInt(lengthParam) : 10;

        // Konversi start ke page (1-based)
        int page = (start / length) + 1;

        // Default sorting column berdasarkan voption
        String orderBy;
        switch (voption.toUpperCase()) {
            case "PROVINSI":
                orderBy = "KD_PROV";
                break;
            case "UPI":
                orderBy = "UNITUPI";
                break;
            case "PENGUSUL":
                orderBy = "KD_PROV";
                break;
            default:
                orderBy = "UNITUP"; // fallback default
                break;
        }

        // Default sorting column (ubah sesuai kolom di DB/prosedur)
        String[] columns = {"DATA", "ID_KOLEKTIF", "IDURUT_BPBL", "TANGGAL_USULAN", "KODE_PENGUSUL", "NAMA_PELANGGAN", "NIK", "ALAMAT", "UNITUPI", "KD_PROV", "KD_PROV_USULAN", "PROVINSI"};
        if (orderColumnIndex != null) {
            try {
                int colIndex = Integer.parseInt(orderColumnIndex);
                if (colIndex >= 0 && colIndex < columns.length) {
                    orderBy = columns[colIndex];
                }
            } catch (NumberFormatException e) {
                // fallback ke default orderBy
            }
        }

        if (orderDir == null || (!orderDir.equalsIgnoreCase("asc") && !orderDir.equalsIgnoreCase("desc"))) {
            orderDir = "ASC"; // default
        } else {
            orderDir = orderDir.toUpperCase(); // ubah ke huruf besar ASC / DESC
        }

        logger.info("Page: " + page + ", Length: " + length + ", Start: " + start);

        List<String> pesanOutput = new ArrayList<>();
        List<Map<String, Object>> data = Collections.emptyList();
        int totalCount = 0;

        try {
            // Panggil service dengan paging & sorting
            data = service.getBpblData(
                page, length,
                orderDir,
                orderBy,
                searchValue != null ? searchValue : "",
                "SEMUA",
                vtahun,             // vtahun dari parameter combo
                vdata,
                voption,            // voption dari parameter combo
                "SEMUA",
                vidkolektif,
                pesanOutput
            );

            // Ambil total_count dari hasil (misal total_count di field TOTAL_COUNT dari baris pertama)
            if (!data.isEmpty()) {
                Object totalCountObj = data.get(0).get("TOTAL_COUNT");
                if (totalCountObj instanceof Number) {
                    totalCount = ((Number) totalCountObj).intValue();
                } else if (totalCountObj != null) {
                    try {
                        totalCount = Integer.parseInt(totalCountObj.toString());
                    } catch (NumberFormatException ex) {
                        totalCount = data.size();
                    }
                } else {
                    totalCount = data.size();
                }
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal mendapatkan data", e);
        }

        // Susun response JSON untuk DataTables
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("draw", draw);
        jsonResponse.put("recordsTotal", totalCount);
        jsonResponse.put("recordsFiltered", totalCount);
        jsonResponse.put("data", data);

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

}
