<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentPage = request.getParameter("page");
    String currentMenu = request.getParameter("menu");

    if (currentPage == null || currentPage.trim().isEmpty()) {
        currentPage = "/views/dashboard/dashboard.jsp";
    }

    if (currentMenu == null || currentMenu.trim().isEmpty()) {
        request.setAttribute("menu", "dashboard");
    } else {
        request.setAttribute("menu", currentMenu);
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>MIV Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />

    <!-- ✅ CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css">


    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <!-- Plugin Month Select CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/style.css">

    <!-- Pastikan Bootstrap CSS & JS sudah disertakan -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

    
    <!-- ✅ SCRIPT: jQuery HARUS PALING ATAS -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>

    <style>
        .content-panel {
            background-color: white;
            border-radius: 6px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            padding: 20px;
        }
    </style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- ✅ NAVBAR -->
    <jsp:include page="/views/templates/navbar.jsp" />

    <!-- ✅ SIDEBAR -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <jsp:include page="/views/templates/sidebar.jsp" />
    </aside>

    <!-- ✅ CONTENT WRAPPER -->
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <!-- Optional breadcrumb -->
            </div>
        </div>

        <section class="content pt-3">
            <div class="container-fluid">
                <div class="row justify-content-center">
                    <div class="col-12">
                        <div class="content-panel">
                            <jsp:include page="<%= currentPage %>" />
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- ✅ FOOTER -->
    <jsp:include page="/views/templates/footer.jsp" />

</div>


<!-- ✅ Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- ✅ AdminLTE -->
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>

<!-- ✅ Flatpickr & Month Plugin -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>

<!-- ✅ DataTables & Export -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

<!-- ✅ Export Excel via SheetJS -->
<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>

</body>
</html>
