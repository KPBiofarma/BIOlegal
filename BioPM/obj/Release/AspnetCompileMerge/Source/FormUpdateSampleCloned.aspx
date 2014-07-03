<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormUpdateSampleCloned.aspx.cs" Inherits="BioPM.FormUpdateSampleCloned" %>

<!DOCTYPE html>
<script runat="server">
    string itmnm, qcname, tesdt;
    private const int _firstEditCellIndex = 2;
    
    protected void Page_Load(object sender, EventArgs e)
    {

        sessionCreator();
        SetDataQCTest();
        if (!IsPostBack)
        {
            SetDataToForm();
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
                    ScriptManager.RegisterStartupScript(this, GetType(), "SetFocus","document.getElementById('" + _editControl.ClientID + "').focus();", true);
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
                            Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("DILNOLabel");
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
                System.Data.DataTable dt = (System.Data.DataTable)Session["TestData"];

                if (dt == null)
                {
                    // Create a DataTable and save it to session 
                    dt = new System.Data.DataTable();
                    dt = BioPM.ClassObjects.QualityControlCatalog.GetAllQCDilutionTestBySampleCloned(Session["id"].ToString(), Request.QueryString["smpno"]);
                    //dt = BioPM.ClassObjects.QualityControlCatalog.GetAllQCDilutionTestBySample("1", "1");
                    
                    // Add the id column as a primary key 
                    System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                    keys[0] = dt.Columns["DILNO"];
                    dt.PrimaryKey = keys;

                    _sampleData = dt;
                }

                return dt;
            }
            set
            {
                Session["TestData"] = value;
            }
        }

    
    
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected void SetDataQCTest()
    {
        object[] values = BioPM.ClassObjects.QualityControlCatalog.GetAllQCDilutionTestByID(Session["id"].ToString())[0]; ;
        itmnm = values[4].ToString();
        qcname = values[3].ToString();
        tesdt = values[1].ToString();
    }

    protected void SetDataQCDilution()
    {
        object[] values = BioPM.ClassObjects.QualityControlCatalog.GetQCDilutionTestByIDAndSampleNumber(Session["id"].ToString(), Request.QueryString["smpno"]);
        txtBatch.Text = values[0].ToString();
        txtSampleNumber.Text = values[1].ToString();
    }
    
    protected void SetDataToForm()
    {
        SetDataQCDilution();
    }
    
    protected void UpdateDilutionDataIntoDatabase()
    {
        for (int i = 0; i < _sampleData.Rows.Count; i++)
        {
            BioPM.ClassObjects.QualityControlCatalog.UpdateQCDilutionTest(Session["id"].ToString(), Request.QueryString["smpno"], _sampleData.Rows[i]["DILNO"].ToString(), txtBatch.Text, _sampleData.Rows[i]["DILCN"].ToString());
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        UpdateDilutionDataIntoDatabase();
        Response.Redirect("PageSampleDilutionRandom.aspx");
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageSampleDilutionRandom.aspx");
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>DILUTION TEST</title>

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
                        SAMPLE TEST UPDATE FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <h4>
                                Test Name   : <% Response.Write(" " + qcname); %> <br/>
                                Random Date :  <% Response.Write(" " + tesdt); %> <br/>
                                Animal Name   : <% Response.Write(" " + itmnm); %> <br/>
                                <br/>
                                <br/>
                        </h4>
                        <form class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> BATCH </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtBatch" runat="server" class="form-control m-bot15" placeholder="BATCH" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> SAMPLE NUMBER </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtSampleNumber" class="form-control m-bot15" runat="server"> </asp:Label>
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
                                <asp:TemplateField HeaderText="Dilution Number"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="DILNOLabel" runat="server" Text='<%# Eval("DILNO") %>'></asp:Label>    
                                        <asp:TextBox ID="DILNO" runat="server" Text='<%# Eval("DILNO") %>' Width="175px" visible="false"></asp:TextBox>                       
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Concentration"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="DILCNLabel" runat="server" Text='<%# Eval("DILCN") %>'></asp:Label>      
                                        <asp:TextBox ID="DILCN" runat="server" Text='<%# Eval("DILCN") %>' Width="175px" visible="false"></asp:TextBox>                    
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                            </Columns> 
                        </asp:GridView>     
                        </div> 
                        </div>
                        

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
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
