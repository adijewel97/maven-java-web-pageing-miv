package com.example.service;

import java.sql.*;
import java.util.*;
import java.util.logging.Logger;
import javax.sql.DataSource;
import com.example.utils.LoggerUtil;
import oracle.jdbc.OracleTypes;

public class BpblService {
    private DataSource dataSource;
    private static final Logger logger = LoggerUtil.getLogger(BpblService.class);

    public BpblService(DataSource dataSource) {
        this.dataSource = dataSource;
    }
    
    public List<Map<String, Object>> getBpblData(int start, int length, String sortBy, String sortDir, String search,
                                                 String sumberData, String tahun, String data, String option
                                                 , String idOption, String idkolektif,
                                                 List<String> pesanOutput) {

        logger.info("Memulai panggilan prosedur Oracle dengan parameter tahun: " + tahun);
        List<Map<String, Object>> result = new ArrayList<>();

        String sql = "{call BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY.S_BPBLPRASURVEY_DAFTAR_PGS(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection conn = dataSource.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
             
            stmt.setInt(1, start);
            stmt.setInt(2, length);
            stmt.setString(3, sortDir); // DESC
            stmt.setString(4, sortBy);  // UNITUP
            stmt.setString(5, search);
            stmt.setString(6, sumberData);
            stmt.setString(7, tahun);
            stmt.setString(8, data);
            stmt.setString(9, option);
            stmt.setString(10, idOption);
            stmt.setString(11, idkolektif);
            stmt.registerOutParameter(12, OracleTypes.CURSOR); // out_data
            stmt.registerOutParameter(13, Types.VARCHAR);      // pesan

            stmt.execute();
            logger.info("Prosedur Utama berhasil dieksekusi");


            try (ResultSet rs = (ResultSet) stmt.getObject(12)) {
                // Chek filed yg di tkirim dari backend
                // ResultSetMetaData meta = rs.getMetaData();
                // int columnCount = meta.getColumnCount();
                // for (int i = 1; i <= columnCount; i++) {
                //     System.out.println(meta.getColumnName(i));
                // }
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("TOTAL_COUNT", rs.getString("TOTAL_COUNT"));
                    row.put("DATA", rs.getString("DATA"));
                    row.put("ID_KOLEKTIF", rs.getString("ID_KOLEKTIF"));
                    row.put("IDURUT_BPBL", rs.getString("IDURUT_BPBL"));
                    row.put("TANGGAL_USULAN", rs.getString("TANGGAL_USULAN"));
                    row.put("KODE_PENGUSUL", rs.getString("KODE_PENGUSUL"));
                    row.put("NAMA_PELANGGAN", rs.getString("NAMA_PELANGGAN"));
                    row.put("NIK", rs.getString("NIK"));
                    row.put("ALAMAT", rs.getString("ALAMAT"));
                    row.put("KD_PROV", rs.getString("KD_PROV"));
                    row.put("KD_PROV_USULAN", rs.getString("KD_PROV_USULAN"));
                    row.put("PROVINSI", rs.getString("PROVINSI"));
                    row.put("PROVINSI_USULAN", rs.getString("PROVINSI_USULAN"));
                    row.put("KD_KAB", rs.getString("KD_KAB"));
                    row.put("KD_KAB_USULAN", rs.getString("KD_KAB_USULAN"));
                    row.put("KABUPATENKOTA", rs.getString("KABUPATENKOTA"));
                    row.put("KABUPATENKOTA_USULAN", rs.getString("KABUPATENKOTA_USULAN"));
                    row.put("KD_KEC", rs.getString("KD_KEC"));
                    row.put("KD_KEC_USULAN", rs.getString("KD_KEC_USULAN"));
                    row.put("KECAMATAN", rs.getString("KECAMATAN"));
                    row.put("KECAMATAN_USULAN", rs.getString("KECAMATAN_USULAN"));
                    row.put("KD_KEL", rs.getString("KD_KEL"));
                    row.put("KD_KEL_USULAN", rs.getString("KD_KEL_USULAN"));
                    row.put("DESAKELURAHAN", rs.getString("DESAKELURAHAN"));
                    row.put("DESAKELURAHAN_USULAN", rs.getString("DESAKELURAHAN_USULAN"));
                    row.put("UNITUPI", rs.getString("UNITUPI"));
                    row.put("NAMA_UNITUPI", rs.getString("NAMA_UNITUPI"));
                    row.put("UNITAP", rs.getString("UNITAP"));
                    row.put("NAMA_UNITAP", rs.getString("NAMA_UNITAP"));
                    row.put("UNITUP", rs.getString("UNITUP"));
                    row.put("NAMA_UNITUP", rs.getString("NAMA_UNITUP"));
                    row.put("STATUS_UPLOAD", rs.getString("STATUS_UPLOAD"));
                    row.put("STATUS_DATA", rs.getString("STATUS_DATA"));
                    row.put("USER_ID", rs.getString("USER_ID"));
                    row.put("TGL_UPLOAD", rs.getString("TGL_UPLOAD"));
                    row.put("NAMA_FILE_UPLOAD", rs.getString("NAMA_FILE_UPLOAD"));
                    row.put("PATH_FILE", rs.getString("PATH_FILE"));
                    row.put("DOKUMEN_UPLOAD", rs.getString("DOKUMEN_UPLOAD"));
                    row.put("PATH_DOKUMEN", rs.getString("PATH_DOKUMEN"));
                    row.put("SURAT_VALDES", rs.getString("SURAT_VALDES"));
                    row.put("PRIORITAS", rs.getString("PRIORITAS"));
                    row.put("VERIFIKASI_DJK", rs.getString("VERIFIKASI_DJK"));
                    row.put("SUMBER_DATA", rs.getString("SUMBER_DATA"));
                    row.put("KETERANGAN", rs.getString("KETERANGAN"));
                    row.put("TAHUN", rs.getString("TAHUN"));
                    row.put("TGL_KOREKSI", rs.getString("TGL_KOREKSI"));
                    row.put("USERID_KOREKSI", rs.getString("USERID_KOREKSI"));
                    row.put("NAMA_FILE_KOREKSI", rs.getString("NAMA_FILE_KOREKSI"));
                    row.put("PATH_FILE_KOREKSI", rs.getString("PATH_FILE_KOREKSI"));
                    row.put("USERID_VERIFIKASI", rs.getString("USERID_VERIFIKASI"));
                    row.put("STATUS_VERIFIKASI", rs.getString("STATUS_VERIFIKASI"));
                    row.put("TGL_VERIFIKASI", rs.getString("TGL_VERIFIKASI"));
                    row.put("STATUS_KIRIM", rs.getString("STATUS_KIRIM"));
                    row.put("STATUS_CUTOFF", rs.getString("STATUS_CUTOFF"));
                    row.put("ROW_NUMBER", rs.getString("ROW_NUMBER"));
                    // Tambahkan kolom lain jika diperlukan
                    result.add(row);
                }
            }

