﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageLabelPrintRequest.aspx.cs" Inherits="BioPM.PageLabelPrintRequest" %>

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
    
    protected string GetPrintStatus(string PRTID)
    {
        if (BioPM.ClassObjects.LabelCatalog.GetLabelPrintFlowByPrintIDAndType(PRTID, "1") == null)
        {
            return "<span class='label label-default'> PENDING </span>";
        }
        else
        {
            switch (BioPM.ClassObjects.LabelCatalog.GetLabelPrintFlowByPrintIDAndType(PRTID, "1")[3].ToString().ToLower())
            {
                case "pending":
                    {
                        return "<span class='label label-default'> PENDING </span>";
                    }
                case "printed":
                    {
                        return "<span class='label label-primary'> PRINTED </span>";
                    }
                case "corection":
                    {
                        return "<span class='label label-warning'> UNDER CORECTION </span>";
                    }
                case "approve":
                    {
                        return "<span class='label label-success'> APPROVED </span>";
                    }
                case "unapprove":
                    {
                        return "<span class='label label-danger'> UNAPPROVED </span>";
                    }
                default:
                    {
                        return "<span class='label label-default'> PENDING </span>";
                    }
            }
        }
    }

    protected string GetPageAction(string PRTID)
    {
        if (BioPM.ClassObjects.LabelCatalog.GetLabelPrintFlowByPrintIDAndType(PRTID, "1") == null)
        {
            return "<td align='center'></td>";
        }
        else
        {

            switch (BioPM.ClassObjects.LabelCatalog.GetLabelPrintFlowByPrintIDAndType(PRTID, "1")[3].ToString().ToLower())
            {
                case "pending":
                    {
                        return "<td align='center'></td>";
                    }
                case "printed":
                    {
                        return "<td align='center'><a class='edit' href='FormInputReprintRequest.aspx?key=" + PRTID + "'> Re-Create </a></td>";
                    }
                case "corection":
                    {
                        return "<td align='center'><a class='edit' href='FormUpdatePrintRequest.aspx?key=" + PRTID + "'> Update </a></td>";
                    }
                case "approve":
                    {
                        return "<td align='center'><a class='edit' href='.aspx?key=" + PRTID + "'> Print </a></td>"; //halaman print
                    }
                case "unapprove":
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

        foreach (object[] data in BioPM.ClassObjects.LabelCatalog.GetLabelPrintData())
        {
            htmlelement += "<tr class=''><td>" + data[2].ToString() + "</td><td>" + data[3].ToString() + "</td><td>" + data[4].ToString() + "</td><td>" + data[5].ToString() + "</td><td>" + BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[1].ToString()) + "</td><td align='center'> " + GetPrintStatus(data[0].ToString()) + " </td>" + GetPageAction(data[0].ToString()) + "</tr>";
        }

        return htmlelement;
    }

   
</script>

<html lang="en">
<head>
<% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>LABEL PRINT</title>
    
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
                        Label Print Detail
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">

                        <div class="adv-table">
                            <div class="clearfix">
                                <div class="btn-group">
                                    <button id="editable-sample_new" onclick="document.location.href='FormInputLabelPrintRequest.aspx';" class="btn btn-primary"> New Request <i class="fa fa-plus"></i>
                                    </button>
                                </div>
                                <%--<div class="btn-group pull-right">
                                    
                                </div>--%>
                            </div>
                            <table class="table table-striped table-hover table-bordered" id="dynamic-table" >
                                <thead>
                                <tr>
                                    <th>BATCH</th>
                                    <th>GIN</th>
                                    <th>PRODUCT NAME</th>
                                    <th>LABEL NAME</th>
                                    <th>REQUEST DATE</th>
                                    <th>STATUS</th>
                                    <th>ACTION</th>
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