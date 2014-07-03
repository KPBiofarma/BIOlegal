<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGenerateMultiAnimalRandomHepatitisB.aspx.cs" Inherits="BioPM.FormGenerateMultiAnimalRandomHepatitisB" %>

<!DOCTYPE html>
<script runat="server">
    string message = "";
    Random rand = new Random();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        Session["gentype"] = "X";
        if (!IsPostBack) 
        {
            GetAnimalMouseType();
        }
    }

    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }
    
    protected void GenerateRandomNumber(int initial, int totalsample)
    {
        BioPM.ClassObjects.RandomNumberCatalog.DeleteRandomNumber();
        for (int i = initial; i < initial + totalsample; i++)
        {
            BioPM.ClassObjects.RandomNumberCatalog.InsertRandomNumber(i, rand.Next(1, totalsample*2));
        }
    }
    
    protected void GetAnimalMouseType()
    {
        ddlSampleType.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAnimalMouseType())
        {
            ddlSampleType.Items.Add(new ListItem(data[1].ToString(), data[0].ToString()));
        }
    }
    
    protected void InsertAnimalRandomIntoDatabase()
    {
        string RNDID = (BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalRandomMaxID() + 1).ToString();
        Session["id"] = RNDID;

        int NumberOfMale = Convert.ToInt16(txtSampleNumberMale.Text);
        int NumberOfFemale = Convert.ToInt16(txtSampleNumberFemale.Text);
        int numberdivided = Convert.ToInt16(txtSamplePerCage.Text);
        int cagenumber = 1;
        
        
        GenerateRandomNumber(1, NumberOfMale);
        List<int> numbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
        for (int i = 0; i < Convert.ToInt16(txtSampleNumberMale.Text); i++)
        {
            BioPM.ClassObjects.AnimalRandomCatalog.InsertAnimalRandom(RNDID, txtRandomDate.Text, ddlSampleType.SelectedValue, "16", "M", cagenumber.ToString(), numbers[i].ToString(), Session["username"].ToString());
            if ((i + 1) % numberdivided == 0) cagenumber++;
        }

        GenerateRandomNumber(NumberOfMale+1, NumberOfFemale);
        numbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
        for (int i = 0; i < Convert.ToInt16(txtSampleNumberFemale.Text); i++)
        {
            BioPM.ClassObjects.AnimalRandomCatalog.InsertAnimalRandom(RNDID, txtRandomDate.Text, ddlSampleType.SelectedValue, "16", "F", cagenumber.ToString(), numbers[i].ToString(), Session["username"].ToString());
            if ((i + 1) % numberdivided == 0) cagenumber++;
        }
    }
    
    protected void RunRandomToGetAnimalSample()
    {
        if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtRandomDate.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "RANDOM DATE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSamplePerCage.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSampleNumberMale.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(12, "NUMBER OF MALE ANIMAL", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSampleNumberFemale.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(12, "NUMBER OF FEMALE ANIMAL", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSamplePerCage.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSampleNumberMale.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF MALE ANIMAL", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSampleNumberFemale.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF FEMALE ANIMAL", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSamplePerCage.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSampleNumberMale.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF MALE ANIMAL", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSampleNumberFemale.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF FEMALE ANIMAL", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtSamplePerCage.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(Convert.ToInt16(txtSamplePerCage.Text), Convert.ToInt16(txtSampleNumberMale.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "ANIMAL PER CAGE", "NUMBER OF MALE ANIMAL") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(Convert.ToInt16(txtSamplePerCage.Text), Convert.ToInt16(txtSampleNumberFemale.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "ANIMAL PER CAGE", "NUMBER OF FEMALE ANIMAL") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateModResult(Convert.ToInt16(txtSampleNumberMale.Text), Convert.ToInt16(txtSamplePerCage.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(2, "NUMBER OF ANIMAL", "ANIMAL PER CAGE") + "');", true);
        }
        else
        {
            InsertAnimalRandomIntoDatabase();
            Response.Redirect("PageSampleMultiAnimalRandom.aspx");
        }
    }
    
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        RunRandomToGetAnimalSample();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>Animal Random</title>

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
                        ANIMAL RANDOM ENTRY FORM
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
                            <label class="col-sm-3 control-label"> ANIMAL NAME </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlSampleType" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF ANIMAL (MALE) </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumberMale" runat="server" class="form-control m-bot15" placeholder="NUMBER OF ANIMAL" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF ANIMAL (FEMALE) </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumberFemale" runat="server" class="form-control m-bot15" placeholder="NUMBER OF ANIMAL" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ANIMAL PER CAGE </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSamplePerCage" runat="server" class="form-control m-bot15" placeholder="ANIMAL PER CAGE" ></asp:TextBox>
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

