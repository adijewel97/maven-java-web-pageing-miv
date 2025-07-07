<style>
    /* Menu sidebar aktif - tanpa background */
    .sidebar-dark-primary .nav-sidebar .nav-link.active {
        background-color: transparent !important;
        color: #ffffff !important;
        font-weight: bold;
        border-left: 4px solid transparent;
    }

    .sidebar-dark-primary .nav-sidebar .nav-link.active i {
        color: #ffffff !important;
    }

    /* Ukuran font label sidebar */
    .sidebar .nav-sidebar .nav-link p {
        font-size: 0.8rem; /* atau 12px */
    }

    /* Indentasi teks submenu (nav-treeview) */
    .sidebar .nav-treeview .nav-link {
        padding-left: 3rem; /* Tambah dari default 1rem → lebih menjorok */
        font-size: 0.8rem; /* Ukuran kecil jika diinginkan */
    }
</style>

<!-- Sidebar -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="index.jsp?page=/views/dashboard/dashboard.jsp&menu=dashboard" class="brand-link">
        <img src="/assets/images/logo-mivPLNBANK.png" alt="Logo" class="brand-image img-circle">
        <span class="brand-text font-weight-light">MIV</span>
    </a>

    <!-- Sidebar Menu -->
    <div class="sidebar">
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column"
                data-widget="treeview"
                role="menu"
                data-accordion="false">

                <!-- Dashboard -->
                <li class="nav-item">
                    <a href="index.jsp?page=/views/dashboard/dashboard.jsp&menu=dashboard"
                       class="nav-link <%= "dashboard".equals(request.getAttribute("menu")) ? "active" : "" %>">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>Dashboard</p>
                    </a>
                </li>

                <!-- Monitoring Menu -->
                <%
                    String menuAttr = (String) request.getAttribute("menu");
                    boolean monitoringActive =
                        "monitoring-rekon-bank-upi".equals(menuAttr) ||
                        "Daftar-prov-upi".equals(menuAttr) ||
                        "monitoring-rekon-upi".equals(menuAttr); // <-- DITAMBAHKAN
                %>
                <li class="nav-item has-treeview <%= monitoringActive ? "menu-open" : "" %>">
                    <a href="#" class="nav-link <%= monitoringActive ? "active" : "" %>">
                        <i class="nav-icon fas fa-tasks"></i>
                        <p>
                            Monitoring
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <!-- Submenu Monitoring Rekon UPI -->
                        <li class="nav-item">
                            <a href="index.jsp?page=/views/monitoring/v1a_mon_perupi.jsp&menu=monitoring-rekon-bank-upi"
                               class="nav-link <%= "monitoring-rekon-bank-upi".equals(menuAttr) ? "active" : "" %>">
                                <p>Mon Rekon BANK vs PLN (Per-UID/UIW)</p>
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </nav>
    </div>
</aside>
