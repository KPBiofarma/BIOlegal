<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormUpdateRisk.aspx.cs" Inherits="BioPM.FormUpdateRisk" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack)
        {
        //    SetExistingOrganization();
            SetDataToForm();
        }
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
        object[] values = BioPM.ClassObjects.RiskCatalog.GetRiskByID(Request.QueryString["key"]);
        txtRegId.Text = values[0].ToString();
        txtRiskEvent.Text = values[1].ToString();
        ddlRiskAct.SelectedValue = values[2].ToString();
        ddlRiskFunc.SelectedValue = values[3].ToString();
        txtSuppDt.Text = values[4].ToString();
        txtRiskCause.Text = values[5].ToString();
        txtRiskLoc.Text = values[6].ToString();
        lbProb.Text = values[7].ToString();
        txtRiskImpact.Text = values[8].ToString();
        lbRiskStatus.Text = values[9].ToString();
        ddlRKMGT.SelectedValue = values[10].ToString();
        txFreq.Text = values[11].ToString();   
    }
    
    //protected void SetExistingOrganization()
    //{
    //    //ddlOrgParent.Items.Clear();
    //    //ddlOrgChild.Items.Clear();
    //    foreach(object[] data in BioPM.ClassObjects.OrganizationCatalog.GetOrganizations())
    //    {
    //        //ddlOrgParent.Items.Add(new ListItem(data[2].ToString() + " - " + data[1].ToString() == "1" ? "unit" : "Position", data[0].ToString() + "|" + data[1].ToString() ));
    //        //ddlOrgChild.Items.Add(new ListItem(data[2].ToString() + " - " + data[1].ToString() == "1" ? "unit" : "Position", data[0].ToString() + "|" + data[1].ToString()));
    //    }
    //}

    protected void InsertRiskIntoDatabase()
    {
        BioPM.ClassObjects.RiskCatalog.UpdateRisk(txtRegId.Text, txtRiskEvent.Text, ddlRiskAct.SelectedItem.Text, ddlRiskFunc.SelectedItem.Text, txtSuppDt.Text, txtRiskCause.Text, txtRiskLoc.Text, lbProb.Text, txtRiskImpact.Text, lbRiskStatus.Text, ddlRKMGT.SelectedItem.Text, txFreq.Text, Session["username"].ToString());
    }
      
    //protected void ddlActivity_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    labelAct.Text = ddlActivity.SelectedItem.Text;
    //}

    protected void btnPoisson_Click(object sender, EventArgs e)
    {
        lbProb.Text = (BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoPoissonProbability(txFreq.Text, txRata2.Text)).ToString();
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
        lbProb.Text = (BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoBinomialProbability(txRskGagal.Text, txFreq.Text, txFreqKejSkses.Text)).ToString();
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
        lbProb.Text = (BioPM.ClassEngines.ProbabilityAndStatisticFactory.DoNormalDistribution(txFreq.Text, txRata2.Text, txSDev.Text)).ToString();
        txFreq.Visible = false;
        txRata2.Visible = false;
        txRskGagal.Visible = false;
        txFreqKejSkses.Visible = false;
        txSDev.Visible = false;
        btnChangeProb.Visible = true;
        btnNormal.Visible = false;
        ddlProbability.Visible = false;
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
    
    protected void btnChangeProb_Click(object sender, EventArgs e)
    {
        ddlProbability.Visible = true;
        btnChangeProb.Visible = false;
    }

    protected void txtRiskImpact_TextChanged(object sender, EventArgs e)
    {

        lbRiskStatus.Text = (Convert.ToDouble(lbProb.Text) * Convert.ToDouble(txtRiskImpact.Text)).ToString();

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
                                <asp:TextBox ID="txtRegId" runat="server" class="form-control m-bot15" placeholder="REGISTRATION ID" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
    
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK EVENT </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtRiskEvent" runat="server" class="form-control m-bot15" placeholder="RISK EVENT" ></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK ACTIVITY </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlRiskAct" style="width:auto; display:inline;" AutoPostBack="true" runat="server" class="form-control m-bot15" DataSourceID="sqlRISK_ACTIVITY" DataTextField="KDACT" DataValueField="KDACT" ReadOnly="true" ></asp:DropDownList>
                                <asp:SqlDataSource ID="sqlRISK_ACTIVITY" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT [biolegal].[RISK_ACTIVITY].[KDACT]
FROM [biolegal].[RISK_ACTIVITY]"></asp:SqlDataSource>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RISK FUNCTION </label>
                            <div class="col-md-4 col-lg-3">
                                <asp:DropDownList ID="ddlRiskFunc" runat="server" class="form-control m-bot15" DataSourceID="sqlRISK_FUNC" DataTextField="NMFNC" DataValueField="NMFNC"></asp:DropDownList>
                                <asp:SqlDataSource ID="sqlRISK_FUNC" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT [biolegal].[RISK_FUNCTION].[NMFNC]
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
                                <asp:Label ID="lbProb" runat="server" AutoPostBack="true" class="form-control m-bot15"></asp:Label>
                                <asp:DropDownList ID="ddlProbability" class="form-control m-bot15" AutoPostBack="true" Visible="false" runat="server" OnSelectedIndexChanged="ddlProbability_SelectedIndexChanged">
                                    <asp:ListItem> </asp:ListItem>
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
                                <asp:Button ID="btnChangeProb" runat="server" class="btn btn-round btn-primary" Text="Change" OnClick="btnChangeProb_Click"/>
                                <asp:Button ID="btnPoisson" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Count" OnClick="btnPoisson_Click" />
                                <asp:Button ID="btnBinomial" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Count" OnClick="btnBinomial_Click" />
                                <asp:Button ID="btnNormal" runat="server" class="btn btn-round btn-primary" Visible="false" Text="Count" OnClick="btnNormal_Click" />
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
                                <asp:DropDownList ID="ddlRKMGT" runat="server" class="form-control m-bot15" DataSourceID="sqlRISK_MANAGEMENT" DataTextField="NMMGT" DataValueField="NMMGT" ></asp:DropDownList>
                                <asp:SqlDataSource ID="sqlRISK_MANAGEMENT" runat="server" ConnectionString="<%$ ConnectionStrings:DefaultConnection %>" SelectCommand="SELECT [biolegal].[RISK_MANAGEMENT].[NMMGT]
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
