<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageInformation.aspx.cs" Inherits="BioPM.PageInformation" %>

<!DOCTYPE html>
<script runat="server">
    string message = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack) DeleteDataOnDatabase(Request.QueryString["key"], Request.QueryString["type"]);
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }
    
    protected void DeleteDataOnDatabase(string ID, string KEY)
    {
        switch (KEY)
        {
            case "0":
                {
                    //USER
                    break;
                }   
                /*
            case "1":
                {
                    BioPM.ClassObjects.ProductCatalog.DeleteProduct(ID);
                    message = "DELETE SUCCESS! PRODUCT ID " + ID + " HAS BEEN DELETED. <a href='PageProduct.aspx'>BACK</a>.";
                    break;
                }
            case "2":
                {
                    BioPM.ClassObjects.ProductCatalog.DeleteProductType(ID);
                    message = "DELETE SUCCESS! PRODUCT TYPE ID " + ID + " HAS BEEN DELETED. <a href='PageProductType.aspx'>BACK</a>.";
                    break;
                }
            case "3":
                {
                    BioPM.ClassObjects.ProductCatalog.DeleteProductGroup(ID);
                    message = "DELETE SUCCESS! PRODUCT GROUP ID " + ID + " HAS BEEN DELETED. <a href='PageProductGroup.aspx'>BACK</a>.";
                    break;
                }
            case "4":
                {
                    BioPM.ClassObjects.BatchCatalog.DeleteBatch(ID);
                    message = "DELETE SUCCESS! VACCINE GROUP ID " + ID + " HAS BEEN DELETED. <a href='PagevaccineGroup.aspx'>BACK</a>.";
                    break;
                }
            case "5":
                {
                    BioPM.ClassObjects.QualityControlCatalog.DeleteQualityControlType(ID);
                    message = "DELETE SUCCESS! QUALITY CONTROL TYPE ID " + ID + " HAS BEEN DELETED. <a href='PageQualityControlType.aspx'>BACK</a>.";
                    break;
                }
            case "6":
                {
                    //QC METHOD
                    break;
                }
            case "7":
                {
                    BioPM.ClassObjects.BatchCatalog.DeleteBatch(ID);
                    message = "DELETE SUCCESS! BATCH ID " + ID + " HAS BEEN DELETED. <a href='PageBatch.aspx'>BACK</a>.";
                    break;
                }
            case "8":
                {
                    BioPM.ClassObjects.ItemCatalog.DeleteItemGroup(ID);
                    message = "DELETE SUCCESS! ITEM GROUP ID " + ID + " HAS BEEN DELETED. <a href='PageItemGroup.aspx'>BACK</a>.";
                    break;
                }
            case "9":
                {
                    BioPM.ClassObjects.ItemCatalog.DeleteItem(ID);
                    message = "DELETE SUCCESS! ITEM ID " + ID + " HAS BEEN DELETED. <a href='PageItem.aspx'>BACK</a>.";
                    break;
                }
            case "10":
                {
                    BioPM.ClassObjects.ItemCatalog.DeleteStyle(ID);
                    message = "DELETE SUCCESS! STYLE/PABRIKAN ID " + ID + " HAS BEEN DELETED. <a href='PageStyle.aspx'>BACK</a>.";
                    break;
                }
            case "11":
                {
                    BioPM.ClassObjects.VendorCatalog.DeleteVendorGroup(ID);
                    message = "DELETE SUCCESS! VENDOR GROUP ID " + ID + " HAS BEEN DELETED. <a href='PageVendorGroup.aspx'>BACK</a>.";
                    break;
                }
            case "12":
                {
                    BioPM.ClassObjects.VendorCatalog.DeleteVendor(ID);
                    message = "DELETE SUCCESS! VENDOR ID " + ID + " HAS BEEN DELETED. <a href='PageVendor.aspx'>BACK</a>.";
                    break;
                }
            case "13":
                {
                    BioPM.ClassObjects.DilutionCatalog.DeleteDilution(ID, Session["username"].ToString());
                    message = "DELETE SUCCESS! DILUTION SAMPLE FOR PRODUCT ID " + ID + " HAS BEEN DELETED. <a href='PageDilutionSample.aspx'>BACK</a>.";
                    break;
                }
            case "14":
                {
                    BioPM.ClassObjects.NvtCatalog.DeleteNVTBuilding(ID);
                    message = "DELETE SUCCESS! NVT BUILDING ID " + ID + " HAS BEEN DELETED. <a href='PageNVTBuilding.aspx'>BACK</a>.";
                    break;
                }
            case "15":
                {
                    //PRODUCT FORMULATION
                    break;
                }
            case "16":
                {
                    //QC PRODUCT
                    break;
                }
            case "17":
                {
                    //LABEL
                    break;
                }
            case "18":
                {
                    //LABEL CATEGORY
                    break;
                }
            case "19":
                {
                    //LABEL SUB CATEGORY
                    break;
                }
            case "20":
                {
                    //PRINT LABEL
                    break;
                }*/
            case "21":
                {
                    BioPM.ClassObjects.RiskCatalog.DeleteRisk(ID, Session["username"].ToString());
                    message = "DELETE SUCCESS! REGISTER ID " + ID + " HAS BEEN DELETED. <a href='PageRisk.aspx'>BACK</a>.";
                    break;
                }
            default :
                {
                    break;
                }
                
        }
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>Dashboard</title>

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
                        INFORMATION
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <% Response.Write(message); %> 
                    </div>
                </section>
            </div>
        </div>
        <!-- page end-->
        </section>
    </section>
    <!--main content end-->
</section>

<!-- Placed js at the end of the document so the pages load faster -->
<% Response.Write(BioPM.ClassScripts.JS.GetCoreScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetDynamicTableScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetInitialisationScript()); %>
</body>
</html>
