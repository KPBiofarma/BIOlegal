﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageBatchProductQualityControl.aspx.cs" Inherits="BioPM.PageBatchProductQualityControl" %>

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
    
    protected string GetProductionStatus(string BATCH)
    {
        if (BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1") == null)
        {
            return "<span class='label label-warning'> IN PROCESS </span>";
        }
        else
        {
            switch (BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1")[2].ToString().ToLower())
            {
                case "quarantine":
                    {
                        return "<span class='label label-warning'> QUARANTINE </span>";
                    }
                case "review":
                    {
                        return "<span class='label label-primary'> REVIEWED </span>";
                    }
                case "corection":
                    {
                        return "<span class='label label-info'> UNDER CORECTION </span>";
                    }
                case "approve":
                    {
                        return "<span class='label label-success'> APPROVED </span>";
                    }
                case "reject":
                    {
                        return "<span class='label label-danger'> REJECTED </span>";
                    }
                case "release":
                    {
                        return "<span class='label label-success'> RELEASED </span>";
                    }
                default:
                    {
                        return "<span class='label label-success'> APPROVED </span>";
                    }
            }
        }
    }

    protected string GetPageAction(string BATCH)
    {
        if (BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1") == null)
        {
            return "<td align='center'><a class='edit' href='PageQualityControlTransaction.aspx?key=" + BATCH + "'> CREATE </a></td>";
        }
        else
        {
            switch (BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1")[2].ToString().ToLower())
            {
                case "quarantine":
                    {
                        return "<td align='center'><a class='edit' href='PageQualityControlTransaction.aspx?key=" + BATCH + "'> UPDATE </a></td>";
                    }
                case "review":
                    {
                        return "<td align='center'></td>";
                    }
                case "corection":
                    {
                        return "<td align='center'><a class='edit' href='PageQualityControlTransaction.aspx?key=" + BATCH + "'> UPDATE </a></td>";
                    }
                case "approve":
                    {
                        return "<td align='center'></td>";
                    }
                case "reject":
                    {
                        return "<td align='center'></td>";
                    }
                case "release":
                    {
                        return "<td align='center'></td>";
                    }
                default:
                    {
                        return "<td align='center'></td>";
                    }
            }
        }
    }

    protected String GenerateDataBatch()
    {
        string htmlelement = "";

        foreach (object[] data in BioPM.ClassObjects.BatchCatalog.GetBatch())
        {
            htmlelement += "<tr class=''><td>" + data[2].ToString() + "</td><td>" + data[3].ToString() + "</td><td>" + BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[1].ToString()) + "</td><td align='center'> " + GetProductionStatus(data[2].ToString()) + " </td>" + GetPageAction(data[2].ToString()) + "</tr>";
        }

        return htmlelement;
    }

   
</script>

<html lang="en">
<head>
<% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>BATCH QUALITY CONTROL</title>
    
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
                        Batch Product Quality Control Detail
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">

                        <div class="adv-table">
                            <div class="clearfix">
                                <%--<div class="btn-group">
                                    
                                </div>
                                <div class="btn-group pull-right">
                                    
                                </div>--%>
                            </div>
                            <table class="table table-striped table-hover table-bordered" id="dynamic-table" >
                                <thead>
                                <tr>
                                    <th>BATCH</th>
                                    <th>PRODUCT NAME</th>
                                    <th>PRODUCTION DATE</th>
                                    <th>STATUS</th>
                                    <th>QUALITY CONTROL</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% Response.Write(GenerateDataBatch()); %>
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