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
    <meta charset="UTF-8" />
    <title>Management Instansi Vertikal</title>

    <!-- Sidebar style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/mydatatable.css">

    <!-- Bootstrap CSS -->
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" /> -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

     <!-- bootstrap-icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" />

    <!-- DataTables Buttons CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css" />

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <!-- DataTables Buttons JS -->
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>

    <!-- JSZip untuk export Excel -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>


    <style>
        .top-bar {
            background-color: #ffffff;
            border-bottom: 1px solid #dee2e6;
            padding: 0.75rem 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .top-bar .logo img {
            max-height: 40px;
        }

        .top-bar .right-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .top-bar .right-menu i {
            cursor: pointer;
        }

        .sidebar {
            min-height: 100vh;
            background-color: #2d2d2d;
        }

        /* .sidebar-header .logo img {
            width: 100%;
            height: auto;
            display: block;
            object-fit: contain;
            padding: .1px;
        } */
    </style>
</head>
<body>
<div class="wrapper">
    <!-- Top bar bisa diletakkan di sini jika ada -->

    <div class="main-content">
        <!-- Sidebar -->
        <nav class="sidebar p-3">
            <jsp:include page="/views/templates/sidebar.jsp" />
        </nav>

        <!-- Konten scrollable -->
        <main class="content-area">
            <jsp:include page="<%= currentPage %>" />
        </main>
    </div>
</div>

<!-- Bootstrap Bundle JS -->
<!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Bootstrap Icon (opsional jika belum ada) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />


</body>
</html>
