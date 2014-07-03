using BioPM.WS_CTI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BioPM
{
    public partial class PageLoginCTI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string errorMessage = "";
            string sessionKey = Request.QueryString["token"] == null ? "" : Request.QueryString["token"];
            if (Session["username"] != null) Response.Redirect("PageUserPanel.aspx");


            if (!sessionKey.Trim().Equals("") && Session["username"] == null)
            {
                CTIAppUsers wsApp = new CTIAppUsers();
                WsAppAuthClient wsServiceClient = new WsAppAuthClient();
                this.ConfigureToWebServiceCTI(wsServiceClient);
                IPHostEntry hostEntry = Dns.GetHostEntry(Request.UserHostAddress);
                string hostName = hostEntry.HostName;
                IPHostEntry ipEntry = Dns.GetHostEntry(hostName);
                IPAddress[] addr = ipEntry.AddressList;
                string ip_address = addr[0].ToString();

                try
                {
                    CTIAppUsers resultUserServer = wsServiceClient.getUserPortal(sessionKey.Trim(), ip_address);
                    if (resultUserServer != null)  // User Sudah Login di Portal CTI
                    {
                        // split user, jika ada prefix domain
                        //char[] delimiterChars = { '\\' };
                        //string[] splitUser = resultUserServer.LoginName.ToString().Split(delimiterChars);
                        //string[] splitName = resultUserServer.Name.ToString().Split(delimiterChars);
                        //string _username = "";
                        //string _name = "";
                        //if (splitUser.Length > 1)
                        //    _username = splitUser[1].ToString().ToLower();
                        //else if (splitUser.Length == 1)
                        //    _username = splitUser[0].ToString().ToLower();


                        //if (splitName.Length > 1)
                        //    _name = splitName[1].ToString();
                        //else if (splitUser.Length == 1)
                        //    _name = splitName[0].ToString();

                        LoginToCTI(resultUserServer.Email.ToLower());
                    }
                    else
                    {
                        Response.Write("Anda belum terdaftar di dalam Aplikasi Bio-PM, silahkan hubungi administrator.");
                    }
                }
                catch (Exception ex)
                {
                    errorMessage = ex.Message.ToString();
                    Response.Write(errorMessage);
                }
                finally
                {
                    wsServiceClient.Close();
                }
            }

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

        protected bool ValidateUser(string email)
        {
            bool isValid = false;

            if (getUserFromDB(email) != null)
            {
                object[] values = getUserFromDB(email);
                SetSession(values[0].ToString(), values[1].ToString(), values[2].ToString(),values[3].ToString(), values[4].ToString(), null);
                isValid = true;
            }
            return isValid;
        }

        protected object[] getUserFromDB(string email)
        {
            return BioPM.ClassObjects.UserCatalog.GetActiveUserFromCTI(email);
        }

        protected void LoginToCTI(string email)
        {
            if (ValidateUser(email))
            {
                System.Web.Configuration.WebConfigurationManager.AppSettings["Gateway"] = "cti";
                Response.Redirect("PageUserPanel.aspx"); ;
            }
        }

        protected void ConfigureToWebServiceCTI(WsAppAuthClient proxy)
        {
            proxy.ClientCredentials.Windows.ClientCredential.Domain = ConfigurationManager.AppSettings["DomainCTI"];
            proxy.ClientCredentials.Windows.ClientCredential.UserName = ConfigurationManager.AppSettings["UsernameCTI"];
            proxy.ClientCredentials.Windows.ClientCredential.Password = ConfigurationManager.AppSettings["PasswordCTI"];
        }
    }
}