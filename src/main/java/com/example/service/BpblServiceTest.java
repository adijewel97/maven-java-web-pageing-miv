package com.example.service;

import java.util.*;
import java.util.logging.*;
import java.io.InputStream;
import com.example.utils.LoggerUtil;
import oracle.jdbc.pool.OracleDataSource;

public class BpblServiceTest {
    private static final Logger logger = LoggerUtil.getLogger(BpblServiceTest.class);

    public static void main(String[] args) {
        Properties props = new Properties();

        try (InputStream input = BpblServiceTest.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                logger.severe("File db.properties tidak ditemukan di classpath.");
                return;
            }
            props.load(input);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal load file db.properties", e);
            return;
        }

        try {
            OracleDataSource ods = new OracleDataSource();
            ods.setURL(props.getProperty("db.url"));
            ods.setUser(props.getProperty("db.user"));
            ods.setPassword(props.getProperty("db.password"));

            BpblService service = new BpblService(ods);

            List<String> pesanOutput = new ArrayList<>();

            List<Map<String, Object>> data = service.getBpblData(
                // 1,  10, "UNITUPI", "ASC", "", "SEMUA", "2025", "TOTAL", "PROVINSI", "SEMUA", pesanOutput);
                  1, 5, "DESC", "UNITUP", "", "SEMUA", "2025","TOTAL_SUMBER", "PROVINSI", "SEMUA", "KOL125", pesanOutput);

            logger.info("Jumlah data yang didapat: " + data.size());
            for (Map<String, Object> row : data) {
                logger.info("ID_KOLEKTIF: " + row.get("ID_KOLEKTIF") + ", NAMA_PELANGGAN: " + row.get("NAMA_PELANGGAN"));
            }

            if (!pesanOutput.isEmpty()) {
                logger.info("Pesan output DB: " + pesanOutput.get(0));
            } else {
                logger.info("Tidak ada pesan output dari DB");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal konek ke database atau ambil data", e);
        }
    }
}
