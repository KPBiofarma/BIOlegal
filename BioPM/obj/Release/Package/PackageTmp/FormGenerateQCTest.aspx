<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGenerateQCTest.aspx.cs" Inherits="BioPM.FormGenerateQCTest" %>

<!DOCTYPE html>
<script runat="server">
    Random rand = new Random();
    protected void Page_Load(object sender, EventArgs e)
    {
        //sessionCreator();
        if (!IsPostBack) GetAnimalMouseType();
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected bool ValidateNumber()
    {
        int sample = Convert.ToInt16(txtSampleNumber.Text);
        int set = Convert.ToInt16(txtSetNumber.Text);
        if (sample % set != 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    
    protected bool ValidateComparison()
    {
        int sample = Convert.ToInt16(txtSampleNumber.Text);
        int set = Convert.ToInt16(txtSetNumber.Text);
        if (set >= sample)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    protected bool ValidateDilutionNumber()
    {
        return true;
    }
    
    protected void GenerateRandomNumber(int totalsample)
    {
        //BioPM.ClassObjects.AnimalCatalog.DeleteNumberTest();
        //for (int i = 1; i <= totalsample; i++)
        //{
        //    BioPM.ClassObjects.AnimalCatalog.InsertNumberTest(i, rand.Next(1, totalsample));
        //}
    }
    
    protected void GetAnimalMouseType()
    {
        //ddlSampleType.Items.Clear();
        //foreach (object[] data in BioPM.ClassObjects.AnimalCatalog.GetAnimalMouseType())
        //{
        //    ddlSampleType.Items.Add(new ListItem(data[1].ToString(), data[0].ToString()));
        //}
    }
    
    protected void RunRandomizationByType()
    {
        if (ddlRandomType.SelectedValue == "0") RunRandomToGetAnimalSample();
        else RunRandomToGetDilutionSample(ddlRandomType.SelectedValue);
    }
    
    protected void InsertAnimalTestIntoDatabase()
    {
        //List<int> numbers = new List<int>(BioPM.ClassObjects.AnimalCatalog.GetNumberTest());
        //int numberdivided = Convert.ToInt16(txtSampleNumber.Text) / Convert.ToInt16(txtSetNumber.Text);
        //int cagenumber = 1;

        //for (int i = 0; i < Convert.ToInt16(txtSampleNumber.Text); i++)
        //{
        //    BioPM.ClassObjects.AnimalCatalog.InsertAnimalTest(txtBatch.Text, txtRandomDate.Text, ddlSampleType.SelectedValue, numbers[i].ToString(), cagenumber.ToString(), Session["username"].ToString());
        //    if ((i + 1) % numberdivided == 0) cagenumber++;
        //}
    }

    protected void InsertSampleTestIntoDatabase()
    {
        //List<int> numbers = new List<int>(BioPM.ClassObjects.AnimalCatalog.GetNumberTest());
        
        //for (int i = 0; i < Convert.ToInt16(txtSampleNumber.Text); i++)
        //{
        //    BioPM.ClassObjects.AnimalCatalog.InsertAnimalTest(txtBatch.Text, txtRandomDate.Text, ddlSampleType.SelectedValue, numbers[i].ToString(), "", Session["username"].ToString());
        //}
    }

    protected void InsertDilutionTestIntoDatabase(string qctype)
    {
        //string QCTID = (BioPM.ClassObjects.QualityControlCatalog.GetQCDilutionMaxID() + 1).ToString();
        //List<int> numbers = new List<int>(BioPM.ClassObjects.AnimalCatalog.GetNumberTest());
        //int numberdivided = Convert.ToInt16(txtSetNumber.Text) / Convert.ToInt16(txtSampleNumber.Text);
        //int samplenumber = 1;
        
        //for (int i = 0; i < Convert.ToInt16(txtSetNumber.Text); i++)
        //{
        //    BioPM.ClassObjects.QualityControlCatalog.InsertQCDilutionTest(txtBatch.Text, txtRandomDate.Text, QCTID, qctype, ddlSampleType.SelectedValue, "", numbers[i].ToString(), samplenumber.ToString(), Session["username"].ToString());
        //    if ((i + 1) % numberdivided == 0) samplenumber++;
        //}
    }
    
    protected void RunRandomToGetAnimalSample()
    {
        if (ValidateNumber())
        {
            GenerateRandomNumber(Convert.ToInt16(txtSampleNumber.Text));
            InsertAnimalTestIntoDatabase();
            Response.Redirect("PageSampleAnimalTest.aspx?batch=" + txtBatch.Text);
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "HASIL MOD TIDAK SAMA DENGAN 0" + "');", true);
        }
    }

    protected void RunRandomToGetSampleFromSet()
    {
        if (ValidateComparison())
        {
            GenerateRandomNumber(Convert.ToInt16(txtSetNumber.Text));
            InsertSampleTestIntoDatabase();
            Response.Redirect("PageSampleTest.aspx?batch=" + txtBatch.Text);
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "JUMLAH SET KURANG DARI DATA SAMPLE" + "');", true);
        }
    }

    protected void RunRandomToGetDilutionSample(string qctype)
    {
        if (ValidateComparison())
        {
            GenerateRandomNumber(Convert.ToInt16(txtSetNumber.Text));
            InsertDilutionTestIntoDatabase(qctype);
            Response.Redirect("PageSampleTest.aspx?batch=" + txtBatch.Text);
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "JUMLAH CAGE KURANG DARI DATA SAMPLE" + "');", true);
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        RunRandomizationByType();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>SAMPLE TEST</title>

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
                        SAMPLE TEST ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                         
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> BATCH </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtBatch" runat="server" class="form-control m-bot15" placeholder="BATCH NUMBER" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3">RANDOM DATE</label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtRandomDate" value="" size="16" class="form-control form-control-inline input-medium default-date-picker" runat="server"></asp:TextBox>
                                <span class="help-block">Test Date Format : month-day-year e.g. 01-31-2014</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> RANDOM TYPE </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlRandomType" AutoPostBack="true" runat="server" class="form-control m-bot15">
                                <asp:ListItem Value="0"> Animal Over Cage</asp:ListItem>
                                <asp:ListItem Value="1"> MWGT </asp:ListItem>
                                <asp:ListItem Value="13"> Diphtheria Potency </asp:ListItem>
                                <asp:ListItem Value="14"> Tetatus Potency </asp:ListItem>
                                <asp:ListItem Value="15"> Pertussis Potency </asp:ListItem>
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ITEM NAME </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlSampleType" AutoPostBack="true" runat="server" class="form-control m-bot15">   
                                
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SET </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSetNumber" runat="server" class="form-control m-bot15" placeholder="NUMBER OF CAGE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumber" runat="server" class="form-control m-bot15" placeholder="NUMBER OF ANIMAL/DILUTION" ></asp:TextBox>
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
