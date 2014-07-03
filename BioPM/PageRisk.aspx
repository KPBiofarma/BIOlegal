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

        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetRisk())
        {
            htmlelement += "<tr class=''><td>" + BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[0].ToString()) + "</td><td>" + data[1].ToString() + "</td><td>" + data[2].ToString() + "</td><td>" + data[3].ToString() + "</td><td><a class='edit' href='FormUpdateBatch.aspx?key=" + data[0].ToString() + "'>Edit</a></td><td><a class='delete' href='PageInformation.aspx?key=" + data[0].ToString() + "&type=21'>Delete</a></td></tr>";
        }
        
        return htmlelement;
    }

   
</script>

<html lang="en">
<head>
<% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>BATCH</title>
    
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


