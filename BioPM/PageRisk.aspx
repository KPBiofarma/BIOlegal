﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageBatch.aspx.cs" Inherits="BioPM.PageBatch" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
    }
    
    protected void sessionCreator()
    {     
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected String GenerateRisk()
    {
        string htmlelement = "";

        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetRisks())
        {
            string RSKID = data[1].ToString() +  " - " + data[2].ToString() + " - " + data[3].ToString();
            htmlelement += "<tr class=''><td>" + BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[0].ToString()) + "</td><td>" + RSKID + "</td><td>" + data[4].ToString() + "</td><td>" + data[5].ToString() + "</td><td>" + data[6].ToString() + "</td><td><a class='edit' href='FormUpdateRisk.aspx?key=" + data[3].ToString() + "'>Edit</a></td><td><a class='delete' href='PageInformation.aspx?key=" + data[3].ToString() + "&type=21'>Delete</a></td></tr>";
        }
        
        return htmlelement;
    }

    /*
    protected String GenerateLaporan() 
    { 
        string htmlelement = ""; 
        string jenis = "Laporan Nyaris Celaka"; 
        foreach (object[] data in BioPM.ClassObjects.EHSValue.GetIDLaporanByJenis(jenis)) 
        { 
            string begda_convert = BioEHS.ClassEngines.DateFormatFactory.GetDateTimeFormat(data[0].ToString()); 
            string endda_convert = BioEHS.ClassEngines.DateFormatFactory.GetDateTimeFormat(data[1].ToString()); 
            string maxval_convert = BioEHS.ClassEngines.DateFormatFactory.GetDateTimeFormat(DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm").ToString()) + ":00"; 
            if (endda_convert.CompareTo(maxval_convert) == 0) 
            { 
                string status = BioEHS.ClassObjects.EHSValue.GetStatusLapByID(data[0].ToString(), data[1].ToString(), data[2].ToString()); 
                if ((status.CompareTo("Disahkan")) != 0) 
                { 
                    string begda = data[0].ToString(); string endda = data[1].ToString(); htmlelement += "<tr class=''><td>" + begda_convert + "</td><td>" + data[3].ToString() + "</td><td><a class='edit' href='UpdateFormulir1.aspx?begda=" + begda + "&endda=" + endda + "&key=" + data[2].ToString() + "'>Edit</a></td><td><a class='delete' href='PageInformation.aspx?begda=" + begda + "&endda=" + endda + "&key=" + data[2].ToString() + "&type=7'>Delete</a></td></tr>"; 
                } 
            } 
        } 
        return htmlelement; 
    }
     */

    
    
    
</script>

<html lang="en">
<head>
<% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>RISK</title>
    
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetCoreStyle()); %>
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetTableStyle()); %>
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetCustomStyle()); %>
</head>

<body>

<section id="container" >
 
<!--header start--> 
 <%Response.Write( BioPM.ClassScripts.SideBarMenu.TopMenuElement(Session["name"].ToString())); %> 
<!--header end-->
   
<!--left side bar start-->
 <%Response.Write(BioPM.ClassScripts.SideBarMenu.LeftSidebarMenuElementAutoGenerated(Session["username"].ToString())); %> 
<!--left side bar end-->

    <!--main content start-->
    <section id="main-content">
        <section class="wrapper">
        <!-- page start-->

        <div class="row">
            <div class="col-sm-12">
                <section class="panel">
                    <header class="panel-heading">
                        Risk Detail
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">

                        <div class="adv-table">
                            <div class="clearfix">
                                <div class="btn-group">
                                    <button id="editable-sample_new" onclick="document.location.href='FormInputRisk.aspx';" class="btn btn-primary"> Add New <i class="fa fa-plus"></i>
                                    </button>
                                </div>
                                <div class="btn-group pull-right">
                                    <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">Tools <i class="fa fa-angle-down"></i>
                                    </button>
                                    <ul class="dropdown-menu pull-right">
                                        <li><a href="#">Print</a></li>
                                        <li><a href="#">Save as PDF</a></li>
                                        <li><a href="#">Export to Excel</a></li>
                                    </ul>
                                </div>
                            </div>
                            <table class="table table-striped table-hover table-bordered" id="dynamic-table" >
                                <thead>
                                <tr>
                                    <th>CREATED DATE</th>
                                    <th>NO. REG</th>
                                    <th>RISIKO KEJADIAN</th>
                                    <th>FUNGSI</th>
                                    <th>PENGELOLAAN</th>
                                    <th>Edit</th>
                                    <th>Delete</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% Response.Write(GenerateRisk()); %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                </section>
            </div>
        </div>

        <!-- page end-->
        </section>
    </section>
    <!--main content end-->
<!--right sidebar start-->
    <%Response.Write( BioPM.ClassScripts.SideBarMenu.RightSidebarMenuElement() ); %> 
<!--right sidebar end-->
</section>

<!-- Placed js at the end of the document so the pages load faster -->
<% Response.Write(BioPM.ClassScripts.JS.GetCoreScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetDynamicTableScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetInitialisationScript()); %>
</body>
</html>


