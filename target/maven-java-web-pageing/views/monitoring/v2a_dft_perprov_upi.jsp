<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="pt-4 px-4">
    <h2 class="page-title">Daftar Pelanggan BPBL Per Provinsi / UPI</h2>

    <div class="container mt-4">
        <div class="form-monitoring">
            <h5 class="section-title">Daftar Temuan Baru Per UPI / Provinsi</h5>

            <form id="form-monitoring">
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label for="jenis" class="form-label">Jenis</label>
                        <select class="form-select" id="jenis" name="jenis">
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="selectdata" class="form-label">Kriteria Data</label>
                        <select id="selectdata" class="form-select">
                            <option value="TOTAL_SUMBER">TOTAL SUMBER</option>
                            <option value="NIK_BLM_VALID">NIK BELUM VALID</option>
                            <option value="NIK_VALID">NIK VALID</option>
                            <option value="NIK_VALID_KOREKSI">NIK VALID KOREKSI</option>
                            <option value="BLM_VERIFIKASI_DJK">BELUM VERIFIKASI DJK</option>
                            <option value="VERIFIKASI_DJK">VERIFIKASI DJK</option>
                            <option value="VERIFIKASI_DJK_MANUAL">VERIFIKASI DJK MANUAL</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="selectTahun" class="form-label">Tahun</label>
                        <select class="form-select" id="selectTahun" name="selectTahun">
                            <option value="2025">2025</option>
                            <option value="2024">2024</option>
                            <option value="2023">2023</option>
                        </select>
                    </div>
                </div>                

                <div class="row">
                    <div class="col-md-12 text-start">
                        <button id="btnTampil" type="button" class="btn btn-primary">
                            <i class="bi bi-search"></i> Tampilkan
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="mt-4">
            <div class="mb-2">
                <button id="downloadExcelBtnPage" class="btn btn-success btn-export">Download Excel Per Halaman</button>
                <button id="downloadExcelBtnAll" class="btn btn-primary btn-export">Download Excel Semua Halaman</button>
            </div>

            <!-- Menggunakan class dari CSS external -->
            <div class="datatable-container">
                <table id="table_mondaf_provupi" class="datatable-main">
                    <thead>
                        <tr>
                            <th>No</th>
                            <!-- <th>TOTAL_COUNT</th>  -->
                            <th>DATA</th> 
                            <th>ID_KOLEKTIF</th> 
                            <th>IDURUT_BPBL</th> 
                            <th>TANGGAL_USULAN</th> 
                            <th>KODE_PENGUSUL</th> 
                            <th>NAMA_PELANGGAN</th> 
                            <th>NIK</th> 
                            <th>ALAMAT</th> 
                            <th>KD_PROV</th> 
                            <th>KD_PROV_USULAN</th> 
                            <th>PROVINSI</th> 
                            <th>PROVINSI_USULAN</th> 
                            <th>KD_KAB</th> 
                            <th>KD_KAB_USULAN</th> 
                            <th>KABUPATENKOTA</th> 
                            <th>KABUPATENKOTA_USULAN</th> 
                            <th>KD_KEC</th> 
                            <th>KD_KEC_USULAN</th> 
                            <th>KECAMATAN</th> 
                            <th>KECAMATAN_USULAN</th> 
                            <th>KD_KEL</th> 
                            <th>KD_KEL_USULAN</th> 
                            <th>DESAKELURAHAN</th> 
                            <th>DESAKELURAHAN_USULAN</th> 
                            <th>UNITUPI</th> 
                            <th>NAMA_UNITUPI</th> 
                            <th>UNITAP</th> 
                            <th>NAMA_UNITAP</th> 
                            <th>UNITUP</th> 
                            <th>NAMA_UNITUP</th> 
                            <th>STATUS_UPLOAD</th> 
                            <th>USER_ID</th> 
                            <th>TGL_UPLOAD</th> 
                            <th>NAMA_FILE_UPLOAD</th> 
                            <th>PATH_FILE</th> 
                            <th>DOKUMEN_UPLOAD</th> 
                            <th>PATH_DOKUMEN</th> 
                            <th>SURAT_VALDES</th> 
                            <th>PRIORITAS</th> 
                            <th>VERIFIKASI_DJK</th> 
                            <th>SUMBER_DATA</th> 
                            <th>KETERANGAN</th> 
                            <th>TAHUN</th> 
                            <th>TGL_KOREKSI</th> 
                            <th>USERID_KOREKSI</th> 
                            <th>NAMA_FILE_KOREKSI</th> 
                            <th>PATH_FILE_KOREKSI</th> 
                            <th>USERID_VERIFIKASI</th> 
                            <th>STATUS_VERIFIKASI</th> 
                            <th>TGL_VERIFIKASI</th> 
                            <!-- <th>ROW_NUMBER</th>  -->
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        
        </div>
    </div>
