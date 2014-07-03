﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageSampleNVT.aspx.cs" Inherits="BioPM.PageSampleNVT" %>

<!DOCTYPE html>
<script runat="server">
    string itmnm, tesdt;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["id"] == null) Response.Redirect("PageUserPanel.aspx");
        if (Session["coctr"].ToString() != "52500" && Session["coctr"].ToString() != "64100") Response.Redirect("PageUserPanel.aspx");
        SetDataAnimalRandom();
    }
    protected void sessionCreator()
    {     
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }
    
    protected void SetDataAnimalRandom()
    {
        object[] values = BioPM.ClassObjects.NvtCatalog.GetNVTByID(Session["id"].ToString())[0];
        itmnm = values[1].ToString();
        tesdt = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[4].ToString());
    }

    protected String GenerateDataAnimalRandom()
    {
        string htmlelement = "";

        foreach (object[] data in BioPM.ClassObjects.NvtCatalog.GetNVTByID(Session["id"].ToString()))
        {
            htmlelement += "<tr class=''><td>" + data[2].ToString() + "</td><td>" + data[3].ToString() + "</td><td>" + data[7].ToString() + "</td><td>" + data[6].ToString() + "</td></tr>";
        }
        
        return htmlelement;
    }

   
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>NVT Random</title>

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
                        NVT Random Result
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <h4>
                                Random Date :  <% Response.Write(" " + tesdt); %> <br/>
                                Animal Name : <% Response.Write(" " + itmnm); %> <br/>
                                <br/>
                        </h4>
                        <div class="adv-table">
                            <div class="clearfix">
                                <div class="btn-group">
                                    <button id="editable-sample_new" onclick="document.location.href='PageReportNVT.aspx';" class="btn btn-primary"> Print <i class="fa fa-print"></i>
                                    </button>
                                </div>
                                
                            </div>
                            <table class="table table-striped table-hover table-bordered" id="dynamic-table" >
                                <thead>
                                <tr>
                                    <th>ANIMAL NUMBER</th>
                                    <th>INJECTION NUMBER</th>
                                    <th>BATCH</th>
                                    <th>BUILDING NAME</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% Response.Write(GenerateDataAnimalRandom()); %>
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
