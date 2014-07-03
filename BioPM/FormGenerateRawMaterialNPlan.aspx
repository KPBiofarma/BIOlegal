<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGenerateRawMaterialNPlan.aspx.cs" Inherits="BioPM.FormGenerateRawMaterialNPlan" %>

<!DOCTYPE html>
<script runat="server">
    Random rand = new Random();
    string batch, rndid;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        
        if (!IsPostBack)
        {
            
        }
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected void txtGIN_TextChanged(object sender, EventArgs e)
    {
        if (BioPM.ClassObjects.BatchCatalog.GetRawMaterialByGIN(txtGIN.Text) != null)
        {
            object[] values = BioPM.ClassObjects.BatchCatalog.GetRawMaterialByGIN(txtGIN.Text);
            txtBatch.Text = values[1].ToString();
            txtItemName.Text = values[2].ToString();
            txtSetNumber.Text = values[3].ToString();
            txtSetNumberEach.Text = values[4].ToString();
            txtSampleNumber.Text = (1 + Math.Round(Math.Sqrt(Convert.ToInt16(txtSetNumber.Text)))).ToString();
            txtSampleNumberPieces.Text = (1 + Math.Round(Math.Sqrt(Convert.ToInt16(txtSetNumber.Text) * Convert.ToInt16(txtSetNumberEach.Text)))).ToString();
            txtSamplePerPacks.Text = Math.Round(Convert.ToDecimal(txtSampleNumberPieces.Text) / Convert.ToDecimal(txtSampleNumber.Text)).ToString("F0");
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(10, "GIN", "") + "');", true);
            txtGIN.Text = "";
        }
    }
    
    protected void GenerateRandomExistingNumber(List<int> setnumber)
    {
        BioPM.ClassObjects.RandomNumberCatalog.DeleteRandomNumber();
        for (int i = 0; i < setnumber.Count; i++)
        {
            BioPM.ClassObjects.RandomNumberCatalog.InsertRandomNumber(setnumber[i], rand.Next(1, setnumber.Count));
        }
    }

    protected void GenerateRandomNumber(int totalsample)
    {
        BioPM.ClassObjects.RandomNumberCatalog.DeleteRandomNumber();
        for (int i = 1; i <= totalsample; i++)
        {
            BioPM.ClassObjects.RandomNumberCatalog.InsertRandomNumber(i, rand.Next(1, totalsample));
        }
    }
    
    protected void InsertRawMaterialIntoDatabase()
    {
        string RNDID = (BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialMaxRandomID() + 1).ToString();
        string QCMID = (BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialMaxMaterialID(RNDID) + 1).ToString();
        Session["id"] = RNDID;
        List<int> packnumbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
        int numberdivided = 1; 
        int samplenumber = 1;
        int numberofsample = Convert.ToInt16(txtSampleNumber.Text);
        int totalsample = Convert.ToInt16(txtSampleNumber.Text) * Convert.ToInt16(txtSamplePerPacks.Text);

        for (int i = 0; i < Convert.ToInt16(txtSetNumber.Text); i++)
        {
            
            if (i < numberofsample)
            {
                GenerateRandomNumber(Convert.ToInt16(txtSetNumberEach.Text));
                List<int> piecenumbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());

                for (int x = 0; x < Convert.ToInt16(txtSamplePerPacks.Text); x++)
                {
                    BioPM.ClassObjects.RawMaterialCatalog.InsertRawMaterialNPlanSample(txtGIN.Text, RNDID, QCMID, txtRandomDate.Text, samplenumber.ToString(), packnumbers[i].ToString(), piecenumbers[x].ToString(), "1", Session["username"].ToString());
                    if ((i + 1) % numberdivided == 0) samplenumber++;
                }
            }
            else BioPM.ClassObjects.RawMaterialCatalog.InsertRawMaterialSample(txtGIN.Text, RNDID, QCMID, txtRandomDate.Text, "0", packnumbers[i].ToString(), "0", Session["username"].ToString());
        }
    }

    protected void RunRandomToGetRawMaterialSample()
    {
        if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtRandomDate.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "RANDOM DATE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtGIN.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "BATCH", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSetNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "NUMBER OF SET", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSetNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF SET", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSampleNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSetNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF SET", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSampleNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtSetNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "NUMBER OF SET", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtSampleNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if ((!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(Convert.ToInt16(txtSampleNumber.Text), Convert.ToInt16(txtSetNumber.Text))))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "NUMBER OF SET", "NUMBER OF SAMPLE") + "');", true);
        }
        else
        {
            GenerateRandomNumber(Convert.ToInt16(txtSetNumber.Text));
            InsertRawMaterialIntoDatabase();
            Response.Redirect("PageSampleRawMaterialNPlanRandom.aspx");
        }
    }
    
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        RunRandomToGetRawMaterialSample();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>Raw Material n-Plan Sample</title>

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
                        RAW MATERIAL N-PLAN RANDOM SAMPLE ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="control-label col-md-3">RANDOM DATE</label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtRandomDate" value="" size="16" class="form-control form-control-inline input-medium default-date-picker" runat="server"></asp:TextBox>
                                <span class="help-block">Random Date Format : month-day-year e.g. 01-31-2014</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">  GIN </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtGIN" runat="server"  AutoPostBack="true" OnTextChanged ="txtGIN_TextChanged" class="form-control m-bot15" Visible="true" placeholder="NEW GIN" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> BATCH </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtBatch" runat="server" class="form-control m-bot15" ></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ITEM NAME </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtItemName" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SET (PACKS)</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtSetNumber" runat="server" class="form-control m-bot15" ></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SET (PIECES)</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtSetNumberEach" runat="server" class="form-control m-bot15" ></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE (PACKS)</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumber" runat="server" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE (PIECES)</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumberPieces" runat="server" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE (PIECES PER PACKS)</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSamplePerPacks" runat="server" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnAdd" runat="server" Text="Run" OnClick="btnAdd_Click"/>
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


