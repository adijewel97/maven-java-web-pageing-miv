<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
   /* CSS TABLE REKAP - SAMAKAN DENGAN TABEL DAFTAR */
    #tablemon_upi {
        table-layout: auto; /* Sama seperti #dataModal table */
        font-size: 0.75rem; /* Sama dengan modal-body */
        width: 100%;
    }

    #tablemon_upi th,
    #tablemon_upi td {
        font-size: 0.7rem;      /* Sama seperti table detail */
        padding: 4px 6px;       /* Sama seperti table detail */
        white-space: nowrap;    /* Hindari wrap */
        overflow: hidden;
        text-overflow: ellipsis;
    }

    #tablemon_upi th.sorting::after,
    #tablemon_upi th.sorting_asc::after,
    #tablemon_upi th.sorting_desc::after {
        display: none !important;
    }

    /* Tambahan jika mau batas tinggi + scroll seperti modal */
    #tablemon_upi_wrapper .dataTables_scrollBody {
        max-height: 65vh;       /* Sesuaikan tinggi maksimal seperti modal */
        overflow-y: auto;
    }

    /* CSS MODAL SHOW TABLE MONITORING DAFTAR */
    #dataModal .modal-body {
        font-size: 0.75rem; /* Ukuran teks diperkecil */
    }

    #dataModal table th,
    #dataModal table td {
        font-size: 0.7rem;   /* Ukuran teks header dan isi tabel */
        padding: 4px 6px;    /* Padding dikurangi agar tidak terlalu lebar */
        white-space: nowrap; /* Hindari pemisahan baris */
    }

    #dataModal table {
        table-layout: auto; /* Gunakan auto agar kolom menyesuaikan konten */
    }

    #dataModal .datatable-container {
        max-height: 65vh;    /* Batasi tinggi agar bisa scroll */
        overflow-y: auto;
    }

    /* Pastikan form-container relatif */
    .form-monitoring {
        position: relative;
    }

    .datatable-container {
        overflow-x: auto;
        width: 100%;
    }


    /* Buat spinner tetap di tengah form tapi transparan */
    .loading-overlay {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 1050;
        text-align: center;
        font-size: 0.95rem;
        /* Tidak ada background, padding, atau box */
    }

    /* tambah lebar large modal */
    .modal-xxl {
        max-width: 98% !important; /* Atur sesuai kebutuhan */
    }

</style>

<!-- Tambahkan di bawah tombol #btnTampil:  -->
<div id="loadingSpinner" class="loading-overlay" style="display: none;">
  <div class="spinner-border text-primary" role="status">
    <span class="visually-hidden">Loading...</span>
  </div>
  <div class="mt-2 text-primary"><strong>Memuat data ...</strong></div>
</div>


<!-- Modal Large -->
<div class="modal fade" id="dataModal" tabindex="-1" aria-labelledby="dataModalLabel" aria-hidden="true">
  <!-- <div class="modal-dialog modal-dialog-scrollable modal-xl"> -->
  <div class="modal-dialog modal-dialog-scrollable modal-xl modal-xxl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="dataModalLabel">Detail Data</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
      </div>
      <div class="modal-body" id="modalBody">
        <div class="mb-2">
          <button id="downloadMonDftExcelBtnAll" class="btn btn-primary btn-export">
            Download Excel
          </button>
        </div>

        <!-- <div class="row g-3 mb-3">
          <div class="col-md-3">
            <label for="xbln_usulan">Bulan Usulan :</label>
            <input type="text" class="form-control" id="xbln_usulan">
          </div>
          <div class="col-md-3">
            <label for="xkd_dist">Kode Distribusi :</label>
            <input type="text" class="form-control" id="xkd_dist">
          </div>
        </div> -->

        <!-- <div class="datatable-container">
          <table id="table_mondaf_upi" class="table table-bordered table-striped w-100" width="100%"> -->
        <div class="datatable-container" style="overflow-x: auto;">
         <table id="table_mondaf_upi" class="table table-bordered table-striped w-100" width="100%">
                <thead>
                <tr>
                    <th>NO</th>
                    <!-- <th>TOTAL_COUNT</th> -->
                    <!-- <th>URUT</th> -->
                    <th>PRODUK</th>
                    <th>TGLAPPROVE</th>
                    <th>KD_DIST</th>
                    <th>VA</th>
                    <th>SATKER</th>
                    <th>PLN_NOUSULAN</th>
                    <!-- <th>PLN_KDPROSES</th>
                    <th>PLN_STATUS</th> -->
                    <th>PLN_IDPEL</th>
                    <th>PLN_BLTH</th>
                    <th>PLN_LUNAS_H0</th>
                    <th>PLN_RPTAG</th>
                    <th>PLN_RPBK</th>
                    <th>PLN_TGLBAYAR</th>
                    <th>PLN_JAMBAYAR</th>
                    <th>PLN_USERID</th>
                    <th>PLN_KDBANK</th>
                    <th>BANK_KETERANGAN</th>
                    <th>BANK_NOUSULAN</th>
                    <th>BANK_IDPEL</th>
                    <th>BANK_BLTH</th>
                    <th>BANK_RPTAG</th>
                    <th>BANK_RPBK</th>
                    <th>BANK_TGLBAYAR</th>
                    <th>BANK_JAMBAYAR</th>
                    <th>BANK_USERID</th>
                    <th>BANK_KDBANK</th>
                    <th>SELISIH_RPTAG</th>
                    <th>SELISIH_BK</th>
                    <th>KETERANGAN</th>
                    <!-- <th>ROW_NUMBER</th> -->
                </tr>
                </thead>
            <tbody>
            </tbody>
          </table>
        </div>          
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
      </div>
    </div>
  </div>
