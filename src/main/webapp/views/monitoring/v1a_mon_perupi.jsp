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

    /* legenda tulisan hedar dan kotak  */
    .form-box {
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 20px;
        margin: 20px 0;
    }

    .form-box legend {
        font-weight: bold;
        font-size: 1rem;
    }

    .form-box fieldset {
        border: none;
        padding: 0;
        margin: 0;
    }

    #bln_usulan {
        text-transform: uppercase;
    }

    /* ----------
       Spiner css
       ----------
    */
    #loadingSpinner {
        display: none;
        position: fixed;
        top: 20%;
        left: 50%;
        transform: translate(-50%, 0);
        z-index: 9999;
        /* background-color: rgba(255, 255, 255, 0.7); */
        padding: 20px 30px;
        border-radius: 6px;
        /* box-shadow: 0 0 10px rgba(0,0,0,0.2); */
        text-align: center;
    }


    #loadingSpinner .spinner-content {
        text-align: center;
        font-size: 1.2rem;
        color: #333;
    }

    .overlay-spinner {
        position: absolute;
        top: 40%;
        left: 45%;
        z-index: 1060;
    }

</style>

<!-- ✅ Spinner Global untuk semua loading -->
<div id="spinnerOverlay" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%); z-index:9999;">
    <div class="spinner-border text-primary" role="status"></div>
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
            <!-- Tombol Export -->
            <div class="mb-2">
                <button id="btnExportMonDftAllExcelOneSheet" class="btn btn-success btn-export">
                    <i class="fa fa-file-excel-o"></i> Export Detail Per-UPI
                </button>
            </div>
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
                    <!-- <th>BANK_KETERANGAN</th> -->
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

<fieldset style="border: 1px solid #ccc; border-radius: 4px; padding: 1.25rem;">
    <legend style="font-size: 0.95rem; font-weight: bold; padding: 0 0.75rem; width: auto;">
        Monitoring Rekon PLN Vs Bank
    </legend>

    <div class="container mt-1">
        <div class="form-monitoring">
            <form id="form-monitoring">
                <div class="row align-items-end g-3 mb-2">
                    <!-- Input Bulan Laporan -->
                    <div class="col-md-4 col-lg-3">
                        <label for="bln_usulan" class="form-label">Bulan Laporan :</label>
                        <div class="input-group">
                            <input type="text" id="bln_usulan" class="form-control" placeholder="Pilih Bulan Laporan">
                            <span class="input-group-text" id="calendarIcon" style="cursor: pointer;">
                                <i class="fa-solid fa-calendar-alt"></i>
                            </span>
                        </div>
                    </div>

                    <!-- Tombol Tampilkan -->
                    <div class="col-md-2">
                        <label class="form-label d-none d-md-block">&nbsp;</label> <!-- Spacer agar sejajar -->
                        <button id="btnTampil" type="button" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> Tampilkan
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="mt-4">
           <!-- Tombol export buatan sendiri -->
            <div class="mb-2">
                <button id="btnExportMonRkpAllExcel" class="btn btn-success btn-export">
                    <i class="fa fa-file-excel-o"></i> Download Excel
                </button>
            </div>


            <div class="datatable-container">
                <div class="datatable-scroll-wrapper" style="overflow-x: auto;">
                    <table id="tablemon_upi" class="datatable-main table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>NO</th>
                                <th>NAMA_DIST</th>
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
</fieldset>

