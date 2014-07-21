<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormInputBatch.aspx.cs" Inherits="BioPM.FormInputBatch" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        sessionCreator();
        if (!IsPostBack)
        {
            SetProbabilityData();
            if (ddlProbability.Visible == true)
            {
                SetProbabilityMethod();
            }
            SetRiskData();
            SetRiskActivity();
            SetRiskFunction();
            SetRiskManagement();
            SetRiskImpactBase();
            SetOrganizationID();
        }
    }
     
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }
    
    /* Section: Set data from & to database */

    protected string GenerateRegID()
    {
        string htmlelement = "";
        
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetExistingRegisterID())
        {
            string RSKID = data[1].ToString() + " - " + data[2].ToString() + " - " + data[3].ToString();
            htmlelement += "<tr class=''><td>" + BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[0].ToString()) + "</td><td>" + RSKID + "</td><td><a class='edit' href='FormUpdateRisk.aspx?key=" + data[3].ToString() + "'>Edit</a>";
            
        }
        return htmlelement;
    }
    
    protected void InsertRiskIntoDatabase()
    {
        string RSKID = (BioPM.ClassObjects.RiskCatalog.GetRiskMatchID() + 1).ToString();
        BioPM.ClassObjects.RiskCatalog.InsertRisk(ddlOrganization.SelectedItem.Text, ddlActivity.SelectedItem.Text, RSKID, txtRKEVT.Text, labelAct.Text, ddlRKFNC.SelectedItem.Text, txtSuppDt.Text, txtRiskCause.Text, txtRiskLoc.Text, ddlFrequency.SelectedItem.Text, txtProb.Text, ddlImpactBase.SelectedItem.Text, Convert.ToInt32(Convert.ToDouble(txtRiskImpact.Text)).ToString(), Convert.ToInt32(Convert.ToDouble(lbRiskStatus.Text)).ToString(), ddlRKMGT.SelectedItem.Text, Session["username"].ToString());
    }

    protected void SetOrganizationID()
    {
        ddlOrganization.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetDataFromOrganization())
        {
            ddlOrganization.Items.Add(new ListItem(data[0].ToString() + " - " + data[1].ToString()));
        }
    }
    
    protected void SetRiskImpactBase()
    {
        ddlImpactBase.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetDataFromParameter("IB"))
        {
            ddlImpactBase.Items.Add(new ListItem(data[0].ToString()));
        }
    }
    
    protected void SetRiskManagement()
    {
        ddlRKMGT.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetDataFromParameter("RM"))
        {
            ddlRKMGT.Items.Add(new ListItem(data[0].ToString()));
        }
    }
    
    protected void SetRiskFunction()
    {
        ddlRKFNC.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetDataFromParameter("RF"))
        {
            ddlRKFNC.Items.Add(new ListItem(data[0].ToString()));
        }
    }
    
    protected void SetProbabilityData()
    {
        ddlProbability.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetDataFromParameter("PT"))
        {
            ddlProbability.Items.Add(new ListItem(data[0].ToString()));
        }
    }
        
    protected void SetProbabilityMethod()
    {
        if (ddlProbability.SelectedValue.Equals("Poisson"))
        {
            EnablePoisson();
        }
        else if (ddlProbability.SelectedValue.Equals("Binomial"))
        {
            EnableBinomial();
        }
        else if (ddlProbability.SelectedValue.Equals("Normal"))
        {
            EnableNormal();
        }
    }
   
    protected void SetRiskActivity()
    {
        labelAct.Text = ddlActivity.SelectedValue;
    }
    
    protected void SetRiskData()
    {
        ddlActivity.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetDataFromParameter("RA"))
        {
            ddlActivity.Items.Add(new ListItem(data[1].ToString() + " - " + data[0].ToString(), data[0].ToString()));
        }
    }
    
    /* Section: Button click */ 
    
    protected void btnPoisson_Click(object sender, EventArgs e)
    {
        string function = ddlRKFNC.SelectedItem.Text;
        string frequency = BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function).ToString();
        string mean = BioPM.ClassEngines.ProbabilityAndStatisticFactory.CalculateMean().ToString();
        txtProb.Text = BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoPoissonProbability(frequency, mean).ToString();
        btnPoisson.Visible = false;
    }

    protected void btnBinomial_Click(object sender, EventArgs e)
    {
        string function = ddlRKFNC.SelectedItem.Text;
        string failure = txRskGagal.Text;
        string frequency = BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function).ToString();
        string sampleSuccess = txFreqKejSkses.Text;
        txtProb.Text = BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoBinomialProbability(failure, frequency, sampleSuccess).ToString() ;
        btnBinomial.Visible = false;
    }

    protected void btnNormal_Click(object sender, EventArgs e)
    {
        string function = ddlRKFNC.SelectedItem.Text;
        string frequency = BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function).ToString();
        string mean = BioPM.ClassEngines.ProbabilityAndStatisticFactory.CalculateMean().ToString();
        string stdDeviation = BioPM.ClassEngines.ProbabilityAndStatisticFactory.CalculateStandardDeviation().ToString();
        double z = BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoNormalDistribution(frequency, mean, stdDeviation);
        double qz = BioPM.ClassEngines.ProbabilityAndStatisticFactory.poz(Math.Abs(z));
        txtProb.Text = qz.ToString();
        btnNormal.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Session["password"].ToString() == BioPM.ClassEngines.CryptographFactory.Encrypt(txtConfirmationRisk.Text, true))
        {
            InsertRiskIntoDatabase();
            Response.Redirect("PageRisk.aspx");
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "YOUR PASSWORD IS INCORRECT" + "');", true);
        }
    }

    /* Section: Selected index and text changed */
    
    protected void ddlProbability_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack) SetProbabilityMethod();    
    }

    protected void ddlRKFNC_SelectedIndexChanged(object sender, EventArgs e)
    {
        CheckExistingDatabase(ddlRKFNC.SelectedItem.Text);
    }
    
    protected void txtRiskImpact_TextChanged(object sender, EventArgs e)
    {
        
        lbRiskStatus.Text = (Convert.ToDouble(txtProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();
        
    }

    protected void ddlActivity_SelectedIndexChanged(object sender, EventArgs e)
    {
        SetRiskActivity();
    }

    protected void ddlImpactBase_SelectedIndexChanged(object sender, EventArgs e)
    {
        double tmp = Convert.ToDouble(txtRiskImpact.Text);
        double div = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetReferenceValue("2013"));
        double res = tmp / div;
        txtRiskImpact.Text = res.ToString();
    }
    
    protected void EnablePoisson()
    {
        txFreq.Visible = false;
        txRata2.Visible = false;
        txRskGagal.Visible = false;
        txFreqKejSkses.Visible = false;
        txSDev.Visible = false;
        btnPoisson.Visible = true;
        btnBinomial.Visible = false;
        btnNormal.Visible = false;
        txtProb.Text = "";
    }

    protected void EnableBinomial()
    {
        txFreq.Visible = false;
        txRata2.Visible = false;
        txRskGagal.Visible = true;
        txFreqKejSkses.Visible = true;
        txSDev.Visible = false;
        btnPoisson.Visible = false;
        btnBinomial.Visible = true;
        btnNormal.Visible = false;
        txtProb.Text = "";
    }

    protected void EnableNormal()
    {
        txFreq.Visible = false;
        txRata2.Visible = false;
        txRskGagal.Visible = false;
        txFreqKejSkses.Visible = false;
        txSDev.Visible = false;
        btnPoisson.Visible = false;
        btnBinomial.Visible = false;
        btnNormal.Visible = true;
        txtProb.Text = "";
    }

    protected void CheckExistingDatabase(string function)
    {
        double freq = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function));
        if (freq == 0)
        {
            ddlProbability.Visible = false;
        }
        else if ( freq >= 1 )
        {
            ddlProbability.Visible = true;
        }
    }

    protected double GetFrequency(string function)
    {
        return Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function));
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>RISK ENTRY</title>

    <% Response.Write(BioPM.ClassScripts.StyleScripts.GetCoreStyle()); %>
    <% Response.Write(BioPM.ClassScripts.StyleScripts.GetFormStyle()); %>
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
                    <header class="panel-heading">
                        RISK ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form id="Form1" class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NO REGISTRASI </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:DropDownList ID="ddlOrganization" style="width:auto; display:inline;" runat="server" class="form-control m-bot15"></asp:DropDownList>
                                <asp:Label ID="Label1" runat="server" Text=" - "></asp:Label>
                                <asp:DropDownList ID="ddlActivity" style="width:auto; display:inline;" AutoPostBack="true" runat="server" class="form-control m-bot15" 
                                    OnSelectedIndexChanged="ddlActivity_SelectedIndexChanged"></asp:DropDownList>

                                <span class="help-block">Hint : Kode Unit - Kode Aktivitas</></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK EVENT </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtRKEVT" runat="server" class="form-control m-bot15" placeholder="RISK EVENT" ></asp:TextBox>
                            </div>
                        </div>
                            
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK ACTIVITY </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:Label ID="labelAct" runat="server" AutoPostBack="true" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK FUNCTION </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlRKFNC" runat="server" AutoPostBack="true" class="form-control m-bot15" OnSelectedIndexChanged="ddlRKFNC_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                        </div>

                       <div class="form-group">
                            <label class="col-sm-3 control-label"> SUPPORTED DATA </label>
                            <div class="col-md-4 col-lg-3">
                                    <asp:TextBox ID="txtSuppDt" runat="server" class="form-control m-bot15" placeholder="SUPPORTED DATA" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK CAUSE </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtRiskCause" runat="server" class="form-control m-bot15" placeholder="RISK CAUSE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK LOCATION </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtRiskLoc" runat="server" class="form-control m-bot15" placeholder="RISK LOCATION" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> PAST RISK RECORD </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlFrequency" class="form-control m-bot15" runat="server" AutoPostBack="true">
                                    <asp:ListItem Value="No">No</asp:ListItem>
                                    <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK PROBABILITY </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlProbability" class="form-control m-bot15" Visible="false" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlProbability_SelectedIndexChanged" />
                                <asp:TextBox ID="txtProb" class="form-control m-bot15" placeholder="Risk Probablitity" AutoPostBack="true" runat="server"></asp:TextBox>
                                <asp:TextBox ID="txFreq" class="form-control m-bot15" runat="server" placeholder="Frekuensi Kejadian" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txRata2" class="form-control m-bot15" runat="server" placeholder="Rata - rata Kejadian" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txRskGagal" class="form-control m-bot15" runat="server" placeholder="Kemungkinan Risiko Gagal" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txFreqKejSkses" class="form-control m-bot15" runat="server" placeholder="Frekuensi Kejadian Sukses" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txSDev" class="form-control m-bot15" runat="server" placeholder="Standard Deviasi" Visible="false"></asp:TextBox>
                            </div>
                            <div class="col-md-4 col-lg-3">
                                <asp:Button ID="btnPoisson" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnPoisson_Click" />
                                <asp:Button ID="btnBinomial" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnBinomial_Click" />
                                <asp:Button ID="btnNormal" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnNormal_Click" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK IMPACT </label>
                            <div class="col-md-4 col-lg-3">
                                 <asp:TextBox ID="txtRiskImpact" runat="server" class="form-control m-bot15" placeholder="RISK IMPACT" ftxtAutoPostBack="true" OnTextChanged="txtRiskImpact_TextChanged"></asp:TextBox>
                            </div>
                        </div>                        

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> IMPACT BASE </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlImpactBase" runat="server" AutoPostBack="True" class="form-control m-bot15" OnSelectedIndexChanged="ddlImpactBase_SelectedIndexChanged"></asp:DropDownList>
                            </div>
                        </div>

                       <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK STATUS </label>
                            <div class="col-md-4 col-lg-3">
                                    <asp:Label ID="lbRiskStatus" runat="server" class="form-control m-bot15" Text="RISK STATUS" AutoPostBack="true"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK MANAGEMENT </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlRKMGT" runat="server" class="form-control m-bot15" AutoPostBack="true" ></asp:DropDownList>
                            </div>
                        </div>                        

                        <!-- Modal -->
                        <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="myModal" class="modal fade">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title">Approver Confirmation</h4>
                                    </div>
                                    <div class="modal-body">
                                        <p>You Are Logged In As <% Response.Write(Session["name"].ToString()); %></p><br />
                                        <p>Are you sure to insert into database?</p>
                                        <asp:TextBox ID="txtConfirmationRisk" runat="server" TextMode="Password" placeholder="Confirmation Password" class="form-control placeholder-no-fix"></asp:TextBox>

                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="btnCloseRisk" runat="server" data-dismiss="modal" class="btn btn-default" Text="Cancel"></asp:Button>
                                        <asp:Button ID="btnSubmitRisk" runat="server" class="btn btn-success" Text="Confirm" OnClick="btnSave_Click"></asp:Button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- modal -->

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:LinkButton data-toggle="modal" class="btn btn-round btn-primary" ID="btnActionRisk" runat="server" Text="Save" href="#myModal"/>
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
<% Response.Write(BioPM.ClassScripts.JS.GetDynamicTableScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetFlotChartScript()); %>
</body>
</html>