            String pesan = stmt.getString(13);
            pesanOutput.add(pesan);

        } catch (SQLException e) {
            logger.severe("Kesalahan database: " + e.getMessage());
            pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
        }

        return result;
    }


    public List<Map<String, Object>> getcombojenislaporan(List<String> pesanOutput) {

        logger.info("Memanggil package combobox Jenis Laporan");
        List<Map<String, Object>> result = new ArrayList<>();

        String sql = "{call BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY.PILIH_JENIS_LAPORAN(?, ?)}";

        try (Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.registerOutParameter(1, OracleTypes.CURSOR); // out_data
            stmt.registerOutParameter(2, Types.VARCHAR);      // pesan

            stmt.execute();
            logger.info("Prosedur Jenis Laporan berhasil dieksekusi");

            try (ResultSet rs = (ResultSet) stmt.getObject(1)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("kode", rs.getString("kode"));
                    row.put("laporan", rs.getString("laporan"));
                    result.add(row);
                }
            }

            String pesan = stmt.getString(2);
            pesanOutput.add(pesan);

        } catch (SQLException e) {
            logger.severe("Kesalahan database: " + e.getMessage());
            pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
        }

        return result;
    }

    public List<Map<String, Object>> getcombosumberdata(List<String> pesanOutput) {

        logger.info("Memanggil package combobox Sumber Data");
        List<Map<String, Object>> result = new ArrayList<>();

        String sql = "{call BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY.PILIH_SUMBER_DATA(?, ?)}";

        try (Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.registerOutParameter(1, OracleTypes.CURSOR); // out_data
            stmt.registerOutParameter(2, Types.VARCHAR);      // pesan

            stmt.execute();
            logger.info("Prosedur Sumber berhasil dieksekusi");

            try (ResultSet rs = (ResultSet) stmt.getObject(1)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("kode", rs.getString("kode"));
                    row.put("sumber_data", rs.getString("sumber_data"));
                    result.add(row);
                }
            }

            String pesan = stmt.getString(2);
            pesanOutput.add(pesan);

        } catch (SQLException e) {
            logger.severe("Kesalahan database: " + e.getMessage());
            pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
        }

        return result;
    }

}
