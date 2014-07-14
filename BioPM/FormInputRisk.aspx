<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormInputBatch.aspx.cs" Inherits="BioPM.FormInputBatch" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        //if (!IsPostBack) SetDataToForm();
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected double GetFrequency(string function)
    {
        return Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function));
    }
    
    protected void SetProbability()
    {
        double sum = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencySum());
        double num = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetNumberofFunction());
        
    }
    
    
    
    protected void InsertRiskIntoDatabase()
    {
        string RSKID = (BioPM.ClassObjects.RiskCatalog.GetRiskMatchID() + 1).ToString();        
        //string REGIDstr = ddlBagian.SelectedItem.Text + "-" + ddlActivity.SelectedItem.Text + "-" + txtREGID.Text;
        BioPM.ClassObjects.RiskCatalog.InsertRisk(ddlBagian.SelectedItem.Value, ddlActivity.SelectedItem.Text, RSKID, txtRKEVT.Text, labelAct.Text, ddlRKFNC.SelectedItem.Text, txtSuppDt.Text, txtRiskCause.Text, txtRiskLoc.Text,lbProb.Text, txtRiskImpact.Text, lbRiskStatus.Text, ddlRKMGT.SelectedItem.Text, Session["username"].ToString());
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
    
    protected void ddlActivity_SelectedIndexChanged(object sender, EventArgs e)
    {
        labelAct.Text = ddlActivity.SelectedItem.Text;        
    }

    protected void btnPoisson_Click(object sender, EventArgs e)
    {
       lbProb.Text = (BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoPoissonProbability(txFreq.Text, txRata2.Text)).ToString();    
    }

    protected void btnBinomial_Click(object sender, EventArgs e)
    {
       lbProb.Text = (BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoBinomialProbability(txRskGagal.Text, txFreq.Text ,txFreqKejSkses.Text)).ToString();
    }

    protected void btnNormal_Click(object sender, EventArgs e)
    {
       lbProb.Text = (BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoNormalDistribution(txFreq.Text, txRata2.Text, txSDev.Text)).ToString();   
    }
    
    
    protected void ddlProbability_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlProbability.SelectedIndex == 1)
        {
            txFreq.Visible = true;
            txRata2.Visible = true;
            txRskGagal.Visible = false;
            txFreqKejSkses.Visible = false;
            txSDev.Visible = false;
            btnPoisson.Visible = true;
            btnBinomial.Visible = false;
            btnNormal.Visible = false;
        }
        else if (ddlProbability.SelectedIndex == 2)
        {
            txFreq.Visible = true;
            txRata2.Visible = false;
            txRskGagal.Visible = true;
            txFreqKejSkses.Visible = true;
            txSDev.Visible = false;
            btnPoisson.Visible = false;
            btnBinomial.Visible = true;
            btnNormal.Visible = false;
        }
        else if (ddlProbability.SelectedIndex == 3)
        {   
            txFreq.Visible = true;
            txRata2.Visible = true;
            txRskGagal.Visible = false;
            txFreqKejSkses.Visible = false;
            txSDev.Visible = true;
            btnPoisson.Visible = false;
            btnBinomial.Visible = false;
            btnNormal.Visible = true;
        }    
    }

    protected void txtRiskImpact_TextChanged(object sender, EventArgs e)
    {
        
        lbRiskStatus.Text = (Convert.ToDouble(lbProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();
        
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
    
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>RISK ENTRY</title>

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
                            <label class="col-sm-3 control-label"> NO REGISTRASI </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:DropDownList ID="ddlBagian" style="width:auto; display:inline;" runat="server" class="form-control m-bot15" DataSourceID="sqlRISK_BAGIAN" DataTextField="KDBAG" DataValueField="KDBAG"></asp:DropDownList>
                                <asp:Label runat="server" Text=" - "></asp:Label>
                                <asp:DropDownList ID="ddlActivity" style="width:auto; display:inline;" AutoPostBack="true" runat="server" class="form-control m-bot15" DataSourceID="sqlRISK_ACTIVITY" DataTextField="ACTID" DataValueField="ACTID" OnSelectedIndexChanged="ddlActivity_SelectedIndexChanged"></asp:DropDownList>
                                <!--<asp:Label runat="server" Text=" - "></asp:Label>!-->
                                <!--<asp:TextBox ID="txtREGID" runat="server" style="width:110px; display:inline;" class="form-control m-bot15"></asp:TextBox>!-->
                                <asp:SqlDataSource ID="sqlRISK_BAGIAN" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT [biolegal].[BAGIAN].[KDBAG]
FROM [biolegal].[BAGIAN]"></asp:SqlDataSource>
                                <span class="help-block">Hint : Kode Unit - Kode Aktivitas</></span>
                                <asp:SqlDataSource ID="sqlRISK_ACTIVITY" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT [biolegal].[RISK_ACTIVITY].[ACTID]
FROM [biolegal].[RISK_ACTIVITY]"></asp:SqlDataSource>
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
                                <asp:DropDownList ID="ddlRKFNC" runat="server" class="form-control m-bot15" DataSourceID="sqlRISK_FUNC" DataTextField="FNCNM" DataValueField="FNCNM"></asp:DropDownList>
                                <asp:SqlDataSource ID="sqlRISK_FUNC" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT [biolegal].[RISK_FUNCTION].[FNCNM]
FROM [biolegal].[RISK_FUNCTION]"></asp:SqlDataSource>
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
                            <label class="col-sm-3 control-label"> RISK PROBABILITY </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlProbability" class="form-control m-bot15" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlProbability_SelectedIndexChanged">
                                    <asp:ListItem> Choose Probability</asp:ListItem>
                                    <asp:ListItem>Poisson</asp:ListItem>
                                    <asp:ListItem>Binomial</asp:ListItem>
                                    <asp:ListItem>Normal</asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox ID="txFreq" class="form-control m-bot15" runat="server" placeholder="Frekuensi Kejadian" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txRata2" class="form-control m-bot15" runat="server" placeholder="Rata - rata Kejadian" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txRskGagal" class="form-control m-bot15" runat="server" placeholder="Kemungkinan Risiko Gagal" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txFreqKejSkses" class="form-control m-bot15" runat="server" placeholder="Frrekuensi Kejadian Sukses" Visible="false"></asp:TextBox>
                                <asp:TextBox ID="txSDev" class="form-control m-bot15" runat="server" placeholder="Standard Deviasi" Visible="false"></asp:TextBox>
                            </div>
                            <div class="col-md-4 col-lg-3">
                                <asp:Button ID="btnPoisson" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnPoisson_Click" />
                                <asp:Button ID="btnBinomial" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnBinomial_Click" />
                                <asp:Button ID="btnNormal" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Calculate" OnClick="btnNormal_Click" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> PROBABILITY RESULT </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:Label ID="lbProb" runat="server" AutoPostBack="true" class="form-control m-bot15"></asp:Label>
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
                                <asp:DropDownList ID="ddlRKMGT" runat="server" class="form-control m-bot15" DataSourceID="sqlRISK_MANAGEMENT" DataTextField="MGTNM" DataValueField="MGTNM" ></asp:DropDownList>
                                <asp:SqlDataSource ID="sqlRISK_MANAGEMENT" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT [biolegal].[RISK_MANAGEMENT].[MGTNM]
FROM [biolegal].[RISK_MANAGEMENT]"></asp:SqlDataSource>
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
<% Response.Write(BioPM.ClassScripts.JS.GetFlotChartScript()); %>
</body>
</html>
