<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGenerateNVTCloned.aspx.cs" Inherits="BioPM.FormGenerateNVTCloned" %>

<!DOCTYPE html>
<script runat="server">
    Random rand = new Random();
    private const int _firstEditCellIndex = 2;
    int numberofanimal;
    string message = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["coctr"].ToString() != "52500" && Session["coctr"].ToString() != "64100") Response.Redirect("PageUserPanel.aspx");
        if (!IsPostBack)
        {
            GetAnimalNumberEachBuilding();
            GetDataBuilding();
            _batchsampleData = null;
            this.GridView2.DataSource = _batchsampleData;
            this.GridView2.DataBind();
        }

        if (this.GridView2.SelectedIndex > -1)
        {
            // Call UpdateRow on every postback 
            this.GridView2.UpdateRow(this.GridView2.SelectedIndex, false);
        }
    }

    // Register the dynamically created client scripts 
    protected override void Render(HtmlTextWriter writer)
    {
        foreach (GridViewRow r in GridView2.Rows)
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
    /// GRID VIEW 2 --> BATCH & SAMPLE
    /// </summary>
    /// 
    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
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

    protected void GridView2_RowCommand(object sender, GridViewCommandEventArgs e)
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
                _gridView.DataSource = _batchsampleData;
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
    protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
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
                        System.Data.DataTable dt = _batchsampleData;
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
                        _batchsampleData = dt;

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
                        _gridView.DataSource = _batchsampleData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    /// <summary> 
    /// Property to manage data 
    /// </summary> 
    private System.Data.DataTable _batchsampleData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["BatchData"];

            if (dt == null)
            {
                // Create a DataTable and save it to session 
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("SMPNO", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("BATCH", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("ANMPS", typeof(string)));
                
                // Add the id column as a primary key 
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["SMPNO"];
                dt.PrimaryKey = keys;

                _batchsampleData = dt;
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
        _batchsampleData = null;
        for (int i = 1; i <= Convert.ToInt16(txtSampleNumber.Text); i++)
        {
            System.Data.DataTable dt = _batchsampleData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { i.ToString(), "", "" });
            _batchsampleData = dt;

            // Repopulate the GridView 
            this.GridView2.DataSource = _batchsampleData;
            this.GridView2.DataBind();
        }
    }
    
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    protected void GenerateRandomNumber(int inis, int total)
    {
        BioPM.ClassObjects.RandomNumberCatalog.DeleteRandomNumber();
        for (int i = inis; i < inis + total; i++)
        {
            BioPM.ClassObjects.RandomNumberCatalog.InsertRandomNumber(i, rand.Next(1, total));
        }
    }

    protected void ddlNVTBuilding_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            GetDataBuilding();
        }
    }
    
    protected void GetDataBuilding()
    {
        if (ddlNVTBuilding.SelectedValue != null)
        {
            object[] values = BioPM.ClassObjects.NvtCatalog.GetNumberOfAnimalFromNVTBuilding(ddlNVTBuilding.SelectedValue);
            txtAnimalNumber.Text = values[1].ToString();
            txtFirstNumber.Text = values[0].ToString();
            txtLastNumber.Text = (Convert.ToInt16(values[1]) + Convert.ToInt16(values[0]) - 1).ToString();
        }
    }

    protected void GetAnimalNumberEachBuilding()
    {
        ddlNVTBuilding.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.NvtCatalog.GetAnimalFromNVTBuilding())
        {
            ddlNVTBuilding.Items.Add(new ListItem(data[1].ToString() + " - " + data[3].ToString() + " " + data[2].ToString(), data[0].ToString()));
        }
    }

    //protected void InsertAnimalRandomIntoDatabase()
    //{
    //    string RNDID = (BioPM.ClassObjects.NvtCatalog.GetNVTMaxID() + 1).ToString();
    //    Session["id"] = RNDID;
        
    //    int first = Convert.ToInt16(txtFirstNumber.Text);
    //    int last = Convert.ToInt16(txtLastNumber.Text);
    //    int total = Convert.ToInt16(txtAnimalNumber.Text);
        
    //    object[] values = BioPM.ClassObjects.NvtCatalog.GetDataOfBuildingByID(ddlNVTBuilding.SelectedValue);
    //    string buildingname = values[1].ToString();
    //    string animaltype = values[0].ToString();
        

    //    int samplenumber = Convert.ToInt16(txtSampleNumber.Text);   
    //    int dividedbatch = Convert.ToInt16(_batchsampleData.Rows[0]["ANMPS"]);
    //    int index = 0;

    //    for (int i = 0; i < _batchsampleData.Rows.Count; i++)
    //    {
    //        GenerateRandomNumber(first, Convert.ToInt16(_batchsampleData.Rows[i]["ANMPS"]));
    //        first = first + Convert.ToInt16(_batchsampleData.Rows[i]["ANMPS"]);
    //        List<int> animalnumbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
            
    //        for (int x = 0; x < Convert.ToInt16(_batchsampleData.Rows[i]["ANMPS"]); x++)
    //        {
    //            BioPM.ClassObjects.NvtCatalog.InsertNVT(RNDID, txtRandomDate.Text, animaltype, "24", ddlNVTBuilding.SelectedValue, buildingname, (index+1).ToString(), animalnumbers[x].ToString(), _batchsampleData.Rows[i]["BATCH"].ToString(), Session["username"].ToString());
    //            index++;
    //        }
    //    }
    //}

    protected void InsertAnimalRandomIntoDatabase()
    {
        string RNDID = (BioPM.ClassObjects.NvtCatalog.GetNVTMaxID() + 1).ToString();
        Session["id"] = RNDID;

        int first = Convert.ToInt16(txtFirstNumber.Text);
        int last = Convert.ToInt16(txtLastNumber.Text);
        int total = Convert.ToInt16(txtAnimalNumber.Text);
        GenerateRandomNumber(first, total);
        List<int> animalnumbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());

        object[] values = BioPM.ClassObjects.NvtCatalog.GetDataOfBuildingByID(ddlNVTBuilding.SelectedValue);
        string buildingname = values[1].ToString();
        string animaltype = values[0].ToString();


        int samplenumber = Convert.ToInt16(txtSampleNumber.Text);
        int dividedbatch = Convert.ToInt16(_batchsampleData.Rows[0]["ANMPS"]);
        int index = 0;

        for (int i = 0; i < _batchsampleData.Rows.Count; i++)
        {
            for (int x = 0; x < Convert.ToInt16(_batchsampleData.Rows[i]["ANMPS"]); x++)
            {
                BioPM.ClassObjects.NvtCatalog.InsertNVT(RNDID, txtRandomDate.Text, animaltype, "24", ddlNVTBuilding.SelectedValue, buildingname, (index + 1).ToString(), animalnumbers[index].ToString(), _batchsampleData.Rows[i]["BATCH"].ToString(), Session["username"].ToString());
                index++;
            }
        }
    }

    protected void RunRandomToGetDilutionSample()
    {
        InsertAnimalRandomIntoDatabase();
        Response.Redirect("PageSampleNVT.aspx");
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

    <title>NVT</title>

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
                        NVT RANDOM SAMPLE ENTRY FORM
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
                            <label class="col-sm-3 control-label"> BUILDING </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlNVTBuilding" AutoPostBack="true" OnSelectedIndexChanged="ddlNVTBuilding_SelectedIndexChanged" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> FIRST NUMBER</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtFirstNumber" runat="server" AutoPostBack="true" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> LAST NUMBER</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtLastNumber" runat="server" AutoPostBack="true" class="form-control m-bot15" ></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF ANIMAL</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtAnimalNumber" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtSampleNumber" AutoPostBack="true" runat="server" OnTextChanged="txtSampleNumber_TextChanged" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"></label>
                            <div class="col-lg-3 col-md-4">

                        <asp:GridView ID="GridView2" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                            BorderStyle="Solid" BorderWidth="2px" CellPadding="4" ForeColor="Black" GridLines="Both"
                            OnRowDataBound="GridView2_RowDataBound" OnRowCommand="GridView2_RowCommand" OnRowUpdating="GridView2_RowUpdating" ShowFooter="True"> 
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
                                        <asp:TextBox ID="BATCH" runat="server" Text='<%# Eval("BATCH") %>' Width="175px" visible="false"></asp:TextBox>                    
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Animal Per Sample"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="ANMPSLabel" runat="server" Text='<%# Eval("ANMPS") %>'></asp:Label>      
                                        <asp:TextBox ID="ANMPS" runat="server" Text='<%# Eval("ANMPS") %>' Width="175px" visible="false"></asp:TextBox>                    
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                            </Columns> 
                        </asp:GridView>     
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
