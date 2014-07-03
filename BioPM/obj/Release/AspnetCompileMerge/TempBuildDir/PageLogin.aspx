<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageLogin.aspx.cs" Inherits="BioPM.PageLogin" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Web.Configuration.WebConfigurationManager.AppSettings["UserMenu"] = "";
        Session.Clear();
    }

    protected String GetUsername()
    {
        return uid.Text;
    }

    protected String GetPassword()
    {
        return BioPM.ClassEngines.CryptographFactory.Encrypt(upw.Text, true);
    }

    public void SetSession(string PERNR, string PASSW, string EMAIL, string CNAME, string COCTR, string ROLID)
    {
        Session["username"] = PERNR;
        Session["password"] = PASSW;
        Session["passwordperiod"] = BioPM.ClassObjects.UserCatalog.GetPasswordActivePeriod(PERNR);
        Session["email"] = EMAIL;
        Session["name"] = CNAME;
        Session["coctr"] = COCTR;
        Session["role"] = ROLID;
        System.Web.Configuration.WebConfigurationManager.AppSettings["coctr"] = COCTR;
    }

    protected void SetApplicationConfiguration()
    {
        System.Web.Configuration.WebConfigurationManager.AppSettings["UserRole"] = Session["role"].ToString();

        BioPM.ClassEngines.MenuControl config = new BioPM.ClassEngines.MenuControl();

        System.Web.Configuration.WebConfigurationManager.AppSettings["InsertMenu"] = config.InsertMenu.ToString();
        System.Web.Configuration.WebConfigurationManager.AppSettings["UpdateMenu"] = config.UpdateMenu.ToString();
        System.Web.Configuration.WebConfigurationManager.AppSettings["DeleteMenu"] = config.DeleteMenu.ToString();
        System.Web.Configuration.WebConfigurationManager.AppSettings["viewMenu"] = config.ViewMenu.ToString();
        System.Web.Configuration.WebConfigurationManager.AppSettings["PrintMenu"] = config.PrintMenu.ToString();
        System.Web.Configuration.WebConfigurationManager.AppSettings["ExportMenu"] = config.ExportMenu.ToString();
    }

    protected bool ValidateUser()
    {
        bool isValid = false;

        if (getUserFromDB() != null)
        {
            object[] values = getUserFromDB();
            SetSession(values[0].ToString(), values[1].ToString(), values[2].ToString(), values[3].ToString(), values[5].ToString(), null);
            isValid = true;
        }
        return isValid;
    }

    protected object[] getUserFromDB()
    {
        return BioPM.ClassObjects.UserCatalog.GetActiveUser(GetUsername(), GetPassword());
    }

    protected void hluserpage_Click(object sender, EventArgs e)
    {
        if (uid.Text == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "USERNAME REQUIRED" + "');", true);
        }
        else if (upw.Text == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "PASSWORD REQUIRED" + "');", true);
        }
        else if (!ValidateUser())
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "USERNAME OR PASSWORD IS NOT RECOGNIZED" + "');", true);
            uid.Text = null;
            upw.Text = null;
            return;
        }
        else
        {
            //SetApplicationConfiguration();
            System.Web.Configuration.WebConfigurationManager.AppSettings["Gateway"] = "local";
            Response.Redirect("PageUserPanel.aspx");
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<link rel="stylesheet" href="Scripts/login.css" type="text/css" />
<body>
    <div id="container" runat="server">
        <form id="frmLogin" runat="server">
            <div class="login">LOGIN</div>
            <div class="username-text">Username:</div>
            <div class="password-text">Password:</div>
            <div class="username-field" runat="server">
                <asp:TextBox type="text" ID="uid" name="username" runat="server" />
            </div>
            <div class="password-field" runat="server">
                <asp:TextBox type="password" ID="upw" name="password" runat="server" />
            </div>
            <div class="forgot-usr-pwd">Forgot <a href="#">username</a> or <a href="#">password</a>?</div>
            <div class="home" runat="server">
                <asp:LinkButton runat="server" ID="hluserpage" OnClick="hluserpage_Click">GO</asp:LinkButton>
            </div>

        </form>
    </div>
</body>
</html>