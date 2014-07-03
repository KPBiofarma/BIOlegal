﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormUpdateItem.aspx.cs" Inherits="BioPM.FormUpdateItem" %>

<!DOCTYPE html>
<script runat="server">
    BioPM.ClassObjects.ItemGroup itemgroup = new BioPM.ClassObjects.ItemGroup();
    protected void Page_Load(object sender, EventArgs e)
    {
        sessionCreator();
        if (!IsPostBack) SetDataToForm();
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected void SetDataItem()
    {
        itemgroup = BioPM.ClassEngines.ObjectFactory.GetDataItemGroupByID(Session["itemgroupid"].ToString());
        BioPM.ClassObjects.Item item = BioPM.ClassEngines.ObjectFactory.GetDataItemByID(Request.QueryString["key"]);
        txtItemID.Text = item.ItemID;
        txtItemName.Text = item.ItemName;
        txtItemUnit.Text = item.ItemUnit;
        ddlItemGroup.SelectedValue = item.ItemGroupID;
    }
    
    protected void SetItemGroup()
    {
        ddlItemGroup.Items.Clear();
        foreach (BioPM.ClassObjects.ItemGroup itemgroup in BioPM.ClassEngines.ObjectFactory.GetAllDataItemGroup())
        {
            ddlItemGroup.Items.Add(new ListItem(itemgroup.ItemGroupName, itemgroup.ItemGroupID));
        }
    }

    
    protected void SetDataToForm()
    {
        SetItemGroup();
    }

    protected void UpdateItemIntoDatabase()
    {
        BioPM.ClassObjects.Item item = BioPM.ClassObjects.ItemFactory.CreateItem(txtItemID.Text, txtItemName.Text, txtItemUnit.Text, ddlItemGroup.SelectedValue, "");
        BioPM.ClassEngines.ObjectFactory.UpdateDataItem(item, Session["username"].ToString());
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (IsPostBack) UpdateItemIntoDatabase();
        Response.Redirect("PageItem.aspx?key=" + ddlItemGroup.SelectedValue);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>ITEM UPDATE</title>

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
                        <% Response.Write(itemgroup.ItemGroupID + " - " + itemgroup.ItemGroupName); %> | Item Update Form
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                         
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ITEM ID </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtItemID" runat="server" class="form-control m-bot15" placeholder="ITEM ID" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ITEM NAME </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtItemName" runat="server" class="form-control m-bot15" placeholder="ITEM NAME" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ITEM UNIT </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtItemUnit" runat="server" class="form-control m-bot15" placeholder="ITEM UNIT" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ITEM GROUP </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlItemGroup" AutoPostBack="true" runat="server" class="form-control m-bot15">   
                                
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
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
