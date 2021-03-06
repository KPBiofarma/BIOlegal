﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageInputProductFormulation.aspx.cs" Inherits="BioPM.PageInputProductFormulation" %>

<!DOCTYPE html>
<script runat="server">
    BioPM.ClassObjects.Product product = new BioPM.ClassObjects.Product();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack) SetDataToForm();
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected void SetItemGroup()
    {
        ddlItemGroup.Items.Clear();
        foreach (BioPM.ClassObjects.ItemGroup itemgroup in BioPM.ClassEngines.ObjectFactory.GetAllDataItemGroup())
        {
            ddlItemGroup.Items.Add(new ListItem(itemgroup.ItemGroupName, itemgroup.ItemGroupID));
        }
    }

    protected void ddlItemGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack) SetItem();
    }
    
    protected void SetItem()
    {
        ddlItem.Items.Clear();
        foreach (BioPM.ClassObjects.Item item in BioPM.ClassEngines.ObjectFactory.GetDataItemByItemGroupID(ddlItemGroup.SelectedValue))
        {
            ddlItem.Items.Add(new ListItem(item.ItemName, item.ItemID));
        }
    }

    protected void ddlItem_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            SetStyle();
            txtUnit.Text = BioPM.ClassEngines.ObjectFactory.GetDataItemByID(ddlItem.SelectedValue).ItemUnit;
        }
    }


    protected void SetStyle()
    {
        ddlStyle.Items.Clear();
        foreach (BioPM.ClassObjects.Style style in BioPM.ClassEngines.ObjectFactory.GetDataStyleByItemID(ddlItem.SelectedValue))
        {
            ddlStyle.Items.Add(new ListItem(style.StyleName, style.StyleID));
        }
    }

    protected void SetDataToForm()
    {
        product = BioPM.ClassEngines.ObjectFactory.GetDataProductByID(Session["productid"].ToString());
        SetItemGroup();
        SetItem();
        SetStyle();
    }
        
    protected void InsertProductQualityControlIntoDatabase()
    {
        BioPM.ClassObjects.Formulation formulation = BioPM.ClassObjects.FormulationFactory.CreateFormulation(product.ProductID, (cbxFlagQC.Checked == true ? "X" : ""), txtQuantity.Text, ddlStyle.SelectedValue, "", ddlItem.SelectedValue, "", txtUnit.Text, ddlItemGroup.SelectedValue, "");
        BioPM.ClassEngines.ObjectFactory.InsertDataFormulation(formulation, Session["username"].ToString());
    }
    
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (IsPostBack) InsertProductQualityControlIntoDatabase();
        Response.Redirect("PageProductFormulation.aspx");
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>PRODUCT FORMULATION ENTRY</title>

    <% Response.Write(BioPM.ClassScripts.StyleScripts.GetCoreStyle()); %>
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetTableStyle()); %>
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
                    <header class="panel-heading" style="font-weight:bold">
                        <% Response.Write(product.ProductID + " - " + product.ProductName); %> | Formulation Entry Form
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                         
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NAMA ITEM GRUP </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlItemGroup" AutoPostBack="true" runat="server" class="form-control m-bot15" OnSelectedIndexChanged="ddlItemGroup_SelectedIndexChanged">   
                                
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NAMA ITEM </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlItem" AutoPostBack="true" runat="server" class="form-control m-bot15" OnSelectedIndexChanged="ddlItem_SelectedIndexChanged">   
                                
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NAMA PABRIKAN </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:DropDownList ID="ddlStyle" AutoPostBack="true" runat="server" class="form-control m-bot15">   
                                
                                </asp:DropDownList> 
                            </div>
                        </div>
                            
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> KUANTITAS </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtQuantity" runat="server" class="form-control m-bot15" placeholder="KUANTITAS" ></asp:TextBox>
                                <asp:TextBox ID="txtUnit" runat="server" class="form-control m-bot15" placeholder="" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">Formula QC</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:CheckBox ID="cbxFlagQC" Checked="false" data-on-label="<i class='fa fa-check'></i>" data-off-label="<i class='fa fa-times'></i>" runat="server" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click"/>
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
