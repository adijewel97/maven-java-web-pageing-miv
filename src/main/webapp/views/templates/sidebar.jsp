<!-- <div class="sidebar-header">
    <div class="logo">
        <a href="/bpbl/dashboard">
             <img src="/assets/images/logo-BPBL.png" alt="logo">
        </a>
    </div>
</div> -->

<a class="nav-link <%= "dashboard".equals(request.getParameter("menu")) || request.getParameter("menu") == null ? "active" : "" %>"
   href="index.jsp?page=/views/dashboard/dashboard.jsp&menu=dashboard">
    <i class="bi bi-speedometer2 me-2"></i> Dashboard
</a>

<a class="nav-link <%= "monitoring".equals(request.getParameter("menu")) ? "active" : "" %>"
   data-bs-toggle="collapse"
   href="#collapseMonitoring"
   role="button"
   aria-expanded="true"
   aria-controls="collapseMonitoring">
    <i class="bi bi-graph-up me-2"></i> Monitoring
</a>

<div class="collapse ps-3 show" id="collapseMonitoring">
    <a class="nav-link <%= "monitoring-rekon-bankvsupi".equals(request.getParameter("menu")) ? "active" : "" %>"
       href="index.jsp?page=/views/monitoring/v1a_mon_perupi.jsp&menu=monitoring-prov-upi">
        Mon Rekon BANK vs PLN (Per-UID/UIW)
    </a>
    <a class="nav-link <%= "Daftar-prov-upi".equals(request.getParameter("menu")) ? "active" : "" %>"
       href="index.jsp?page=/views/monitoring/v2a_dft_perprov_upi.jsp&menu=Daftar-prov-upi">
        Daftar PerProv dan PerUpi
    </a>
    <a class="nav-link <%= "monitoring-perpengusul".equals(request.getParameter("menu")) ? "active" : "" %>"
       href="index.jsp?page=/views/monitoring/v1b_mon_perpengusul.jsp&menu=monitoring-perpengusul">
        Mon PerPengusul
    </a>
</div>
