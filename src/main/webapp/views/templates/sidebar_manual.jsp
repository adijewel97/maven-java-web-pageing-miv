<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String menu = request.getParameter("menu");
%>

<nav class="nav flex-column">
    <a class="nav-link <%= (menu == null) ? "active" : "" %>" href="index.jsp?page=/views/dashboard/dashboard.jsp">DASHBOARD</a>

    <a class="nav-link <%= (menu != null && menu.startsWith("monitoring")) ? "active" : "" %>" 
       data-bs-toggle="collapse" 
       href="#collapseMonitoring" 
       role="button" 
       aria-expanded="<%= (menu != null && menu.startsWith("monitoring")) %>" 
       aria-controls="collapseMonitoring">
        MONITORING
    </a>
    <div class="collapse ps-3 <%= (menu != null && menu.startsWith("monitoring")) ? "show" : "" %>" id="collapseMonitoring">
        <a class="nav-link <%= "monitoring-prov-upi".equals(menu) ? "active" : "" %>" href="index.jsp?page=/views/monitoring/v_mon_perprov_upi.jsp&menu=monitoring-prov-upi">Mon PerProv dan PerUpi</a>
        <a class="nav-link <%= "monitoring-perpengusul".equals(menu) ? "active" : "" %>" href="index.jsp?page=/views/monitoring/v_mon_perpengusul.jsp&menu=monitoring-perpengusul">Mon PerPengusul</a>
    </div>
</nav>
