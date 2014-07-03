<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="sample.aspx.cs" Inherits="BioPM.sample" %>


!DOCTYPE html>
<script runat="server">
    string itmnm, qcname, tesdt;
    private const int _firstEditCellIndex = 2;
    
    protected void Page_Load(object sender, EventArgs e)
    {

        sessionCreator();
        if (!IsPostBack)
        {
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
                    this.Message.Text += "Single clicked GridView row at index " + _rowIndex.ToString()
                        + " on column index " + _columnIndex + "<br />";

                    // Get the display control for the selected cell and make it invisible 
                    Control _displayControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[1];
                    _displayControl.Visible = false;
                    // Get the edit control for the selected cell and make it visible 
                    Control _editControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[3];
                    _editControl.Visible = true;
                    // Clear the attributes from the selected cell to remove the click event 
                    _gridView.Rows[_rowIndex].Cells[_columnIndex].Attributes.Clear();

                    // Set focus on the selected edit control 
                    ScriptManager.RegisterStartupScript(this, GetType(), "SetFocus",
                        "document.getElementById('" + _editControl.ClientID + "').focus();", true);
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
                            Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("IdLabel");
                            int id = int.Parse(idLabel.Text);
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
                            this.Message.Text += "Error updating GridView row at index "
                                + e.RowIndex + "<br />";

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
                    //dt = BioPM.ClassObjects.QualityControlCatalog.GetAllQCDilutionTestBySample(Session["id"].ToString(), Request.QueryString["smpno"]);
                    
                    dt.Columns.Add(new System.Data.DataColumn("Id", typeof(int)));
                    dt.Columns.Add(new System.Data.DataColumn("Description", typeof(string)));
                    dt.Columns.Add(new System.Data.DataColumn("AssignedTo", typeof(string)));
                    dt.Columns.Add(new System.Data.DataColumn("Status", typeof(string)));
                    dt.Columns.Add(new System.Data.DataColumn("Tick", typeof(string)));

                    dt.Rows.Add(new object[] { 1, "Create a new project", "Declan", "Complete", true });
                    dt.Rows.Add(new object[] { 2, "Build a demo applcation", "Olive", "In Progress", false });
                    dt.Rows.Add(new object[] { 3, "Test the demo applcation", "Peter", "Pending", true });
                    dt.Rows.Add(new object[] { 4, "Deploy the demo applcation", "Andy", "Pending", false });
                    dt.Rows.Add(new object[] { 5, "Support the demo applcation", "", "Pending", true });

                    // Add the id column as a primary key 
                    System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                    keys[0] = dt.Columns["id"];
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
        object[] values = BioPM.ClassObjects.QualityControlCatalog.GetQCDilutionTestByIDAndDilutionNumber(Session["id"].ToString(), Request.QueryString["dilno"]);
        txtBatch.Text = values[0].ToString();
        //txtDilutionConcentration.Text = values[1].ToString();
        SetDataQCTest();
    }
    
    protected void SetDataToForm()
    {
        SetDataQCDilution();
    }
    
    protected void UpdateDilutionDataIntoDatabase()
    {
        //BioPM.ClassObjects.QualityControlCatalog.UpdateQCDilutionTest(Session["id"].ToString(), Request.QueryString["smpno"], Request.QueryString["dilno"], txtBatch.Text, txtDilutionConcentration.Text);
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        UpdateDilutionDataIntoDatabase();
        Response.Redirect("PageSampleDilutionRandom.aspx");
    }

    protected void btnAddData_Click(object sender, EventArgs e)
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
    
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    <meta charset="utf-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="ThemeBucket">
    <link rel="shortcut icon" href="Scripts/UserPanel/images/favicon.html">

    <title>DILUTION TEST</title>

    <% Response.Write(BioPM.ClassScripts.StyleScripts.GetCoreStyle()); %>
    <link href="Scripts/UserPanel/bs3/css/bootstrap.min.css" rel="stylesheet">
    <link href="Scripts/UserPanel/css/bootstrap-reset.css" rel="stylesheet">
    <link href="Scripts/UserPanel/assets/font-awesome-4.1.0/css/font-awesome.min.css" rel="stylesheet" />

    <!-- Form Style -->
    <link rel="stylesheet" href="Scripts/UserPanel/assets/bootstrap-switch-master/build/css/bootstrap3/bootstrap-switch.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/bootstrap-fileupload/bootstrap-fileupload.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/bootstrap-datepicker/css/datepicker.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/bootstrap-timepicker/compiled/timepicker.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/bootstrap-colorpicker/css/colorpicker.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/bootstrap-daterangepicker/daterangepicker-bs3.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/bootstrap-datetimepicker/css/datetimepicker.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/jquery-multi-select/css/multi-select.css" />
    <link rel="stylesheet" type="text/css" href="Scripts/UserPanel/assets/jquery-tags-input/jquery.tagsinput.css" />

    <!-- Custom styles for this template -->
    <link href="Scripts/UserPanel/css/style.css" rel="stylesheet">
    <link href="Scripts/UserPanel/css/style-responsive.css" rel="stylesheet" />

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src="js/ie8/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
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
                            <p>
                                Test Name   : <% Response.Write(" " + qcname); %> <br/>
                                Random Date :  <% Response.Write(" " + tesdt); %> <br/>
                                Animal Name   : <% Response.Write(" " + itmnm); %> <br/>
                                <br/>
                                <br/>
                            </p>
                        </h4>
                        <form class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> BATCH </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtBatch" runat="server" class="form-control m-bot15" placeholder="BATCH" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-lg-3 col-md-4">
                        <asp:Button ID="btnAddData" runat="server" OnClick="btnAddData_Click" Text="Add Data" class="btn btn-round btn-primary"  />
                             </div>
                        <div class="col-lg-3 col-md-4">

                                   
                        <asp:GridView ID="GridView1" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                            BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Vertical" 
                            OnRowDataBound="GridView1_RowDataBound" OnRowCommand="GridView1_RowCommand" OnRowUpdating="GridView1_RowUpdating" ShowFooter="True"> 
                            <Columns>                 
                                <asp:ButtonField Text="SingleClick" CommandName="SingleClick" Visible="False"/> 
                                <asp:TemplateField HeaderText="Id"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>'></asp:Label>                         
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Task"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="DescriptionLabel" runat="server" Text='<%# Eval("Description") %>'></asp:Label> 
                                        <asp:TextBox ID="Description" runat="server" Text='<%# Eval("Description") %>' Width="175px" visible="false"></asp:TextBox> 
                                    </ItemTemplate> 
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Assigned To"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="AssignedToLabel" runat="server" Text='<%# Eval("AssignedTo") %>'></asp:Label> 
                                        <asp:DropDownList ID="AssignedTo" runat="server" Visible="false" AutoPostBack="true" CausesValidation="true"> 
                                            <asp:ListItem></asp:ListItem> 
                                            <asp:ListItem>Andy</asp:ListItem> 
                                            <asp:ListItem>Betty</asp:ListItem> 
                                            <asp:ListItem>Conor</asp:ListItem> 
                                            <asp:ListItem>Declan</asp:ListItem> 
                                            <asp:ListItem>Eamon</asp:ListItem> 
                                            <asp:ListItem>Fergal</asp:ListItem> 
                                            <asp:ListItem>Gordon</asp:ListItem> 
                                            <asp:ListItem>Helen</asp:ListItem> 
                                            <asp:ListItem>Iris</asp:ListItem> 
                                            <asp:ListItem>John</asp:ListItem> 
                                            <asp:ListItem>Kevin</asp:ListItem> 
                                            <asp:ListItem>Lorna</asp:ListItem> 
                                            <asp:ListItem>Matt</asp:ListItem> 
                                            <asp:ListItem>Nora</asp:ListItem> 
                                            <asp:ListItem>Olive</asp:ListItem> 
                                            <asp:ListItem>Peter</asp:ListItem> 
                                        </asp:DropDownList> 
                                    </ItemTemplate> 
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Status"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="StatusLabel" runat="server" Text='<%# Eval("Status") %>'></asp:Label> 
                                        <asp:DropDownList ID="Status" runat="server" Visible="false" AutoPostBack="true" CausesValidation="true"> 
                                            <asp:ListItem>Pending</asp:ListItem> 
                                            <asp:ListItem>In Progress</asp:ListItem> 
                                            <asp:ListItem>Complete</asp:ListItem> 
                                            <asp:ListItem>Cancelled</asp:ListItem> 
                                            <asp:ListItem>Suspended</asp:ListItem> 
                                        </asp:DropDownList> 
                                    </ItemTemplate> 
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Tick"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="TickLabel" runat="server" Text='<%# Eval("Tick") %>'></asp:Label> 
                                        <asp:CheckBox ID="Tick" runat="server" Visible="false" AutoPostBack="true" /> 
                                    </ItemTemplate> 
                                </asp:TemplateField> 
                            </Columns> 
                            <HeaderStyle CssClass="headerStyle" ForeColor="White" /> 
                            <RowStyle CssClass="rowStyle" /> 
                            <AlternatingRowStyle CssClass="alternatingRowStyle" /> 
                            <FooterStyle CssClass="footerStyle" /> 
                            <PagerStyle CssClass="pagerStyle" ForeColor="White" /> 
                        </asp:GridView> 
                        <br /><br /> 
                        <asp:Label id="Message" runat="server" CssClass="message"></asp:Label>         
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

<!--Core js-->
<script src="Scripts/UserPanel/js/lib/jquery.js"></script>
<script src="Scripts/UserPanel/js/lib/jquery-1.8.3.min.js"></script>
<script src="Scripts/UserPanel/bs3/js/bootstrap.min.js"></script>
<script src="Scripts/UserPanel/js/lib/jquery-ui-1.9.2.custom.min.js"></script>
<script class="include" type="text/javascript" src="Scripts/UserPanel/js/accordion-menu/jquery.dcjqaccordion.2.7.js"></script>
<script src="Scripts/UserPanel/js/scrollTo/jquery.scrollTo.min.js"></script>
<script src="Scripts/UserPanel/assets/easypiechart/jquery.easypiechart.js"></script>
<script src="Scripts/UserPanel/js/nicescroll/jquery.nicescroll.js" type="text/javascript"></script>

<script src="Scripts/UserPanel/assets/bootstrap-switch-master/build/js/bootstrap-switch.js"></script>

<script type="text/javascript" src="Scripts/UserPanel/assets/fuelux/js/spinner.min.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-fileupload/bootstrap-fileupload.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-wysihtml5/wysihtml5-0.3.0.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-wysihtml5/bootstrap-wysihtml5.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-daterangepicker/moment.min.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-daterangepicker/daterangepicker.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/jquery-multi-select/js/jquery.multi-select.js"></script>
<script type="text/javascript" src="Scripts/UserPanel/assets/jquery-multi-select/js/jquery.quicksearch.js"></script>

<script type="text/javascript" src="Scripts/UserPanel/assets/bootstrap-inputmask/bootstrap-inputmask.min.js"></script>

<script src="Scripts/UserPanel/assets/jquery-tags-input/jquery.tagsinput.js"></script>

<!--common script init for all pages-->
<script src="Scripts/UserPanel/js/scripts.js"></script>

<script src="Scripts/UserPanel/js/toggle-button/toggle-init.js"></script>

<script src="Scripts/UserPanel/js/advanced-form/advanced-form.js"></script>
<!--Easy Pie Chart-->
<script src="Scripts/UserPanel/assets/easypiechart/jquery.easypiechart.js"></script>
<!--Sparkline Chart-->
<script src="Scripts/UserPanel/assets/sparkline/jquery.sparkline.js"></script>
<!--jQuery Flot Chart-->
<script src="Scripts/UserPanel/assets/flot-chart/jquery.flot.js"></script>
<script src="Scripts/UserPanel/assets/flot-chart/jquery.flot.tooltip.min.js"></script>
<script src="Scripts/UserPanel/assets/flot-chart/jquery.flot.resize.js"></script>
<script src="Scripts/UserPanel/assets/flot-chart/jquery.flot.pie.resize.js"></script>

</body>
</html>