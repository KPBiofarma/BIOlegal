<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormRegisterUserCloned.aspx.cs" Inherits="BioPM.FormRegisterUserCloned" %>

<!DOCTYPE html>
<script runat="server">
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

    protected void SetDataToForm()
    {
        GetCostCenterData();
        GetUserRoleData();
    }


    protected void txtNIK_TextChanged(object sender, EventArgs e)
    {
        if(BioPM.ClassObjects.UserCatalog.ValidateNIKEmployee(txtNIK.Text) >= 1)
        {
            object[] values = BioPM.ClassObjects.UserCatalog.GetUserData(txtNIK.Text);
            txtName.Text = values[1].ToString();
            txtPosition.Text = values[2].ToString();
            txtUnit.Text = values[3].ToString();
            txtGroup.Text = values[4].ToString();
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(10, "NIK", "") + "');", true);
            txtNIK.Text = "";
        }
    }
    
    protected void GetCostCenterData()
    {
        ddlCostCenter.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.CostCenterCatalog.GetAllCostCenter())
        {
            ddlCostCenter.Items.Add(new ListItem(data[1].ToString(), data[0].ToString()));
        }
    }
    
    protected void GetUserRoleData()
    {
        ddlUserRole.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.UserCatalog.GetUserRole())
        {
            ddlUserRole.Items.Add(new ListItem(data[1].ToString(), data[0].ToString()));
        }
    }
    
    protected void InsertUserDataIntoDatabase()
    {
        BioPM.ClassObjects.UserCatalog.InsertEmail(txtNIK.Text, txtEmail.Text, Session["username"].ToString());
        BioPM.ClassObjects.UserCatalog.InsertPassword(txtNIK.Text, BioPM.ClassEngines.CryptographFactory.Encrypt(txtPassword.Text, true), Session["username"].ToString());
        BioPM.ClassObjects.UserCatalog.InsertUserRole(txtNIK.Text, ddlUserRole.SelectedValue, Session["username"].ToString());
        BioPM.ClassObjects.UserCatalog.UpdateCostCenter(txtNIK.Text, ddlCostCenter.SelectedValue, Session["username"].ToString());
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtNIK.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "NIK", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtEmail.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "EMAIL", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtPassword.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "PASSWORD", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePasswordCombination(txtPassword.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(13, "PASSWORD", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePasswordConfirmation(txtPassword.Text, txtPasswordConfirm.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(11, "PASSWORD", "") + "');", true);
        }
        else if (IsPostBack)
        {
            InsertUserDataIntoDatabase();
            Response.Redirect("PageUserActiveAccount.aspx");
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>USER REGISTER</title>

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
                        USER REGISTER FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                         
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NIK </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtNIK" runat="server" AutoPostBack="true" OnTextChanged="txtNIK_TextChanged" class="form-control m-bot15" placeholder="USER NIK" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NAME </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtName" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> POSITION </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtPosition" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> UNIT </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtUnit" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> GROUP </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtGroup" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> COST CENTER </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlCostCenter" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> USER ROLE </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlUserRole" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> EMAIL </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtEmail" runat="server" class="form-control m-bot15" placeholder="EMAIL"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> PASSWORD </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtPassword" runat="server" class="form-control m-bot15" placeholder="PASSWORD" TextMode="Password" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> CONFIRM PASSWORD </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtPasswordConfirm" runat="server" class="form-control m-bot15" placeholder="RETYPE PASSWORD" TextMode="Password" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnAdd" runat="server" Text="Register" OnClick="btnAdd_Click"/>
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
