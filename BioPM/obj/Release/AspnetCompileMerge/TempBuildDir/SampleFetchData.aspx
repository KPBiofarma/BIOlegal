<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SampleFetchData.aspx.cs" Inherits="BioPM.SampleFetchData" %>

<!DOCTYPE html>
<script runat="server">
    string message = "";
    Random rand = new Random();

    private const int _firstEditCellIndex = 2;
    
    protected void Page_Load(object sender, EventArgs e)
    {

        sessionCreator();
        if (!IsPostBack)
        {
            GetReviewer(Session["coctr"].ToString());
            _ReviewerData = null;
            Reviewers = null;
            this.GridView1.DataSource = _ReviewerData;
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
            DropDownList ddlReviewer = (e.Row.FindControl("AssignedTo") as DropDownList);
            //foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAllBatch())
            foreach(ListItem item in GetReviewer(Session["coctr"].ToString()).Items)
            {
                ddlReviewer.Items.Add(item);
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
                _gridView.DataSource = _ReviewerData;
                _gridView.DataBind();

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
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("NOMORLabel");
                        int id = int.Parse(idLabel.Text);
                        // Get the value of the edit control and update the DataTable 
                        System.Data.DataTable dt = _ReviewerData;
                        System.Data.DataRow dr = dt.Rows.Find(id);
                        dr.BeginEdit();
                        if (_editControl is TextBox)
                        {
                            dr[_dataTableColumnIndex] = ((TextBox)_editControl).Text;
                        }
                        else if (_editControl is DropDownList)
                        {
                            dr[_dataTableColumnIndex] = ((DropDownList)_editControl).SelectedItem;
                            Reviewers[e.RowIndex] = ((DropDownList)_editControl).SelectedValue;
                            dr[_dataTableColumnIndex+1] = ((DropDownList)_editControl).SelectedValue;
                        }
                        else if (_editControl is CheckBox)
                        {
                            dr[_dataTableColumnIndex] = ((CheckBox)_editControl).Checked;
                        }
                        dr.EndEdit();

                        // Save the updated DataTable 
                        _ReviewerData = dt;

                        // Clear the selected index to prevent  
                        // another update on the next postback 
                        _gridView.SelectedIndex = -1;

                        // Repopulate the GridView 
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        // Repopulate the GridView 
                        _gridView.DataSource = _ReviewerData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    protected void AddRow_Click(object sender, EventArgs e)
    {
        // Add a new empty row 
        System.Data.DataTable dt = _ReviewerData;
        int newid = dt.Rows.Count + 1;
        dt.Rows.Add(new object[] { newid, "", "" });
        _ReviewerData = dt;

        // Add a new empty row 
        List<string> data = Reviewers;
        data.Add("");
        Reviewers = data;

        // Repopulate the GridView 
        this.GridView1.DataSource = _ReviewerData;
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
    private System.Data.DataTable _ReviewerData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["ReviewerData"];

            if (dt == null)
            {
                // Create a DataTable and save it to session 
                dt = new System.Data.DataTable();
                
                dt.Columns.Add(new System.Data.DataColumn("NOMOR", typeof(int)));
                dt.Columns.Add(new System.Data.DataColumn("REVNM", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("PERNR", typeof(string)));
                
                // Add the id column as a primary key 
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["NOMOR"];
                dt.PrimaryKey = keys;

                _ReviewerData = dt;
            }

            return dt;
        }
        set
        {
            Session["ReviewerData"] = value;
        }
    }

    private List<string> Reviewers
    {
        get
        {
            List<string> reviewer = (List<string>)Session["ReviewerNIK"];

            if (reviewer == null)
            {
                // Create a DataTable and save it to session 
                reviewer = new List<string>();
                
                // Add the id column as a primary key 
                Reviewers = reviewer;
            }

            return reviewer;
        }
        set
        {
            Session["ReviewerNIK"] = value;
        }
    }
    

    protected void btnAddData_Click(object sender, EventArgs e)
    {
        // Add a new empty row 
        System.Data.DataTable dt = _ReviewerData;
        int newid = dt.Rows.Count + 1;
        dt.Rows.Add(new object[] { newid, "" });
        _ReviewerData = dt;

        // Add a new empty row 
        List<string> data = Reviewers;
        data.Add("");
        Reviewers = data;

        // Repopulate the GridView 
        this.GridView1.DataSource = _ReviewerData;
        this.GridView1.DataBind();
    }

    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["coctr"] = "64100";
        Session["role"] = "111111";
    }

    List<ListItem> Items = new List<ListItem>();
    
    protected DropDownList GetReviewer(string COCTR)
    {
        ddlSample.Items.Clear();
        int SEQ1 = 1;
        foreach (object[] data in BioPM.ClassObjects.UserCatalog.GetKadivCostCenter(COCTR))
        {
            Items.Add(new ListItem(SEQ1.ToString() + ". " + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[2].ToString()));
            ddlSample.Items.Add(new ListItem(SEQ1.ToString() + ". " + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[2].ToString()));
            GetReviewerKabag(data[4].ToString(), SEQ1);
            SEQ1++;
        }

        return ddlSample;
    }

    protected void GetReviewerKabag(string COCTR, int SEQ1)
    {
        int SEQ2 = 1;
        foreach (object[] data in BioPM.ClassObjects.UserCatalog.GetKabagByCostCenter(COCTR))
        {
            Items.Add(new ListItem(SEQ1.ToString() + "." + SEQ2.ToString() + ". " + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[2].ToString()));
            ddlSample.Items.Add(new ListItem(SEQ1.ToString() + "." + SEQ2.ToString() + ". " + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[2].ToString()));
            GetReviewerKasi(data[4].ToString(),SEQ1, SEQ2);
            SEQ2++;
        }
    }

    protected void GetReviewerKasi(string COCTR, int SEQ1, int SEQ2)
    {
        int SEQ3 = 1;
        foreach (object[] data in BioPM.ClassObjects.UserCatalog.GetKasiByCostCenter(COCTR))
        {
            Items.Add(new ListItem(SEQ1.ToString() + "." + SEQ2.ToString() + "." + SEQ3.ToString() + "." + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[2].ToString()));
            ddlSample.Items.Add(new ListItem(SEQ1.ToString() + "." + SEQ2.ToString() + "." + SEQ3.ToString() + "." + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[2].ToString()));
            SEQ3++;
        }
    }
    
    
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + _ReviewerData.Rows[0]["PERNR"].ToString() + "');", true);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
    
    }
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>SAMPLE PAGE</title>

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
                        SAMPLE PAGE
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> SAMPLE DROPDOWN </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlSample" AutoPostBack="true" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-lg-3 col-md-4">
                                <asp:Button ID="btnAddReviewer" runat="server" OnClick="btnAddData_Click" Text="Add Data" class="btn btn-round btn-primary pull-right"  />
                             </div>
                            
                            <div class="col-lg-3 col-md-4">
                            <asp:GridView ID="GridView1" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                            BorderStyle="Solid" BorderWidth="2px" ForeColor="Black" CellPadding="4"  GridLines="Vertical" 
                            OnRowDataBound="GridView1_RowDataBound" OnRowCommand="GridView1_RowCommand" OnRowUpdating="GridView1_RowUpdating" ShowFooter="True"> 
                            <Columns>                 
                                <asp:ButtonField Text="SingleClick" CommandName="SingleClick" Visible="False"/> 
                                <asp:TemplateField HeaderText="Number"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="NOMORLabel" runat="server" Text='<%# Eval("NOMOR") %>'></asp:Label> 
                                    </ItemTemplate> 
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Reviewer"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="REVNM" runat="server" Text='<%# Eval("REVNM") %>'></asp:Label> 
                                        <asp:DropDownList ID="AssignedTo" runat="server" Visible="false" AutoPostBack="true" CausesValidation="true"> 
                                        </asp:DropDownList> 
                                    </ItemTemplate> 
                                </asp:TemplateField> 
                            </Columns> 
                        </asp:GridView>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnAdd" runat="server" Text="Run Test" OnClick="btnAdd_Click"/>
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