</div>

<div class="pt-4 px-4">
    <h2 class="page-title">Monitoring Rekon MIV PLN vs BANK (PerUPI)</h2>

    <div class="container mt-4">
        <div class="form-monitoring">
            <h5 class="section-title">Monitoring Per-UPI</h5>

            <form id="form-monitoring">
                <div class="row g-3 mb-3">
                    <div class="col-md-3">
                        <label for="bln_usulan">Bulan Laporan :</label>
                        <input type="text" class="form-control" id="bln_usulan" placeholder="YYYYMM = 202505" value="202505">
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
                <button id="downloadMonRekapExcelBtnPage" class="btn btn-success btn-export">Download Excel</button>
            </div>

            <div class="datatable-container">
                <div class="datatable-scroll-wrapper" style="overflow-x: auto;"></div>
                    <table id="tablemon_upi" class="datatable-main table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>NO</th> 
                                <!-- <th>KD_DIST</th>  -->
                                <th>NAMA_DIST</th> 
                                <!-- <th>URUT</th>  -->
                                <th>PRODUK</th> 
                                <th>BANK</th> 
                                <th>BULAN</th> 
                                <th>PLN_IDPEL</th> 
                                <th>PLN_RPTAG</th> 
                                <th>PLN_LB_LUNAS</th> 
                                <th>PLN_RP_LUNAS</th> 
                                <th>BANK_IDPEL</th> 
                                <th>BANK_RPTAG</th> 
                                <th>SELISIH_RPTAG</th> 
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


