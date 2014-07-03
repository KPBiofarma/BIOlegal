<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGenerateMWGT.aspx.cs" Inherits="BioPM.FormGenerateMWGT" %>

<!DOCTYPE html>
<script runat="server">
    Random rand = new Random();
    private const int _firstEditCellIndex = 2;
    string message = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["coctr"].ToString() != "52100" && Session["coctr"].ToString() != "64100") Response.Redirect("PageUserPanel.aspx");
        if (!IsPostBack)
        {
            GetAnimalMouseType();
            _sampleData = null;
            this.GridView1.DataSource = _sampleData;
            this.GridView1.DataBind();
        }

        if (this.GridView1.SelectedIndex > -1)
        {
            // Call UpdateRow on every postback 
            this.GridView1.UpdateRow(this.GridView1.SelectedIndex, false);
        }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddlBatch = (e.Row.FindControl("AssignedTo") as DropDownList);
            //foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAllBatch())
            foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAllBatchByCostCenter(Session["coctr"].ToString()))
            {
                ddlBatch.Items.Add(new ListItem(data[0].ToString(), data[0].ToString()));
            }
            // Get the LinkButton control in the first cell 
            LinkButton _singleClickButton = (LinkButton)e.Row.Cells[0].Controls[0];
            // Get the javascript which is assigned to this LinkButton 
            string _jsSingle = ClientScript.GetPostBackClientHyperlink(_singleClickButton, "");

            // If the page contains validator controls then call  
            // Page_ClientValidate before allowing a cell to be edited 
            if (Page.Validators.Count > 0)
                _jsSingle = _jsSingle.Insert(11, "if(Page_ClientValidate())");

            // Add events to each editable cell 
            for (int columnIndex = _firstEditCellIndex; columnIndex < e.Row.Cells.Count; columnIndex++)
            {
                // Add the column index as the event argument parameter 
                string js = _jsSingle.Insert(_jsSingle.Length - 2, columnIndex.ToString());
                // Add this javascript to the onclick Attribute of the cell 
                e.Row.Cells[columnIndex].Attributes["onclick"] = js;
                // Add a cursor style to the cells 
                e.Row.Cells[columnIndex].Attributes["style"] += "cursor:pointer;cursor:hand;";
            }
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        switch (e.CommandName)
        {
            case ("SingleClick"):
                // Get the row index 
                int _rowIndex = int.Parse(e.CommandArgument.ToString());
                // Parse the event argument (added in RowDataBound) to get the selected column index 
                int _columnIndex = int.Parse(Request.Form["__EVENTARGUMENT"]);
                // Set the Gridview selected index 
                _gridView.SelectedIndex = _rowIndex;
                // Bind the Gridview 
                _gridView.DataSource = _sampleData;
                _gridView.DataBind();

                // Write out a history if the event 
                //this.Message.Text += "Single clicked GridView row at index " + _rowIndex.ToString()
                //    + " on column index " + _columnIndex + "<br />";

                // Get the display control for the selected cell and make it invisible 
                Control _displayControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[1];
                _displayControl.Visible = false;
                // Get the edit control for the selected cell and make it visible 
                Control _editControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[3];
                _editControl.Visible = true;
                // Clear the attributes from the selected cell to remove the click event 
                _gridView.Rows[_rowIndex].Cells[_columnIndex].Attributes.Clear();

                // Set focus on the selected edit control 
                ScriptManager.RegisterStartupScript(this, GetType(), "SetFocus", "document.getElementById('" + _editControl.ClientID + "').focus();", true);
                // If the edit control is a dropdownlist set the 
                // SelectedValue to the value of the display control 
                if (_editControl is DropDownList && _displayControl is Label)
                {
                    ((DropDownList)_editControl).SelectedValue = ((Label)_displayControl).Text;
                }
                // If the edit control is a textbox then select the text 
                if (_editControl is TextBox)
                {
                    ((TextBox)_editControl).Attributes.Add("onfocus", "this.select()");
                }
                // If the edit control is a checkbox set the 
                // Checked value to the value of the display control 
                if (_editControl is CheckBox && _displayControl is Label)
                {
                    ((CheckBox)_editControl).Checked = bool.Parse(((Label)_displayControl).Text);
                }

                break;
        }
    }

    /// <summary> 
    /// Update the sample data 
    /// </summary> 
    /// <param name="sender"></param> 
    /// <param name="e"></param> 
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        if (e.RowIndex > -1)
        {
            // Loop though the columns to find a cell in edit mode 
            for (int i = _firstEditCellIndex; i < _gridView.Columns.Count; i++)
            {
                // Get the editing control for the cell 
                Control _editControl = _gridView.Rows[e.RowIndex].Cells[i].Controls[3];
                if (_editControl.Visible)
                {
                    int _dataTableColumnIndex = i - 1;

                    try
                    {
                        // Get the id of the row 
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("SMPNOLabel");
                        string id = idLabel.Text;
                        // Get the value of the edit control and update the DataTable 
                        System.Data.DataTable dt = _sampleData;
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

                        // Save the updated DataTable 
                        _sampleData = dt;

                        // Clear the selected index to prevent  
                        // another update on the next postback 
                        _gridView.SelectedIndex = -1;

                        // Repopulate the GridView 
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        //this.Message.Text += "Error updating GridView row at index "
                        //    + e.RowIndex + "<br />";

                        // Repopulate the GridView 
                        _gridView.DataSource = _sampleData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    protected void AddRow_Click(object sender, EventArgs e)
    {
        // Add a new empty row 
        System.Data.DataTable dt = _sampleData;
        int newid = dt.Rows.Count + 1;
        dt.Rows.Add(new object[] { newid, "", "", "", false });
        _sampleData = dt;

        // Repopulate the GridView 
        this.GridView1.DataSource = _sampleData;
        this.GridView1.DataBind();
    }


    // Register the dynamically created client scripts 
    protected override void Render(HtmlTextWriter writer)
    {
        // The client events for GridView1 were created in GridView1_RowDataBound 
        foreach (GridViewRow r in GridView1.Rows)
        {
            if (r.RowType == DataControlRowType.DataRow)
            {
                for (int columnIndex = _firstEditCellIndex; columnIndex < r.Cells.Count; columnIndex++)
                {
                    Page.ClientScript.RegisterForEventValidation(r.UniqueID + "$ctl00", columnIndex.ToString());
                }
            }
        }

        base.Render(writer);
    }

    /// <summary> 
    /// Property to manage data 
    /// </summary> 
    private System.Data.DataTable _sampleData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["Data"];

            if (dt == null)
            {
                // Create a DataTable and save it to session 
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("SMPNO", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("BATCH", typeof(string)));

                // Add the id column as a primary key 
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["SMPNO"];
                dt.PrimaryKey = keys;

                _sampleData = dt;
            }

            return dt;
        }
        set
        {
            Session["Data"] = value;
        }
    }

    protected void txtSampleNumber_TextChanged(object sender, EventArgs e)
    {
        for (int i = 1; i <= Convert.ToInt16(txtSampleNumber.Text); i++)
        {
            System.Data.DataTable dt = _sampleData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { i.ToString() , "" });
            _sampleData = dt;

            // Repopulate the GridView 
            this.GridView1.DataSource = _sampleData;
            this.GridView1.DataBind();
        }

        if (txtCageNumber.Text != "") txtCagePerSample.Text = (Convert.ToInt16(txtCageNumber.Text) / Convert.ToInt16(txtSampleNumber.Text)).ToString();
    }
    
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected void GenerateRandomNumber(int totalsample)
    {
        BioPM.ClassObjects.RandomNumberCatalog.DeleteRandomNumber();
        for (int i = 1; i <= totalsample; i++)
        {
            BioPM.ClassObjects.RandomNumberCatalog.InsertRandomNumber(i, rand.Next(1, totalsample));
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

    protected void InsertMWGTIntoDatabase()
    {
        int sample = Convert.ToInt16(txtSampleNumber.Text);
        int cagepersample = Convert.ToInt16(txtCagePerSample.Text);
        int cagenumber = Convert.ToInt16(txtCageNumber.Text);
        
        string QCTID = (BioPM.ClassObjects.QualityControlCatalog.GetQCDilutionMaxID() + 1).ToString();
        Session["id"] = QCTID;
        
        List<int> numbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
        int numberdivided = Convert.ToInt16(txtCagePerSample.Text);
        int samplenumber = 1;

        for (int i = 0; i < (sample * cagepersample); i++)
        {
            BioPM.ClassObjects.QualityControlCatalog.InsertQCDilutionTest(txtRandomDate.Text, "", QCTID, "6", ddlSampleType.SelectedValue, numbers[i].ToString(), txtSamplePerCage.Text, samplenumber.ToString(), Session["username"].ToString());
            if ((i + 1) % numberdivided == 0) samplenumber++;
        }
    }

    protected void UpdateMWGTDataIntoDatabase()
    {
        for (int i = 0; i < _sampleData.Rows.Count; i++)
        {
            BioPM.ClassObjects.QualityControlCatalog.UpdateQCMWGT(Session["id"].ToString(), _sampleData.Rows[i]["SMPNO"].ToString(), _sampleData.Rows[i]["BATCH"].ToString());
        }
        
    }

    protected void RunRandomToGetMWGTSample()
    {
        if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtRandomDate.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "QC RANDOM DATE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSamplePerCage.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtCageNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "NUMBER OF CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtSampleNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNullInput(txtCagePerSample.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(1, "CAGE PER SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSamplePerCage.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtCageNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtSampleNumber.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateNumberIntInput(txtCagePerSample.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(5, "CAGE PER SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSamplePerCage.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtCageNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtSampleNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidatePositiveValue(Convert.ToInt16(txtCagePerSample.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(7, "CAGE PER SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtSamplePerCage.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "ANIMAL PER CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtCageNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "NUMBER OF CAGE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtSampleNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "NUMBER OF SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateZeroValue(Convert.ToInt16(txtCagePerSample.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(8, "CAGE PER SAMPLE", "") + "');", true);
        }
        else if (!BioPM.ClassEngines.ValidationFactory.ValidateToCompareValue(Convert.ToInt16(txtSampleNumber.Text) * Convert.ToInt16(txtCagePerSample.Text), Convert.ToInt16(txtCageNumber.Text)))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + BioPM.ClassEngines.ValidationFactory.GetErrorMessage(3, "CAGE IN USE", "CAGE NUMBER") + "');", true);
        }
        else
        {
            GenerateRandomNumber(Convert.ToInt16(txtCageNumber.Text));
            InsertMWGTIntoDatabase();
            UpdateMWGTDataIntoDatabase();
            Response.Redirect("PageSampleMWGT.aspx");
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        RunRandomToGetMWGTSample();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>MWGT</title>

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
                        MWGT RANDOM SAMPLE ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                       
                        <div class="form-group">
                            <label class="control-label col-md-3">QC RANDOM DATE</label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtRandomDate" value="" size="16" class="form-control form-control-inline input-medium default-date-picker" runat="server"></asp:TextBox>
                                <span class="help-block">Random Date Format : month-day-year e.g. 01-31-2014</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ANIMAL NAME </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlSampleType" AutoPostBack="true" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ANIMAL PER CAGE </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSamplePerCage" runat="server" class="form-control m-bot15" placeholder="ANIMAL PER CAGE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF CAGE </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtCageNumber" runat="server" class="form-control m-bot15" placeholder="ANIMAL PER CAGE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumber" runat="server" AutoPostBack="true" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" OnTextChanged="txtSampleNumber_TextChanged" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"></label>
                            <div class="col-lg-3 col-md-4">
                                   
                        <asp:GridView ID="GridView1" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                            BorderStyle="Solid" BorderWidth="2px" CellPadding="4" ForeColor="Black" GridLines="Both"
                            OnRowDataBound="GridView1_RowDataBound" OnRowCommand="GridView1_RowCommand" OnRowUpdating="GridView1_RowUpdating" ShowFooter="True"> 
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
                                        <asp:DropDownList ID="AssignedTo" runat="server" Visible="false" AutoPostBack="true"> 
                                        </asp:DropDownList> 
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                            </Columns> 
                        </asp:GridView>     
                        </div> 
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> CAGE PER SAMPLE </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtCagePerSample" runat="server" class="form-control m-bot15" placeholder="CAGE PER SAMPLE" ></asp:TextBox>
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