<script>
    $(document).ready(function () {
        function getContextPath() {
            return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        }

        function convertBulanTahunToYYYYMM(str) {
            const date = new Date(str); // "July 2025" akan dikenali oleh Date
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0'); // bulan dimulai dari 0
            return year+month; // hasil: "202507"
        }

        // Inisialisasi flatpickr dengan locale Indonesia
        const blnUsulanInstance = flatpickr("#bln_usulan", {
            locale: flatpickr.l10ns.id, // ✅ Ini cara yang benar
            plugins: [
                new monthSelectPlugin({
                    shorthand: false,
                    theme: "light"
                })
            ],
            dateFormat: "Ym",
            altInput: true,
            altFormat: "F Y",
            defaultDate: new Date()
        });

        // Saat ikon diklik, buka datepicker
        document.getElementById("calendarIcon").addEventListener("click", function () {
            blnUsulanInstance.open();
        });

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

        // ---------------------------------------------------------------------------------------------
        // 1A) Tampilkan monitoring Rekap
        // ---------------------------------------------------------------------------------------------
        var table = $('#tablemon_upi').DataTable({
            processing: false,
            serverSide: true,
            scrollX: false,
            paging: false, // MATIKAN PAGING
            stripeClasses: [], // Nonaktifkan efek baris selang-seling
            searching: false, 
            autoWidth: false,
            ajax: {
                url:  getContextPath() + '/mon-rekon-bankvsperupi',
                type: 'POST',
                data: function (d) {
                    d.vbln_usulan = convertBulanTahunToYYYYMM($('#bln_usulan').val());// pastikan pakai '#'!
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
                    $('td', row).css({
                        'font-weight': 'bold',
                        // 'background-color': 'black',
                        // 'color': 'white'
                    });
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
                        typeof cellValue === 'string' &&
                        cellValue.trim() !== '' &&
                        (data.URUT == 1 || data.URUT == 2 || data.URUT == 3)
                    ) {
                        $(this).css({
                            'cursor': 'pointer',
                            'text-decoration': 'underline',
                            'color': 'blue'
                        }).off('click').on('click', function () {
                            $('#xbln_usulan').val(data.BLN_USULAN);
                            $('#xkd_dist').val(data.KD_DIST);

                            // Update filter
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
            // dom: 'lfrtip'
            dom: 'Bfrtip',
            buttons: [
                {
                    extend: 'excelHtml5',
                    title: 'MIV_REKAP_' + convertBulanTahunToYYYYMM($('#bln_usulan').val()),
                    className: 'd-none', // tombol disembunyikan
                    customize: function (xlsx) {
                        const sheet = xlsx.xl.worksheets['sheet1.xml'];
                        const sheetData = $('sheetData', sheet);

                        // Buat timestamp dan judul
                        const now = new Date();
                        const dd = String(now.getDate()).padStart(2, '0');
                        const mm = String(now.getMonth() + 1).padStart(2, '0');
                        const yyyy = now.getFullYear();
                        const hh = String(now.getHours()).padStart(2, '0');
                        const mi = String(now.getMinutes()).padStart(2, '0');
                        const ss = String(now.getSeconds()).padStart(2, '0');
                        const timestamp = "Tanggal Download: "+dd+"/"+mm+"/"+yyyy+" "+hh+":"+mi+":"+ss;
                        const judul = "MIV_REKAP_" + convertBulanTahunToYYYYMM($('#bln_usulan').val());

                        // Geser semua baris ke bawah 2
                        // $('row', sheetData).each(function () {
                        //     const r = parseInt($(this).attr('r'));
                        //     const newR = r + 2;
                        //     $(this).attr('r', newR);
                        //     $(this).find('c').each(function () {
                        //         const cellRef = $(this).attr('r');
                        //         if (cellRef) {
                        //             const col = cellRef.replace(/[0-9]/g, '');
                        //             $(this).attr('r', col + newR);
                        //         }
                        //     });
                        // });

                        // // Tambahkan baris A1 dan A2 (tanpa merge)
                        // const row1 = `
                        //     <row r="1">
                        //         <c t="inlineStr" r="A1">
                        //             <is><t>${judul}</t></is>
                        //         </c>
                        //     </row>
                        // `;
                        // const row2 = `
                        //     <row r="2">
                        //         <c t="inlineStr" r="A2">
                        //             <is><t>${timestamp}</t></is>
                        //         </c>
                        //     </row>
                        // `;

                        // // Sisipkan ke atas
                        // sheetData.prepend(row2);
                        // sheetData.prepend(row1);
                    }
                }
            ]                
        });

        // Tampilkan spinnerOverlay saat DataTables mulai load data
        table.on('preXhr.dt', function () {
           $('#spinnerOverlay').show();  
        });

        // Sembunyikan spinnerOverlay setelah DataTables selesai load data
        table.on('xhr.dt', function () {
            $('#spinnerOverlay').hide();    // Saat selesai
        });

        $('#btnTampil').on('click', function () {
            if (!$('#bln_usulan').val()) {
                alert("Silakan pilih Bulan Usulan terlebih dahulu!");
                return;
            }

            $('#spinnerOverlay').show();   // hanya tampilkan overlay modal
            table.ajax.reload();
        });

        // Ekspor halaman Monitoring Rekap ke Excel
        $('#btnExportMonRkpAllExcel').on('click', function () {
            table.button('.buttons-excel').trigger();
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
                    url: getContextPath() + '/mon-rekon-bankvsperupi',
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
                    // { data: 'BANK_KETERANGAN' },
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
       
        // ----------------------------------------------------------------------------
        // 1C Export ke exel semua data MON daftar
        // ----------------------------------------------------------------------------
        // Fungsi format angka ribuan (lokal Indonesia)
        const formatRibuan = (angka) => new Intl.NumberFormat('id-ID').format(angka);

        $('#btnExportMonDftAllExcelOneSheet').on('click', async function () {
            const btn = $(this);
            let totalLoaded = 0;

            $('#spinnerOverlay').show();
            await new Promise(resolve => setTimeout(resolve, 30));

            btn.prop('disabled', true).text("Memuat... (" + formatRibuan(totalLoaded) + " data)");

            const vbln_usulan = detailFilterParams.vbln_usulan;
            const vkd_bank = detailFilterParams.vkd_bank;
            const vkd_dist = detailFilterParams.vkd_dist;

            if (!vbln_usulan || !vkd_bank || !vkd_dist) {
                alert('Silakan lengkapi filter terlebih dahulu!');
                btn.prop('disabled', false).text('Export Excel Per-UID/UIW');
                return;
            }

            try {
                const pageSize = 1000;
                let start = 0;
                let allData = [];
                let drawCounter = 1;

                const headers = {
                    PRODUK: '', TGLAPPROVE: '', KD_DIST: '', VA: '', SATKER: '',
                    PLN_NOUSULAN: '', PLN_IDPEL: '', PLN_BLTH: '', PLN_LUNAS_H0: '',
                    PLN_RPTAG: '', PLN_RPBK: '', PLN_TGLBAYAR: '', PLN_JAMBAYAR: '',
                    PLN_USERID: '', PLN_KDBANK: '', BANK_NOUSULAN: '',
                    BANK_IDPEL: '', BANK_BLTH: '', BANK_RPTAG: '', BANK_RPBK: '',
                    BANK_TGLBAYAR: '', BANK_JAMBAYAR: '', BANK_USERID: '', BANK_KDBANK: '',
                    SELISIH_RPTAG: '', SELISIH_BK: '', KETERANGAN: ''
                };

                while (true) {
                    const params = new URLSearchParams();
                    params.append('act', 'detailData');
                    params.append('vbln_usulan', vbln_usulan);
                    params.append('vkd_bank', vkd_bank);
                    params.append('vkd_dist', vkd_dist);
                    params.append('start', start);
                    params.append('length', pageSize);
                    params.append('draw', drawCounter++);
                    params.append('order[0][column]', '0');
                    params.append('order[0][dir]', 'asc');
                    params.append('columns[0][data]', 'KD_DIST');
                    params.append('search[value]', '');

                    const response = await fetch(getContextPath() + '/mon-rekon-bankvsperupi', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    });

                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error('Status: ' + response.status + '\n' + errorText);
                    }

                    const json = await response.json();
                    const data = json.data;
                    if (!data || data.length === 0) break;

                    const formatted = data.map((item, index) => {
                        const row = { NO: start + index + 1 };
                        Object.keys(headers).forEach(key => {
                            row[key] = item[key] || '';
                        });
                        return row;
                    });

                    allData = allData.concat(formatted);
                    totalLoaded += data.length;
                    btn.text("Memuat... (" + formatRibuan(totalLoaded) + " data)");
                    await new Promise(resolve => setTimeout(resolve, 10));
                    if (data.length < pageSize) break;

                    start += pageSize;
                }

                if (allData.length === 0) {
                    alert('Tidak ada data untuk diekspor!');
                    return;
                }

                // Buat timestamp dan judul
                const now = new Date();
                const dd = String(now.getDate()).padStart(2, '0');
                const mm = String(now.getMonth() + 1).padStart(2, '0');
                const yyyy = now.getFullYear();
                const hh = String(now.getHours()).padStart(2, '0');
                const mi = String(now.getMinutes()).padStart(2, '0');
                const ss = String(now.getSeconds()).padStart(2, '0');
                const timestamp = "Tanggal Download: " + dd + "/" + mm + "/" + yyyy + " " + hh + ":" + mi + ":" + ss;
                const judul1 = "MIV REKON DAFTAR";
                const judul2 = "BULAN: " +  vbln_usulan + " - KDBANK: " + vkd_bank + " - KDDIST: " + vkd_dist;

                // Susun data untuk Excel
                const rows = [];
                // Tambah baris judul dengan format bold
                rows.push([{ v: judul1, s: { font: { bold: true } } }]);
                rows.push([{ v: judul2, s: { font: { bold: true } } }]);
                rows.push([{ v: timestamp, s: { font: { bold: true } } }]);
                rows.push([]); // baris kosong biasa
                rows.push(['NO', ...Object.keys(headers)]); // header kolom biasa

                allData.forEach(row => {
                    const dataRow = ["" + row.NO]; // NO sebagai string
                    Object.keys(headers).forEach(key => {
                        dataRow.push(row[key] || '');
                    });
                    rows.push(dataRow);
                });

                // Buat worksheet dan workbook
                const ws = XLSX.utils.aoa_to_sheet(rows);

                // Merge A1 sampai kolom akhir (A1-Z1 misal)
                ws['!merges'] = [{ s: { r: 0, c: 0 }, e: { r: 0, c: Object.keys(headers).length } }];

                // Lebar kolom
                ws['!cols'] = Array(Object.keys(headers).length + 1).fill({ wch: 20 });

                // Simpan file
                const wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, ws, 'REKON_PLNvsBANK');
                const filename = "MIV_REKON_DAFTAR_" + vbln_usulan + "_" + vkd_bank + "_" + vkd_dist + ".xlsx";
                XLSX.writeFile(wb, filename);

            } catch (err) {
                alert('Terjadi error: ' + err.message);
                console.error(err);
            } finally {
                btn.prop('disabled', false).text('Export Excel Per-UID/UIW');
                $('#spinnerOverlay').hide();
            }
        });

    });
</script>