<script>
    $(document).ready(function () {
        let detailFilterParams = {};

        // memembat format number digit
        function formatNumber(value, fractionDigits = 2) {
            if (value == null || value === '') return '';
            const number = parseFloat(value);
            if (isNaN(number)) return value;
            return number.toLocaleString('id-ID', {
                minimumFractionDigits: fractionDigits,
                maximumFractionDigits: fractionDigits
            });
        }

        // Menapilkan loading saat proses sedang belangsung 
        var spinner = document.getElementById("loadingSpinner");
        if (spinner) {
            spinner.style.display = "block";
        } else {
            console.warn("Elemen #loadingSpinner tidak ditemukan di DOM");
        }

        // ---------------------------------------------------------------------------------------------
        // 1A) Tampilkan monitoring Rekap
        // ---------------------------------------------------------------------------------------------
        var table = $('#tablemon_upi').DataTable({
            processing: true,
            serverSide: true,
            scrollX: false,
            paging: false, // MATIKAN PAGING
            stripeClasses: [], // Nonaktifkan efek baris selang-seling
            searching: false, 
            autoWidth: false,
            ajax: {
                url: 'mon-rekon-bankvsperupi',
                type: 'POST',
                data: function (d) {
                    d.vbln_usulan = $('#bln_usulan').val(); // pastikan pakai '#'!
                }
            },
            columns: [
                {
                    data: null,
                    render: function (data, type, row, meta) {
                        if (row.KD_DIST !== null && row.KD_DIST !== undefined) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        } else {
                            return ''; // atau bisa juga 'N/A' atau '-'
                        }
                    }
                },
                // { data: 'KD_DIST' },
                // { data: 'NAMA_DIST' },
                // { data: 'URUT' },
                {
                    data: null,
                    render: function (data, type, row) {
                         if (!row.KD_DIST || !row.NAMA_DIST) {
                            return '';
                        } else {
                            return row.KD_DIST + ' - ' + row.NAMA_DIST;
                        }
                    }
                },
                { data: 'PRODUK',  defaultContent: '' },
                { data: 'BANK' ,  defaultContent: ''},
                { data: 'BLN_USULAN',  defaultContent: '' },
                { 
                    data: 'PLN_IDPEL',  
                    render: function (data) {
                        return formatNumber(data, 0);
                    }
                },
                { 
                    data: 'PLN_RPTAG',
                    render: function (data) {
                        return formatNumber(data, 0);
                    }
                },
                { 
                    data: 'PLN_LEBAR_LUNAS',  
                     render: function (data) {
                        return formatNumber(data, 0);
                    }
                },
                { 
                    data: 'PLN_RPTAG_LUNAS',  
                     render: function (data) {
                        return formatNumber(data, 0);
                    }
                },
                { 
                    data: 'BANK_IDPEL',  
                     render: function (data) {
                        return formatNumber(data, 0);
                    }
                },
                { 
                    data: 'BANK_RPTAG',  
                    render: function (data) {
                        return formatNumber(data, 0);
                    }
                },
                { 
                    data: 'SELISIH_RPTAG',  
                    render: function (data) {
                        return formatNumber(data, 0);
                    }
                }
            ],
            drawCallback: function () {
                $('#tablemon_upi thead th').addClass('text-center');
            },
           columnDefs: [
                { targets: '_all', className: 'dt-center' },
                { targets: 0, className: 'dt-body-right', orderable: false, width: '30px' },       // No
                { targets: 1, className: 'dt-body-left', width: '250px' },                         // KD_DIST - NAMA_DIST
                { targets: 2, className: 'dt-body-center', width: '80px' },                       // PRODUK
                { targets: 3, className: 'dt-body-left', width: '200px' },                         // BANK
                { targets: 4, className: 'dt-body-center', width: '70px' },                        // BULAN
                { targets: 5, className: 'dt-body-right', width: '100px' },                        // PLN_IDPEL
                { targets: 6, className: 'dt-body-right', width: '120px' },                        // PLN_RPTAG
                { targets: 7, className: 'dt-body-right', width: '100px' },                        // PLN_LEBAR_LUNAS
                { targets: 8, className: 'dt-body-right', width: '120px' },                        // PLN_RPTAG_LUNAS
                { targets: 9, className: 'dt-body-right', width: '100px' },                        // BANK_IDPEL
                { targets: 10, className: 'dt-body-right', width: '120px' },                       // BANK_RPTAG
                { targets: 11, className: 'dt-body-right', width: '120px' }                        // SELISIH_RPTAG
            ],
            createdRow: function (row, data, dataIndex) {
                if (data.URUT == 5) {
                    $('td', row).css({ 'font-weight': 'bold' });
                }

                $('td', row).each(function (colIndex) {
                    // Kolom pertama (No) tidak memiliki properti `data`
                    const columnDef = table.settings()[0].aoColumns[colIndex];
                    const columnName = columnDef.data;

                    // Lewati jika tidak punya nama kolom
                    if (!columnName || columnName === null) return;

                    const cellValue = data[columnName];

                    const allowedColumns = ['PLN_IDPEL', 'PLN_RPTAG'];

                    if (
                        allowedColumns.includes(columnName) && 
                        !isNaN(cellValue) && 
                        Number(cellValue) > 0
                    ) {
                        $(this).css({
                            'cursor': 'pointer',
                            'text-decoration': 'underline',
                            'color': 'blue'
                        }).off('click').on('click', function () {
                            if (data.URUT == 1 || data.URUT == 2 || data.URUT == 3) {
                                $('#xbln_usulan').val(data.BLN_USULAN);
                                $('#xkd_dist').val(data.KD_DIST);
                            }

                            // Perbarui isi detailFilterParams SETIAP klik
                            detailFilterParams = {
                                vbln_usulan: data.BLN_USULAN,
                                vkd_bank: data.BANK ? data.BANK.substring(0, 3) : '',
                                vkd_dist: data.KD_DIST
                            };

                            console.log('Updated filter params:', detailFilterParams);

                            $('#dataModal').modal('show');
                        });
                    }
                });
            },
            dom: 'lfrtip'
        });

        // Tampilkan spinner saat DataTables mulai load data
        table.on('preXhr.dt', function () {
            $('#loadingSpinner').show();
        });

        // Sembunyikan spinner setelah DataTables selesai load data
        table.on('xhr.dt', function () {
            $('#loadingSpinner').hide();
        });

        $('#btnTampil').on('click', function () {
            if (!$('#bln_usulan').val()) {
                alert("Silakan pilih Bulan Usulan terlebih dahulu!");
                return;
            }

            $('#loadingSpinner').show();
            table.ajax.reload();
        });

        // Ekspor halaman ke Excel
        $('#downloadMonRekapExcelBtnPage').on('click', function () {
            const rawData = table.rows({ search: 'applied' }).data().toArray();

            const exportData = rawData.map(row => ({
                'KD_DIST - NAMA_DIST': row.KD_DIST + ' - ' + row.NAMA_DIST,
                'PRODUK': row.PRODUK,
                'BANK': row.BANK,
                'BULAN': row.BLN_USULAN,
                'PLN_IDPEL': row.PLN_IDPEL?.toString(),        // ubah ke string untuk jaga leading zero
                'PLN_RPTAG': Number(row.PLN_RPTAG),            // biarkan angka untuk kalkulasi
                'PLN_LEBAR_LUNAS': Number(row.PLN_LEBAR_LUNAS),
                'PLN_RPTAG_LUNAS': Number(row.PLN_RPTAG_LUNAS),
                'BANK_IDPEL': row.BANK_IDPEL?.toString(),
                'BANK_RPTAG': Number(row.BANK_RPTAG),
                'SELISIH_RPTAG': Number(row.SELISIH_RPTAG)
            }));

            const ws = XLSX.utils.json_to_sheet(exportData);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, 'REKON_REKAP_MIV');

            const filename = 'REKAP_MIV_REKON_BANK_VS_PLN_'+$('#bln_usulan').val()+'.xlsx';
            XLSX.writeFile(wb, filename);
        });

        // ---------------------------------------------------------------------------------------------
        // 1B) show Data Monitoring Detail/Daftar PerUpi Modal Large 
        // ---------------------------------------------------------------------------------------------
        let lastPageBeforeSearchDetail = 0;

        $('#dataModal').on('shown.bs.modal', function () {
            if ($.fn.DataTable.isDataTable('#table_mondaf_upi')) {
                $('#table_mondaf_upi').DataTable().clear().destroy();
            }

            const detailTable = $('#table_mondaf_upi').DataTable({
                processing: true,
                serverSide: true,
                scrollX: true,
                ajax: {
                    url: 'mon-rekon-bankvsperupi',
                    type: 'POST',
                    data: function (d) {
                        d.act         = 'detailData';
                        d.vbln_usulan = detailFilterParams.vbln_usulan;
                        d.vkd_bank    = detailFilterParams.vkd_bank;
                        d.vkd_dist    = detailFilterParams.vkd_dist;
                        console.log('Kirim data ke server:', d);
                    },
                    dataSrc: function (json) {
                        console.log('Response dari server:', json);
                        return json.data || [];
                    }
                },
                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        },
                        className: 'text-center',
                        orderable: false
                    },
                    { data: 'PRODUK' },
                    { data: 'TGLAPPROVE' },
                    { data: 'KD_DIST' },
                    { data: 'VA' },
                    { data: 'SATKER' },
                    { data: 'PLN_NOUSULAN' },
                    { data: 'PLN_IDPEL' },
                    { data: 'PLN_BLTH' },
                    { data: 'PLN_LUNAS_H0' },
                    { data: 'PLN_RPTAG', render: data => formatNumber(data, 0) },
                    { data: 'PLN_RPBK', render: data => formatNumber(data, 0) },
                    { data: 'PLN_TGLBAYAR' },
                    { data: 'PLN_JAMBAYAR' },
                    { data: 'PLN_USERID' },
                    { data: 'PLN_KDBANK' },
                    { data: 'BANK_KETERANGAN' },
                    { data: 'BANK_NOUSULAN' },
                    { data: 'BANK_IDPEL' },
                    { data: 'BANK_BLTH' },
                    { data: 'BANK_RPTAG', render: data => formatNumber(data, 0) },
                    { data: 'BANK_RPBK', render: data => formatNumber(data, 0) },
                    { data: 'BANK_TGLBAYAR' },
                    { data: 'BANK_JAMBAYAR' },
                    { data: 'BANK_USERID' },
                    { data: 'BANK_KDBANK' },
                    { data: 'SELISIH_RPTAG', render: data => formatNumber(data, 0) },
                    { data: 'SELISIH_BK', render: data => formatNumber(data, 0) },
                    { data: 'KETERANGAN' },
                ],
                columnDefs: [
                    { targets: [10, 11, 20, 21, 26, 27], className: 'dt-body-right', orderable: false }
                ],
                lengthMenu: [[10, 100, 1000], [10, 100, 1000]]
            });

            // Simpan halaman terakhir saat berpindah halaman (jika tidak sedang search)
            detailTable.on('page.dt', function () {
                if (!detailTable.search()) {
                    lastPageBeforeSearchDetail = detailTable.page();
                    console.log('Halaman disimpan sebelum search:', lastPageBeforeSearchDetail);
                }
            });

            // Force ke halaman 0 saat search aktif
            detailTable.on('preXhr.dt', function (e, settings, data) {
                const keyword = detailTable.search();
                if (keyword && keyword.length > 0) {
                    console.log('preXhr: sedang search, paksa ke page 0');
                    settings._iDisplayStart = 0;
                    data.start = 0;
                }
            });

            // Kembali ke halaman sebelumnya saat pencarian dikosongkan
            detailTable.on('search.dt', function () {
                const keyword = detailTable.search();
                if (keyword.length === 0) {
                    console.log('Search dikosongkan, kembali ke halaman:', lastPageBeforeSearchDetail);
                    setTimeout(() => {
                        detailTable.page(lastPageBeforeSearchDetail).draw('page');
                    }, 300);
                }
            });
        });

        $('#downloadMonDftExcelBtnAll').on('click', async function () {
            const btn = $(this);
            btn.prop('disabled', true).text('Mengunduh...');

            try {
                // const url = window.location.origin + '/mon-rekon-bankvsperupi';
                const url = window.location.origin + '<%= request.getContextPath() %>/mon-rekon-bankvsperupi';


                const params = new URLSearchParams();
                params.append('act', 'detailData');
                params.append('vbln_usulan', detailFilterParams.vbln_usulan);
                params.append('vkd_bank', detailFilterParams.vkd_bank);
                params.append('vkd_dist', detailFilterParams.vkd_dist);
                params.append('start', 0);
                params.append('length', 999999); // ambil semua record

                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params.toString()
                });

                if (!response.ok) throw new Error('Gagal mengambil data dari server');

                const json = await response.json();
                const allData = json.data || [];

                const headers = {
                    'NO': '',
                    'PRODUK': '',
                    'TGLAPPROVE': '',
                    'KD_DIST': '',
                    'VA': '',
                    'SATKER': '',
                    'PLN_NOUSULAN': '',
                    'PLN_IDPEL': '',
                    'PLN_BLTH': '',
                    'PLN_LUNAS_H0': '',
                    'PLN_RPTAG': '',
                    'PLN_RPBK': '',
                    'PLN_TGLBAYAR': '',
                    'PLN_JAMBAYAR': '',
                    'PLN_USERID': '',
                    'PLN_KDBANK': '',
                    'BANK_KETERANGAN': '',
                    'BANK_NOUSULAN': '',
                    'BANK_IDPEL': '',
                    'BANK_BLTH': '',
                    'BANK_RPTAG': '',
                    'BANK_RPBK': '',
                    'BANK_TGLBAYAR': '',
                    'BANK_JAMBAYAR': '',
                    'BANK_USERID': '',
                    'BANK_KDBANK': '',
                    'SELISIH_RPTAG': '',
                    'SELISIH_BK': '',
                    'KETERANGAN': ''
                };

                const formattedData = allData.map((item, idx) => {
                    const row = {};
                    Object.keys(headers).forEach((key) => {
                        const val = item[key];
                        row[key] = val !== undefined && val !== null ? val : '';
                    });
                    row['NO'] = idx + 1;
                    return row;
                });

                const worksheet = XLSX.utils.json_to_sheet(formattedData, { header: Object.keys(headers) });
                const workbook = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(workbook, worksheet, "REKON_DETAIL_MIV");

                const filename = 'REKON_DETAIL_MIV_BANK_VS_BANK_'+detailFilterParams.vbln_usulan+'.xlsx';
                XLSX.writeFile(workbook, filename);

            } catch (error) {
                alert('Gagal ekspor data: ' + error.message);
                console.error(error);
            } finally {
                btn.prop('disabled', false).text('Download Excel');
            }
        });
    });
</script>