</div>

<!-- SheetJS untuk export Excel -->
<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>

<script>
    $(document).ready(function () {
        var orderColumnMap = {
            'PROVINSI': 12,  // Kolom PROVINSI index ke-12 (0 based)
            'UPI': 25,       // Kolom UNITUPI index ke-25
            'PENGUSUL': 6    // KODE_PENGUSUL index ke-6
        };

        // Panggil controller saat halaman dimuat
        $.ajax({
            url: '<%= request.getContextPath() %>/bpbl?act=handleGetJenisLaporan',
            method: 'POST',
            dataType: 'json',
            success: function (response) {
                var jenisSelect = $('#jenis');
                jenisSelect.empty();

                var dataList = response.data || [];
                console.log("combo 1");
                console.log(dataList);

                $.each(dataList, function (i, item) {
                    jenisSelect.append($('<option>', {
                        value: item.kode,
                        text: item.laporan                    
                    }));
                });
            },
            error: function (xhr, status, error) {
                console.error('Gagal mengambil data combo jenis laporan:', error);
            }
        });

        $.ajax({
            url: '<%= request.getContextPath() %>/bpbl?act=handleGetsumberdata',
            method: 'POST',
            dataType: 'json',
            success: function (response) {
                var jenisSelect = $('#selectsumberdata');
                jenisSelect.empty();

                var dataList = response.data || [];
                console.log("combo 2");
                console.log(dataList);

                $.each(dataList, function (i, item) {
                    jenisSelect.append($('<option>', {
                        value: item.kode,
                        text: item.sumber_data                    
                    }));
                });
            },
            error: function (xhr, status, error) {
                console.error('Gagal mengambil data combo jenis laporan:', error);
            }
        });
        
        var table = $('#table_mondaf_provupi').DataTable({
            processing: true,
            serverSide: true,
            scrollX: true,
            paging: true,
            ajax: {
                url: '<%= request.getContextPath() %>/bpbl',
                type: 'POST',
                data: function (d) {
                    d.vtahun = $('#selectTahun').val();
                    d.voption = $('#jenis').val();
                    d.vdata = $('#selectdata').val();
                },
                dataSrc: function (json) {
                    console.log('Response JSON:', json);
                    return json.data;
                },
                error: function (xhr, error, thrown) {
                    console.error('Status:', status);
                    console.error('Error thrown:', error);
                    console.error('Response:', xhr.responseText);
                }
            },
            columns: [
                {
                    data: null,
                    render: function (data, type, row, meta) {
                        return meta.row + 1 + meta.settings._iDisplayStart;
                    }
                },
                ...[
                    // "TOTAL_COUNT", 
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
                    // "ROW_NUMBER"
                ].map(field => ({
                    data: field,
                    defaultContent: '-',
                    render: function (data, type, row) {
                        return typeof data === 'string' ? data.toUpperCase() : data;
                    }
                }))
            ],
            lengthMenu: [[10, 100, 5000], [10, 100, 5000]],
            pageLength: 10,
            dom: 'lfrtip',
            buttons: [
                {
                    extend: 'excel',
                    title: 'Daftar BPBL',
                    className: 'd-none',
                    exportOptions: {
                        columns: ':visible'
                    }
                }
            ]
        });

        $('#btnTampil').click(function () {
            table.ajax.reload(null, true);
        });

        $('#jenis, #selectdata, #selectTahun, #selectsumberdata').on('change', function () {
            table.ajax.reload();
        });

        $('#downloadExcelBtnPage').on('click', function () {
            table.button('.buttons-excel').trigger();
        });

        $('#downloadExcelBtnAll').on('click', async function () {
            const btn = $(this);

            const vtahun  = $('#selectTahun').val();
            const voption = $('#jenis').val();
            const vdata   = $('#selectdata').val();

            if (!vtahun || !voption || !vdata) {
                alert('Silakan pilih Tahun, Jenis, dan Kriteria Data terlebih dahulu!');
                return;
            }

            const info = table.page.info();
            const start = info.start;
            const length = info.length;

            btn.prop('disabled', true).text('Memuat...');

            try {
                const baseUrl = window.location.origin;
                const url = baseUrl + "<%= request.getContextPath() %>/bpbl";

                const params = new URLSearchParams();
                params.append('all', 'true');
                params.append('vtahun', vtahun);
                params.append('voption', voption);
                params.append('vdata', vdata);
                params.append('start', start);
                params.append('length', length);

                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params.toString()
                });

                if (!response.ok) {
                    throw new Error('Gagal mengambil data dari server');
                }

                const json = await response.json();
                const allData = json.data || [];

                const headers = {
                    // 'TOTAL_COUNT': '',
                    'DATA': '',
                    'ID_KOLEKTIF': '',
                    'IDURUT_BPBL': '',
                    'TANGGAL_USULAN': '',
                    'KODE_PENGUSUL': '',
                    'NAMA_PELANGGAN': '',
                    'NIK': '',
                    'ALAMAT': '',
                    'KD_PROV': '',
                    'KD_PROV_USULAN': '',
                    'PROVINSI': '',
                    'PROVINSI_USULAN': '',
                    'KD_KAB': '',
                    'KD_KAB_USULAN': '',
                    'KABUPATENKOTA': '',
                    'KABUPATENKOTA_USULAN': '',
                    'KD_KEC': '',
                    'KD_KEC_USULAN': '',
                    'KECAMATAN': '',
                    'KECAMATAN_USULAN': '',
                    'KD_KEL': '',
                    'KD_KEL_USULAN': '',
                    'DESAKELURAHAN': '',
                    'DESAKELURAHAN_USULAN': '',
                    'UNITUPI': '',
                    'NAMA_UNITUPI': '',
                    'UNITAP': '',
                    'NAMA_UNITAP': '',
                    'UNITUP': '',
                    'NAMA_UNITUP': '',
                    'STATUS_UPLOAD': '',
                    'USER_ID': '',
                    'TGL_UPLOAD': '',
                    'NAMA_FILE_UPLOAD': '',
                    'PATH_FILE': '',
                    'DOKUMEN_UPLOAD': '',
                    'PATH_DOKUMEN': '',
                    'SURAT_VALDES': '',
                    'PRIORITAS': '',
                    'VERIFIKASI_DJK': '',
                    'SUMBER_DATA': '',
                    'KETERANGAN': '',
                    'TAHUN': '',
                    'TGL_KOREKSI': '',
                    'USERID_KOREKSI': '',
                    'NAMA_FILE_KOREKSI': '',
                    'PATH_FILE_KOREKSI': '',
                    'USERID_VERIFIKASI': '',
                    'STATUS_VERIFIKASI': '',
                    'TGL_VERIFIKASI': '',
                    // 'ROW_NUMBER': ''
                };

                const formattedData = allData.length > 0
                    ? allData.map((item) => {
                        const row = {};
                        Object.keys(headers).forEach((key) => {
                            const value = item[key];
                            row[key] = (typeof value === 'string') ? value.toUpperCase() : value;
                        });
                        row['NO'] = item.ROW_NUMBER; // Tetap gunakan nomor urut asli
                        return row;
                    })
                    : [];

                const ws = XLSX.utils.json_to_sheet(formattedData, { header: Object.keys(headers) });
                const wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, ws, "BPBL Semua Data");

                const filename = "BPBL_" + voption + "_" + vdata + "_" + vtahun + ".xlsx";
                XLSX.writeFile(wb, filename);

            } catch (error) {
                alert('Terjadi kesalahan saat mengambil data: ' + error.message);
                console.error('Detail error:', error);
            } finally {
                btn.prop('disabled', false).text('Download Excel Semua Halaman');
            }
        });

    });
</script>