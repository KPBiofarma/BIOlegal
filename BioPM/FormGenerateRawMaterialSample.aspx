﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGenerateRawMaterialSample.aspx.cs" Inherits="BioPM.FormGenerateRawMaterialSample" %>

<!DOCTYPE html>
<script runat="server">
    Random rand = new Random();
    string batch, rndid;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack)
        {
            SetBatchInput();
            SetExistingSampleSet();
        }
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected void ddlQCType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            SetBatchInput();
        }
    }
    
    protected void ddlExistingBatch_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            txtSetNumber.Text = "";
            txtBatch.Text = "";
            txtItemName.Text = "";
            txtSampleNumber.Text = "";
            SetNumberOfSet();
        }
    }
    
    protected void SetNumberOfSet()
    {
        txtSetNumber.Text = BioPM.ClassObjects.RawMaterialCatalog.GetAvailableNumberOfSetByID(ddlExistingBatch.SelectedValue).ToString();
        
        if (BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialRandomDateByID(ddlExistingBatch.SelectedValue) != null)
        {
             object[] values = BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialRandomDateByID(ddlExistingBatch.SelectedValue);
             batch = values[0].ToString();
             rndid = values[1].ToString();
             txtBatch.Text = values[3].ToString();
             txtItemName.Text = values[4].ToString();
             txtSampleNumber.Text = (1 + Math.Round(Math.Sqrt(Convert.ToInt16(txtSetNumber.Text)))).ToString();
        }   
    }
    
    protected void SetExistingSampleSet()
    {
        ddlExistingBatch.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialRandomDate())
        {
            ddlExistingBatch.Items.Add(new ListItem(data[0].ToString() + " - " + BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[2].ToString()), data[1].ToString()));
        }
    }


    protected void txtGIN_TextChanged(object sender, EventArgs e)
    {
        if (BioPM.ClassObjects.BatchCatalog.GetRawMaterialByGIN(txtGIN.Text) != null)
        {
            object[] values = BioPM.ClassObjects.BatchCatalog.GetRawMaterialByGIN(txtGIN.Text);
            txtBatch.Text = values[1].ToString();
            txtItemName.Text = values[2].ToString();
            txtSetNumber.Text = values[3].ToString();
            txtSampleNumber.Text = (1 + Math.Round(Math.Sqrt(Convert.ToInt16(txtSetNumber.Text)))).ToString();
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(10, "GIN", "") + "');", true);
            txtGIN.Text = "";
        }
    }
    
    protected void SetBatchInput()
    {
        if (ddlQCType.SelectedValue == "0")
        {
            txtSetNumber.Text = "";
            txtBatch.Text = "";
            txtItemName.Text = "";
            txtGIN.Text = "";
            txtGIN.Visible = true;
            ddlExistingBatch.Visible = false;
        }
        else
        {
            txtSetNumber.Text = "";
            txtBatch.Text = "";
            txtItemName.Text = "";
            txtGIN.Text = "";
            SetNumberOfSet();
            txtGIN.Visible = false;
            ddlExistingBatch.Visible = true;
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
        List<int> numbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
        int numberdivided = 1; 
        int samplenumber = 1;
        int numberofsample = Convert.ToInt16(txtSampleNumber.Text);

        for (int i = 0; i < Convert.ToInt16(txtSetNumber.Text); i++)
        {
            if (i < numberofsample) BioPM.ClassObjects.RawMaterialCatalog.InsertRawMaterialSample(txtGIN.Text, RNDID, QCMID, txtRandomDate.Text, samplenumber.ToString(), numbers[i].ToString(), "1", Session["username"].ToString());
            else BioPM.ClassObjects.RawMaterialCatalog.InsertRawMaterialSample(txtGIN.Text, RNDID, QCMID, txtRandomDate.Text, "0", numbers[i].ToString(), "0", Session["username"].ToString());
            
            if ((i + 1) % numberdivided == 0) samplenumber++;
        }
    }

    protected void InsertExistingRawMaterialIntoDatabase()
    {
        SetNumberOfSet();
        Session["id"] = rndid;
        string QCMID = (BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialMaxMaterialID(rndid) + 1).ToString();
        BioPM.ClassObjects.RawMaterialCatalog.UpdateAvailableDateRawMaterialSample(rndid, QCMID, txtRandomDate.Text);
        List<int> numbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
        int numberdivided = 1;
        int samplenumber = 1;
        int numberofsample = Convert.ToInt16(txtSampleNumber.Text);

        for (int i = 0; i < Convert.ToInt16(txtSampleNumber.Text); i++)
        {
            BioPM.ClassObjects.RawMaterialCatalog.UpdateRawMaterialSample(rndid, samplenumber.ToString(), numbers[i].ToString());

            if ((i + 1) % numberdivided == 0) samplenumber++;
        }
    }
    
    protected void RunRandomToGetRawMaterialSample()
    {
        if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtRandomDate.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "RANDOM DATE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtGIN.Text) && ddlQCType.SelectedValue == "0")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "BATCH", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(ddlExistingBatch.Text) && ddlQCType.SelectedValue == "1")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "BATCH", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSetNumber.Text) && ddlQCType.SelectedValue == "0")
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
        else if (ddlQCType.SelectedValue == "0")
        {
            if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSetNumber.Text)))
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
                Response.Redirect("PageSampleRawMaterialRandom.aspx");
            }            
            
        }
        else if (ddlQCType.SelectedValue == "1")
        {
            if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSampleNumber.Text)))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF SAMPLE", "") + "');", true);
            }
            else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtSampleNumber.Text)))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "NUMBER OF SAMPLE", "") + "');", true);
            }
            else if (!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(Convert.ToInt16(txtSampleNumber.Text), Convert.ToInt16(txtSetNumber.Text)))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "NUMBER OF SET", "NUMBER OF SAMPLE") + "');", true);
            } 
            else
            {
                GenerateRandomExistingNumber(BioPM.ClassObjects.RawMaterialCatalog.GetAvailableSetNumberByID(ddlExistingBatch.SelectedValue));
                InsertExistingRawMaterialIntoDatabase();
                Response.Redirect("PageSampleRawMaterialRandom.aspx");
            }
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

    <title>Raw Material Sample</title>

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
                        RAW MATERIAL RANDOM SAMPLE ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> QC TYPE </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlQCType" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlQCType_SelectedIndexChanged" class="form-control m-bot15">   
                                <asp:ListItem Value="0"> New Data </asp:ListItem>
                                <asp:ListItem Value="1"> Existing Data </asp:ListItem>
                                </asp:DropDownList> 
                            </div>
                        </div>

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
                                <asp:TextBox ID="txtGIN" runat="server"  AutoPostBack="true" OnTextChanged ="txtGIN_TextChanged" class="form-control m-bot15" Visible="false" placeholder="NEW GIN" ></asp:TextBox>
                                <asp:DropDownList ID="ddlExistingBatch" AutoPostBack="true" OnSelectedIndexChanged="ddlExistingBatch_SelectedIndexChanged" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList>
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
                            <label class="col-sm-3 control-label"> NUMBER OF SET </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtSetNumber" runat="server" class="form-control m-bot15" ></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumber" runat="server" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" ></asp:TextBox>
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

