﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageReport.aspx.cs" Inherits="BioPM.PageReport" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        sessionCreator();
    }
    protected void sessionCreator()
    {     
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected String GenerateDataProduk()
    {
        string htmlelement = "";

        for (int i = 0; i < 10; i++ )
        {
            htmlelement += "<tr class=''><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td><td>" + "DATA" + "</td></tr>";
        }
        
        return htmlelement;
    }

   
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>PR</title>

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
            <div class="col-lg-12">
                <section class="panel">
                    <header class="panel-heading">
                        PR Detail
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                      <form class="form-horizontal " runat="server" >
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> CATEGORY </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlCategory" AutoPostBack="true" runat="server" class="form-control m-bot15">   
                                <asp:ListItem > Kategori 1</asp:ListItem>
                                <asp:ListItem > Kategori 2</asp:ListItem>
                                <asp:ListItem > Kategori 3</asp:ListItem>
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3">START DATE</label>
                            <div class="col-md-4 col-lg-3">
                               <asp:TextBox ID="txtStartDate" value="" size="16" class="form-control form-control-inline input-medium default-date-picker" runat="server"></asp:TextBox>
                                <span class="help-block">Date Format : month-day-year e.g. 01-31-2014</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3">END DATE</label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtEndaDate" value="" size="16" class="form-control form-control-inline input-medium default-date-picker" runat="server"></asp:TextBox>
                                <span class="help-block">Date Format : month-day-year e.g. 01-31-2014</span>
                            </div>
                        </div>

                        <div class="adv-table">
                            <div class="clearfix">
                                
                            </div>
                            <table class="table table-striped table-hover table-bordered" id="dynamic-table" >
                                
<thead>
                                <tr>
                                    <th rowspan="2">NO</th>
                                    <th rowspan="2">NOMOR PR</th>
                                    <th rowspan="2">DESKRIPSI PR</th>
                                    <th colspan ="2">OWNER ESTIMATE</th>
                                    <th colspan ="2">SPPH</th>
                                    <th colspan ="2">SPH</th>
                                    <th colspan ="2">EVALUASI</th>
                                    <th colspan ="2">BANH</th>
                                    <th colspan ="2">KONFIRMASI ORDER</th>
                                    <th colspan ="2">SPP/SPK/KONTRAK</th>
                                </tr>
                                <tr>
                                    <th>Tgl Transaksi</th>
                                    <th>Tgl Buat</th>
                                    <th>Tgl Transaksi</th>
                                    <th>Tgl Buat</th>
                                    <th>Tgl Transaksi</th>
                                    <th>Tgl Buat</th>
                                    <th>Tgl Transaksi</th>
                                    <th>Tgl Buat</th>
                                    <th>Tgl Transaksi</th>
                                    <th>Tgl Buat</th>
                                    <th>Tgl Transaksi</th>
                                    <th>Tgl Buat</th>
                                    <th>Tgl Transaksi</th>
                                    <th>Tgl Buat</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% Response.Write(GenerateDataProduk()); %>
                                </tbody>
                            </table>
                        </div>
                        </form>
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
