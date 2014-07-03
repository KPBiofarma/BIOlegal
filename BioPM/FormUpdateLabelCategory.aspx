﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormUpdateLabelCategory.aspx.cs" Inherits="BioPM.FormUpdateLabelCategory" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack)
        {
            SetDataToForm(Request.QueryString["key"]);
        }
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }
    
    protected void SetDataToForm(string ID)
    {
        object[] values = BioPM.ClassObjects.LabelCatalog.GetLabelCategoryByID(ID);
        txtCatID.Text = values[0].ToString();
        txtCatName.Text = values[1].ToString();
        txtCatDet.Text = values[2].ToString();
    }

    protected void InsertDataIntoDatabase()
    {
        BioPM.ClassObjects.LabelCatalog.UpdateLabelCategory(txtCatID.Text.ToUpper(), txtCatName.Text, txtCatDet.Text, Session["username"].ToString());
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        InsertDataIntoDatabase();
        Response.Redirect("PageLabelCategory.aspx");
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>CATEGORY UPDATE</title>

    <% Response.Write(BioPM.ClassScripts.StyleScripts.GetCoreStyle()); %>
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetFormStyle()); %>
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetCustomStyle()); %>
</head>

<body>

<section id="container" >
 
<!--header start--> 
 <%Response.Write( BioPM.ClassScripts.SideBarMenu.TopMenuElement(Session["name"].ToString()) ); %> 
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
                        CATEGORY UPDATE FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                         
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> CATEGORY ID </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtCatID" runat="server" class="form-control m-bot15" placeholder="CATEGORY ID" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> CATEGORY NAME </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtCatName" runat="server" class="form-control m-bot15" placeholder="CATEGORY NAME" ></asp:TextBox>
                            </div>
                        </div>
                            
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> CATEGORY DETAIL</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtCatDet" TextMode="MultiLine" runat="server" class="form-control m-bot15" placeholder="CATEGORY DETAIL" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnAdd" runat="server" Text="Update" OnClick="btnAdd_Click"/>
                                <asp:Button class="btn btn-round btn-primary" ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click"/>
                            </div>
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
    <%Response.Write(BioPM.ClassScripts.SideBarMenu.RightSidebarMenuElement()); %> 
<!--right sidebar end-->
</section>

<!-- Placed js at the end of the document so the pages load faster -->
    <% Response.Write(BioPM.ClassScripts.JS.GetCoreScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetCustomFormScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetInitialisationScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetPieChartScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetSparklineChartScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetFlotChartScript()); %>
</body>
</html>