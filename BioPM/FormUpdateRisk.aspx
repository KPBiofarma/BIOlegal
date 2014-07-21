<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormUpdateRisk.aspx.cs" Inherits="BioPM.FormUpdateRisk" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack)
        {
            SetDataToForm();
            SetProbabilityData();
            if (ddlProbability.Visible == true)
            {
                SetProbabilityMethod();
            }
            SetRiskFunction();
            SetRiskManagement();
            SetRiskImpactBase();
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
    
    protected void SetDataToForm()
    {
        object[] values = BioPM.ClassObjects.RiskCatalog.GetRiskByID(Request.QueryString["key"]);
        txtORGID.Text = values[0].ToString();
        txtACTID.Text = values[1].ToString();
        txtRSKID.Text = values[2].ToString();
        txtRiskEvent.Text = values[3].ToString();
        labelAct.Text = values[4].ToString();
        ddlRiskFunc.SelectedValue = values[5].ToString();
        txtSuppDt.Text = values[6].ToString();
        txtRiskCause.Text = values[7].ToString();
        txtRiskLoc.Text = values[8].ToString();
        txtProb.Text = values[9].ToString();
        //txtProb.Text = values[9].ToString();
        txtRiskImpact.Text = values[10].ToString();
        lbRiskStatus.Text = values[11].ToString();
        ddlRKMGT.SelectedValue = values[12].ToString(); 
    }
    
    protected void InsertRiskIntoDatabase()
    {
        BioPM.ClassObjects.RiskCatalog.UpdateRisk(txtORGID.Text, txtACTID.Text, txtRSKID.Text, txtRiskEvent.Text, labelAct.Text, ddlRiskFunc.SelectedItem.Text, txtSuppDt.Text, txtRiskCause.Text, txtRiskLoc.Text, ddlFrequency.SelectedItem.Text, txtProb.Text, ddlImpactBase.SelectedItem.Text, txtRiskImpact.Text, Convert.ToInt32(Convert.ToDouble(lbRiskStatus.Text)).ToString(), ddlRKMGT.SelectedItem.Text, Session["username"].ToString());
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
        ddlRiskFunc.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetDataFromParameter("RF"))
        {
            ddlRiskFunc.Items.Add(new ListItem(data[0].ToString()));
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
        txtProb.ReadOnly = true;
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

    /* Section: Button click */
    
    protected void btnPoisson_Click(object sender, EventArgs e)
    {
        string function = ddlRiskFunc.SelectedItem.Text;
        string frequency = BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function).ToString();
        string mean = BioPM.ClassEngines.ProbabilityAndStatisticFactory.CalculateMean().ToString();
        txtProb.Text = BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoPoissonProbability(frequency, mean).ToString();
        lbRiskStatus.Text = (Convert.ToDouble(txtProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();
        
        txFreq.Visible = false;
        txRata2.Visible = false;
        txRskGagal.Visible = false;
        txFreqKejSkses.Visible = false;
        txSDev.Visible = false;
        btnChangeProb.Visible = true;
        btnPoisson.Visible = false;
        ddlProbability.Visible = false;
    }

    protected void btnBinomial_Click(object sender, EventArgs e)
    {
        string function = ddlRiskFunc.SelectedItem.Text;
        string failure = txRskGagal.Text;
        string frequency = BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function).ToString();
        string sampleSuccess = txFreqKejSkses.Text;
        txtProb.Text = BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoBinomialProbability(failure, frequency, sampleSuccess).ToString();
        //txtProb.Text = BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoBinomialProbability(failure, frequency, sampleSuccess).ToString();
        lbRiskStatus.Text = (Convert.ToDouble(txtProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();
        
        txFreq.Visible = false;
        txRata2.Visible = false;
        txRskGagal.Visible = false;
        txFreqKejSkses.Visible = false;
        txSDev.Visible = false;
        btnChangeProb.Visible = true;
        btnBinomial.Visible = false;
        ddlProbability.Visible = false;
    }

    protected void btnNormal_Click(object sender, EventArgs e)
    {
        string function = ddlRiskFunc.SelectedItem.Text;
        string frequency = BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function).ToString();
        string mean = BioPM.ClassEngines.ProbabilityAndStatisticFactory.CalculateMean().ToString();
        string stdDeviation = BioPM.ClassEngines.ProbabilityAndStatisticFactory.CalculateStandardDeviation().ToString();
        double z = BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoNormalDistribution(frequency, mean, stdDeviation);
        double qz = BioPM.ClassEngines.ProbabilityAndStatisticFactory.poz(Math.Abs(z));
        txtProb.Text = qz.ToString();
        lbRiskStatus.Text = (Convert.ToDouble(txtProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();
        //txtProb.Text = qz.ToString();
         
        txFreq.Visible = false;
        txRata2.Visible = false;
        txRskGagal.Visible = false;
        txFreqKejSkses.Visible = false;
        txSDev.Visible = false;
        btnChangeProb.Visible = true;
        btnNormal.Visible = false;
        ddlProbability.Visible = false;
    }

    protected void btnChangeProb_Click(object sender, EventArgs e)
    {
        //ddlProbability.Visible = false;
        btnChangeProb.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Session["password"].ToString() == BioPM.ClassEngines.CryptographFactory.Encrypt(txtConfirmation.Text, true))
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

    protected void txtRiskImpact_TextChanged(object sender, EventArgs e)
    {
        lbRiskStatus.Text = (Convert.ToDouble(txtProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();
    }

    protected void probChanged(object sender, EventArgs e)
    {
        lbRiskStatus.Text = (Convert.ToDouble(txtProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();
    }

    protected void ddlProbability_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack) SetProbabilityMethod();
    }

    protected void ddlRiskFunc_SelectedIndexChanged(object sender, EventArgs e)
    {
        CheckExistingDatabase(ddlRiskFunc.SelectedItem.Text);
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
        else if (freq >= 1)
        {
            ddlProbability.Visible = true;
            txtProb.ReadOnly = true;
        }
    }
   
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>UPDATE RISK</title>

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
                        RISK ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form id="Form1" class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> REGISTRATION ID </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtORGID" style="width:100px; display:inline;" runat="server" class="form-control m-bot15" placeholder="REGISTRATION ID" ReadOnly="true"></asp:TextBox>
                                <asp:Label ID="Label2" runat="server" Text=" - "></asp:Label>
                                <asp:TextBox ID="txtACTID" style="width:100px; display:inline;" runat="server" class="form-control m-bot15" placeholder="REGISTRATION ID" ReadOnly="true"></asp:TextBox>
                                <asp:Label ID="Label3" runat="server" Text=" - "></asp:Label>
                                <asp:TextBox ID="txtRSKID" style="width:100px; display:inline;" runat="server" class="form-control m-bot15" placeholder="REGISTRATION ID" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
    
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK EVENT </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtRiskEvent" runat="server" class="form-control m-bot15" placeholder="RISK EVENT" ></asp:TextBox>
                                <asp:Label ID="Label1" runat="server" Text=" - "></asp:Label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK ACTIVITY </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:Label ID="labelAct" runat="server" AutoPostBack="true" class="form-control m-bot15" ReadOnly="true"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK FUNCTION </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlRiskFunc" runat="server" class="form-control m-bot15" AutoPostBack="true" OnSelectedIndexChanged="ddlRiskFunc_SelectedIndexChanged"></asp:DropDownList>
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
                            <label class="col-sm-3 control-label"> RISK FREQUENCY </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlFrequency" class="form-control m-bot15" runat="server" AutoPostBack="true">
                                    <asp:ListItem>Choose Frequency</asp:ListItem>
                                    <asp:ListItem>Happened</asp:ListItem>
                                    <asp:ListItem>Never</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="form-group">
                        <label class="col-sm-3 control-label"> RISK PROBABILITY </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlProbability" class="form-control m-bot15" AutoPostBack="true" Visible="false" runat="server" OnSelectedIndexChanged="ddlProbability_SelectedIndexChanged" />
                                <asp:TextBox ID="txtProb" class="form-control m-bot15" placeholder="Risk Probablitity" AutoPostBack="true" runat="server"></asp:TextBox>
                                <asp:TextBox ID="txFreq" class="form-control m-bot15" runat="server" placeholder="Frekuensi Kejadian" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txRata2" class="form-control m-bot15" runat="server" placeholder="Rata - rata Kejadian" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txRskGagal" class="form-control m-bot15" runat="server" placeholder="Kemungkinan Risiko Gagal" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txFreqKejSkses" class="form-control m-bot15" runat="server" placeholder="Frrekuensi Kejadian Sukses" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txSDev" class="form-control m-bot15" runat="server" placeholder="Standard Deviasi" Visible="false"></asp:TextBox>
                            </div>
                            <div class="col-md-4 col-lg-3">
                                <asp:Button ID="btnChangeProb" runat="server" class="btn btn-round btn-primary" Text="Change" OnClick="btnChangeProb_Click"/>
                                <asp:Button ID="btnPoisson" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnPoisson_Click" />
                                <asp:Button ID="btnBinomial" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnBinomial_Click" />
                                <asp:Button ID="btnNormal" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnNormal_Click" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> IMPACT BASE </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlImpactBase" runat="server" AutoPostBack="True" class="form-control m-bot15"></asp:DropDownList>
                            </div>
                        </div>            


                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK IMPACT </label>
                            <div class="col-md-4 col-lg-3">
                                 <asp:TextBox ID="txtRiskImpact" runat="server" class="form-control m-bot15" placeholder="RISK IMPACT" AutoPostBack="true" OnTextChanged="txtRiskImpact_TextChanged"></asp:TextBox>
                            </div>
                        </div>                        

                       <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK STATUS </label>
                            <div class="col-md-4 col-lg-3">
                                    <asp:Label ID="lbRiskStatus" runat="server" class="form-control m-bot15" placeholder="RISK STATUS" AutoPostBack="true"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK MAINTENANCE </label>
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
                                        <asp:TextBox ID="txtConfirmation" runat="server" TextMode="Password" placeholder="Confirmation Password" class="form-control placeholder-no-fix"></asp:TextBox>

                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="btnClose" runat="server" data-dismiss="modal" class="btn btn-default" Text="Cancel"></asp:Button>
                                        <asp:Button ID="btnSubmit" runat="server" class="btn btn-success" Text="Confirm" OnClick="btnSave_Click"></asp:Button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- modal -->


                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:LinkButton data-toggle="modal" class="btn btn-round btn-primary" ID="btnAction" runat="server" Text="Save" href="#myModal"/>
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
