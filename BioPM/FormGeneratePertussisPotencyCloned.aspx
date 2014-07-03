<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGeneratePertussisPotencyCloned.aspx.cs" Inherits="BioPM.FormGeneratePertussisPotencyCloned" %>

<!DOCTYPE html>
<script runat="server">
    Random rand = new Random();
    string message = "";
    string prdid = "";
    private const int _firstEditCellIndexBatch = 2;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        
        if (!IsPostBack)
        {
            GetRandomAnimalDate();
            SetAnimalRandomValueToForm();
            
            _batchData = null;
            this.GridViewBatch.DataSource = _batchData;
            this.GridViewBatch.DataBind();
            
        }

        if (this.GridViewBatch.SelectedIndex > -1)
        {
            
            this.GridViewBatch.UpdateRow(this.GridViewBatch.SelectedIndex, false);
        }
    }

    #region GridViewBatch
    protected void GridViewBatch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (txtSampleNumber.Text != "")
            {
                UpdateTotalDilution();
            }
            
            DropDownList ddlBatch = (e.Row.FindControl("AssignedTo") as DropDownList);
            
            foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAllBatchByCostCenter(Session["coctr"].ToString()))
            {
                ddlBatch.Items.Add(new ListItem(data[0].ToString(), data[0].ToString()));
            }
            
            LinkButton _singleClickButton = (LinkButton)e.Row.Cells[0].Controls[0];
            
            string _jsSingle = ClientScript.GetPostBackClientHyperlink(_singleClickButton, "");

            
            
            if (Page.Validators.Count > 0)
                _jsSingle = _jsSingle.Insert(11, "if(Page_ClientValidate())");

            
            for (int columnIndex = _firstEditCellIndexBatch; columnIndex < e.Row.Cells.Count; columnIndex++)
            {
                
                string js = _jsSingle.Insert(_jsSingle.Length - 2, columnIndex.ToString());
                
                e.Row.Cells[columnIndex].Attributes["onclick"] = js;
                
                e.Row.Cells[columnIndex].Attributes["style"] += "cursor:pointer;cursor:hand;";
            }
        }
    }

    protected void GridViewBatch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        switch (e.CommandName)
        {
            case ("SingleClick"):
                
                int _rowIndex = int.Parse(e.CommandArgument.ToString());
                
                int _columnIndex = int.Parse(Request.Form["__EVENTARGUMENT"]);
                
                _gridView.SelectedIndex = _rowIndex;
                
                _gridView.DataSource = _batchData;
                _gridView.DataBind();

                
                
                

                
                Control _displayControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[1];
                _displayControl.Visible = false;
                
                Control _editControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[3];
                _editControl.Visible = true;
                
                _gridView.Rows[_rowIndex].Cells[_columnIndex].Attributes.Clear();
                
                
                ScriptManager.RegisterStartupScript(this, GetType(), "SetFocus", "document.getElementById('" + _editControl.ClientID + "').focus();", true);
                
                
                if (_editControl is DropDownList && _displayControl is Label)
                {
                    ((DropDownList)_editControl).SelectedValue = ((Label)_displayControl).Text;
                }
                
                if (_editControl is TextBox)
                {
                    ((TextBox)_editControl).Attributes.Add("onfocus", "this.select()");
                }
                
                
                if (_editControl is CheckBox && _displayControl is Label)
                {
                    ((CheckBox)_editControl).Checked = bool.Parse(((Label)_displayControl).Text);
                }

                break;
        }
    }

    
    
    
    
    
    protected void GridViewBatch_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        if (e.RowIndex > -1)
        {
            
            for (int i = _firstEditCellIndexBatch; i < _gridView.Columns.Count; i++)
            {
                
                Control _editControl = _gridView.Rows[e.RowIndex].Cells[i].Controls[3];
                if (_editControl.Visible)
                {
                    int _dataTableColumnIndex = i - 1;

                    try
                    {
                        
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("SMPNOLabel");
                        string id = idLabel.Text;
                        
                        System.Data.DataTable dt = _batchData;
                        System.Data.DataRow dr = dt.Rows.Find(id);
                        dr.BeginEdit();
                        if (_editControl is TextBox)
                        {
                            dr[_dataTableColumnIndex] = ((TextBox)_editControl).Text;
                        }
                        else if (_editControl is DropDownList)
                        {
                            dr[_dataTableColumnIndex] = ((DropDownList)_editControl).SelectedValue;
                        }
                        else if (_editControl is CheckBox)
                        {
                            dr[_dataTableColumnIndex] = ((CheckBox)_editControl).Checked;
                        }
                        dr.EndEdit();

                        
                        _batchData = dt;

                        
                        
                        _gridView.SelectedIndex = -1;

                        
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        
                        

                        
                        _gridView.DataSource = _batchData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    
    
    
    private System.Data.DataTable _batchData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["BatchData"];

            if (dt == null)
            {
                
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("SMPNO", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("BATCH", typeof(string)));

                
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["SMPNO"];
                dt.PrimaryKey = keys;

                _batchData = dt;
            }

            return dt;
        }
        set
        {
            Session["BatchData"] = value;
        }
    }

    protected void txtSampleNumber_TextChanged(object sender, EventArgs e)
    {
        _batchData = null;
        for (int i = 1; i <= Convert.ToInt16(txtSampleNumber.Text); i++)
        {
            System.Data.DataTable dt = _batchData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { i.ToString(), "" });
            _batchData = dt;

            
            this.GridViewBatch.DataSource = _batchData;
            this.GridViewBatch.DataBind();
        }
    }
    
    #endregion


    protected override void Render(HtmlTextWriter writer)
    {
        
        foreach (GridViewRow r in GridViewBatch.Rows)
        {
            if (r.RowType == DataControlRowType.DataRow)
            {
                for (int columnIndex = _firstEditCellIndexBatch; columnIndex < r.Cells.Count; columnIndex++)
                {
                    Page.ClientScript.RegisterForEventValidation(r.UniqueID + "$ctl00", columnIndex.ToString());
                }
            }
        }
        base.Render(writer);
    }

    
    
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
        Session["coctr"] = "52100";
    }

    protected void GenerateRandomNumber(List<int> setnumber)
    {
        BioPM.ClassObjects.QualityControlCatalog.DeleteNumberTest();
        for (int i = 0; i < setnumber.Count; i++)
        {
            BioPM.ClassObjects.QualityControlCatalog.InsertNumberTest(setnumber[i], rand.Next(1, 100));
        }
    }

    protected string GetAnimalSex(string ID)
    {
        List<object> values = BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalGenderByID(ID);
        if (values.Count > 1) return "Both";
        else if (values.Count > 0 && values[0].ToString() == "F") return "Female";
        else if (values.Count > 0 && values[0].ToString() == "M") return "Male";
        else return "Both";
    }

    protected void GetRandomAnimalDate()
    {
        ddlRandomDate.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAnimalRandomDateByType("15"))
        {
            ddlRandomDate.Items.Add(new ListItem(BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[1].ToString()) + " - " + data[2].ToString() + " (ID" + data[0].ToString() + " - " + GetAnimalSex(data[0].ToString()) + ")", data[0].ToString()));
        }
    }

    protected void SetAnimalRandomValueToForm()
    {
        if (ddlRandomDate.SelectedValue != "")
        {
            object[] values = BioPM.ClassObjects.QualityControlCatalog.GetCageAndAnimalNumberByID(ddlRandomDate.SelectedValue);
            txtAnimalNumber.Text = values[1].ToString();
            txtAnimalPerCage.Text = values[0].ToString() == "0" ? "0" : (Convert.ToInt16(values[1].ToString()) / Convert.ToInt16(values[0].ToString())).ToString();
        }
    }

    protected void ddlRandomDate_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            SetAnimalRandomValueToForm();
        }
    }
    
    protected void InsertDilutionTestIntoDatabase()
    {
        UpdateTotalDilution();
        int sample = Convert.ToInt16(txtSampleNumber.Text);
        int dilution = Convert.ToInt16(txtDilutionNumber.Text);
        int animalperdilution = Convert.ToInt16(txtAnimalPerDilution.Text);
        int animalpercage = Convert.ToInt16(txtAnimalPerCage.Text);
        int animalnumber = Convert.ToInt16(txtAnimalNumber.Text);
        string itemid = (BioPM.ClassObjects.QualityControlCatalog.GetAnimalTestByID(ddlRandomDate.SelectedValue)[0])[5].ToString();

        string QCTID = (BioPM.ClassObjects.QualityControlCatalog.GetQCDilutionMaxID() + 1).ToString();
        Session["id"] = QCTID;

        GenerateRandomNumber(BioPM.ClassObjects.QualityControlCatalog.GetCageNumberMaleAnimalByID(ddlRandomDate.SelectedValue));
        List<int> malecagenumbers = new List<int>(BioPM.ClassObjects.QualityControlCatalog.GetNumberTest());
        
        GenerateRandomNumber(BioPM.ClassObjects.QualityControlCatalog.GetCageNumberFemaleAnimalByID(ddlRandomDate.SelectedValue));
        List<int> femalecagenumbers = new List<int>(BioPM.ClassObjects.QualityControlCatalog.GetNumberTest());
        
        int dilutionnumberdivided = ((dilution * animalperdilution) / animalpercage) / Convert.ToInt16(txtDilutionNumber.Text);
        int samplenumberdivided = (animalperdilution / animalpercage) * (dilution / sample);
        int dilutionnumber = 1, samplenumber = 1;
        int index = 0;
        
        while (index < ((dilution * animalperdilution) / animalpercage))
        {
            if (malecagenumbers.Count > 0)
            {
                BioPM.ClassObjects.QualityControlCatalog.InsertQCDilutionTest(txtRandomDate.Text, ddlRandomDate.SelectedValue, QCTID, "15", itemid, malecagenumbers[0].ToString(), dilutionnumber.ToString(), samplenumber.ToString(), Session["username"].ToString());
                malecagenumbers.RemoveAt(0);
                if ((index + 1) % dilutionnumberdivided == 0) dilutionnumber++;
                if ((index + 1) % samplenumberdivided == 0) samplenumber++;
                index++;
            }
            if (femalecagenumbers.Count > 0)
            {
                BioPM.ClassObjects.QualityControlCatalog.InsertQCDilutionTest(txtRandomDate.Text, ddlRandomDate.SelectedValue, QCTID, "15", itemid, femalecagenumbers[0].ToString(), dilutionnumber.ToString(), samplenumber.ToString(), Session["username"].ToString());
                femalecagenumbers.RemoveAt(0);
                if ((index + 1) % dilutionnumberdivided == 0) dilutionnumber++;
                if ((index + 1) % samplenumberdivided == 0) samplenumber++;
                index++;
            }
        }
    }

    protected void UpdateDilutionDataIntoDatabase()
    {
        int sample = Convert.ToInt16(txtSampleNumber.Text);
        int dilution = Convert.ToInt16(txtDilutionNumber.Text);
        int samplenumberdivided = dilution / sample;
        int dilutionnumber = 1;
        int samplerow = 0;
        for (int i = 0; i < _batchData.Rows.Count; i++)
        {
            foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetConcentrationByBATCH(_batchData.Rows[samplerow]["BATCH"].ToString()))
            {
                BioPM.ClassObjects.QualityControlCatalog.UpdateQCDilutionTest(Session["id"].ToString(), _batchData.Rows[samplerow]["SMPNO"].ToString(), dilutionnumber.ToString(), _batchData.Rows[samplerow]["BATCH"].ToString(), data[0].ToString());
                dilutionnumber++;
            }
            samplerow++;
        }
    }

    protected void AssignedTo_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            int sample = Convert.ToInt16(txtSampleNumber.Text);
            int dilution = Convert.ToInt16(txtDilutionNumber.Text);
            int samplenumberdivided = dilution / sample;
            int dilutionnumber = 0;
            int samplerow = 0;
            
            for (int i = 0; i < _batchData.Rows.Count; i++)
            {
                dilutionnumber +=  BioPM.ClassObjects.QualityControlCatalog.GetConcentrationByBATCH(_batchData.Rows[samplerow]["BATCH"].ToString()).Count;
            }
            
            txtDilutionNumber.Text = dilutionnumber.ToString();
        }
    }

    protected void UpdateTotalDilution()
    {
        if (IsPostBack)
        {
            int dilutionnumber = 0;

            for (int i = 0; i < _batchData.Rows.Count; i++)
            {
                dilutionnumber += BioPM.ClassObjects.QualityControlCatalog.GetNumberOfDilutionByBatch(_batchData.Rows[i]["BATCH"].ToString());
            }

            txtDilutionNumber.Text = dilutionnumber.ToString();
        }
    }

    protected bool ValidateBatchInput()
    {
        bool isValid = true;
        for (int i = 0; i < _batchData.Rows.Count; i++)
        {
            if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(_batchData.Rows[i]["BATCH"].ToString()))
            {
                isValid = false;
                message = BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "BATCH, SAMPLE NUMBER " + _batchData.Rows[i]["SMPNO"].ToString(), "");
                break;
            }
        }

        return isValid;
    }


    protected void RunRandomToGetDilutionSample()
    {
        if (!ValidateBatchInput())
        {
            return;
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(ddlRandomDate.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "ANIMAL RANDOM DATE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtRandomDate.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "QC RANDOM DATE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSampleNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtDilutionNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "NUMBER OF DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtAnimalPerDilution.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "ANIMAL PER DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSampleNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtDilutionNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtAnimalPerDilution.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "ANIMAL PER DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSampleNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtDilutionNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtAnimalPerDilution.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "ANIMAL PER DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtSampleNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtDilutionNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "NUMBER OF DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtAnimalPerDilution.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "ANIMAL PER DILUTION", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(Convert.ToInt16(txtAnimalPerCage.Text), Convert.ToInt16(txtAnimalPerDilution.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "ANIMAL PER CAGE", "ANIMAL PER DILUTION") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(Convert.ToInt16(txtSampleNumber.Text), Convert.ToInt16(txtDilutionNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "NUMBER OF SAMPLE", "NUMBER OF DILUTION") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateModResult(Convert.ToInt16(txtDilutionNumber.Text), Convert.ToInt16(txtSampleNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(2, "NUMBER OF DILUTION", "NUMBER OF SAMPLE") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateModResult(Convert.ToInt16(txtAnimalPerDilution.Text), Convert.ToInt16(txtAnimalPerCage.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(2, "ANIMAL PER DILUTION", "ANIMAL PER CAGE") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(((Convert.ToInt16(txtAnimalPerDilution.Text) / Convert.ToInt16(txtAnimalPerCage.Text)) * Convert.ToInt16(txtDilutionNumber.Text)), Convert.ToInt16(txtAnimalNumber.Text) / Convert.ToInt16(txtAnimalPerCage.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "NUMBER OF ANIMAL", "ANIMAL PER CAGE") + "');", true);
        }
        else
        {
            InsertDilutionTestIntoDatabase();
            UpdateDilutionDataIntoDatabase();
            Response.Redirect("PageSampleDilutionRandomDemo.aspx");
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        RunRandomToGetDilutionSample();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>PERTUSSIS POTENCY</title>

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
                        PERTUSSIS POTENCY RANDOM SAMPLE ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                       
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ANIMAL RANDOM DATE </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlRandomDate" AutoPostBack="true" runat="server" class="form-control m-bot15" OnSelectedIndexChanged="ddlRandomDate_SelectedIndexChanged">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF ANIMAL </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtAnimalNumber" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ANIMAL PER CAGE </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtAnimalPerCage" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF DILUTION</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtDilutionNumber" runat="server" class="form-control m-bot15" placeholder="NUMBER OF DILUTION SAMPLE" ></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-md-3">QC RANDOM DATE</label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtRandomDate" value="" size="16" class="form-control form-control-inline input-medium default-date-picker" runat="server"></asp:TextBox>
                                <span class="help-block">Random Date Format : month-day-year e.g. 01-31-2014</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumber" runat="server" AutoPostBack="true" OnTextChanged="txtSampleNumber_TextChanged" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"></label>
                            <div class="col-lg-3 col-md-4">
                                   
                        <asp:GridView ID="GridViewBatch" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                            BorderStyle="Solid" BorderWidth="2px" CellPadding="4" ForeColor="#e9ecef" GridLines="Both"
                            OnRowDataBound="GridViewBatch_RowDataBound" OnRowCommand="GridViewBatch_RowCommand" OnRowUpdating="GridViewBatch_RowUpdating" ShowFooter="True"> 
                            <Columns>                 
                                <asp:ButtonField Text="SingleClick" CommandName="SingleClick" Visible="false"/> 
                                <asp:TemplateField HeaderText="Sample Number"> 
                                    <ItemTemplate>
                                        <asp:Label ID="SMPNOLabel" runat="server" Text='<%# Eval("SMPNO") %>'></asp:Label>    
                                        <asp:TextBox ID="SMPNO" runat="server" Text='<%# Eval("SMPNO") %>' Width="175px" visible="false"></asp:TextBox>                       
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Batch"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="BATCHLabel" runat="server" Text='<%# Eval("BATCH") %>'></asp:Label>      
                                        <asp:DropDownList ID="AssignedTo" runat="server" Visible="false" AutoPostBack="true" > 
                                        </asp:DropDownList> 
                                    </ItemTemplate>
                                </asp:TemplateField> 
                            </Columns> 
                        </asp:GridView>     
                        </div> 
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ANIMAL PER DILUTION </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtAnimalPerDilution" runat="server" class="form-control m-bot15" placeholder="ANIMAL PER DILUTION" ></asp:TextBox>
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
