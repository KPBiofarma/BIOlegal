<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormGenerateNVT.aspx.cs" Inherits="BioPM.FormGenerateNVT" %>

<!DOCTYPE html>
<script runat="server">
    Random rand = new Random();
    private const int _firstEditCellIndex = 2;
    int numberofanimal;
    string message = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack)
        {
             GetAnimalMonkeyType();
            
            _buildingData = null;
            this.GridView1.DataSource = _buildingData;
            this.GridView1.DataBind();

            _batchData = null;
            this.GridView2.DataSource = _batchData;
            this.GridView2.DataBind();
        }

        if (this.GridView1.SelectedIndex > -1)
        {
            
            this.GridView1.UpdateRow(this.GridView1.SelectedIndex, false);
        }

        if (this.GridView2.SelectedIndex > -1)
        {
            
            this.GridView2.UpdateRow(this.GridView2.SelectedIndex, false);
        }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            
            LinkButton _singleClickButton = (LinkButton)e.Row.Cells[0].Controls[0];
            
            string _jsSingle = ClientScript.GetPostBackClientHyperlink(_singleClickButton, "");

            
            
            if (Page.Validators.Count > 0)
                _jsSingle = _jsSingle.Insert(11, "if(Page_ClientValidate())");

            
            for (int columnIndex = _firstEditCellIndex; columnIndex < e.Row.Cells.Count; columnIndex++)
            {
                
                string js = _jsSingle.Insert(_jsSingle.Length - 2, columnIndex.ToString());
                
                e.Row.Cells[columnIndex].Attributes["onclick"] = js;
                
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
                
                int _rowIndex = int.Parse(e.CommandArgument.ToString());
                
                int _columnIndex = int.Parse(Request.Form["__EVENTARGUMENT"]);
                
                _gridView.SelectedIndex = _rowIndex;
                
                _gridView.DataSource = _buildingData;
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

    
    
    
    
    
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        if (e.RowIndex > -1)
        {
            
            for (int i = _firstEditCellIndex; i < _gridView.Columns.Count; i++)
            {
                
                Control _editControl = _gridView.Rows[e.RowIndex].Cells[i].Controls[3];
                if (_editControl.Visible)
                {
                    int _dataTableColumnIndex = i - 1;

                    try
                    {
                        
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("BLDIDLabel");
                        string id = idLabel.Text;
                        
                        System.Data.DataTable dt = _buildingData;
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

                        
                        _buildingData = dt;

                        
                        
                        _gridView.SelectedIndex = -1;

                        
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        
                        

                        
                        _gridView.DataSource = _buildingData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    protected void AddRow_Click(object sender, EventArgs e)
    {
        
        System.Data.DataTable dt = _buildingData;
        int newid = dt.Rows.Count + 1;
        dt.Rows.Add(new object[] { newid, "", "", "", false });
        _buildingData = dt;

        
        this.GridView1.DataSource = _buildingData;
        this.GridView1.DataBind();
    }



    protected override void Render(HtmlTextWriter writer)
    {
        
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

    
    
    
    private System.Data.DataTable _buildingData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["BuildingData"];

            if (dt == null)
            {
                
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("BLDID", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("BLDNM", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("ANMNR", typeof(string)));

                
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["BLDID"];
                dt.PrimaryKey = keys;

                _buildingData = dt;
            }

            return dt;
        }
        set
        {
            Session["BuildingData"] = value;
        }
    }

    protected void txtBuildingNumber_TextChanged(object sender, EventArgs e)
    {
        _buildingData = null;
        for (int i = 1; i <= Convert.ToInt16(txtBuildingNumber.Text); i++)
        {
            System.Data.DataTable dt = _buildingData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { i.ToString(), "", "" });
            _buildingData = dt;

            
            this.GridView1.DataSource = _buildingData;
            this.GridView1.DataBind();
        }
    }
    
    /// <summary>
    /// GRID VIEW 2 --> BATCH
    /// </summary>
    /// 
    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            
            LinkButton _singleClickButton = (LinkButton)e.Row.Cells[0].Controls[0];
            
            string _jsSingle = ClientScript.GetPostBackClientHyperlink(_singleClickButton, "");

            
            
            if (Page.Validators.Count > 0)
                _jsSingle = _jsSingle.Insert(11, "if(Page_ClientValidate())");

            
            for (int columnIndex = _firstEditCellIndex; columnIndex < e.Row.Cells.Count; columnIndex++)
            {
                
                string js = _jsSingle.Insert(_jsSingle.Length - 2, columnIndex.ToString());
                
                e.Row.Cells[columnIndex].Attributes["onclick"] = js;
                
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

    
    
    
    
    
    protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        if (e.RowIndex > -1)
        {
            
            for (int i = _firstEditCellIndex; i < _gridView.Columns.Count; i++)
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
        //_batchData = null;
        //for (int i = 1; i <= Convert.ToInt16(txtSampleNumber.Text); i++)
        //{
        //    System.Data.DataTable dt = _batchData;
        //    int newid = dt.Rows.Count + 1;
        //    dt.Rows.Add(new object[] { i.ToString(), "" });
        //    _batchData = dt;

        //    
        //    this.GridView2.DataSource = _batchData;
        //    this.GridView2.DataBind();
        //}
        
        //for (int i = 0; i < _buildingData.Rows.Count; i++)
        //{
        //    numberofanimal += Convert.ToInt16(_buildingData.Rows[i]["ANMNR"].ToString());
        //}

        //txtAnimalPerSample.Text = (numberofanimal / Convert.ToInt16(txtSampleNumber.Text)).ToString();
    }

    protected void txtAnimalPerSample_TextChanged(object sender, EventArgs e)
    {
        _batchData = null;
        for (int i = 0; i < _buildingData.Rows.Count; i++)
        {
            numberofanimal += Convert.ToInt16(_buildingData.Rows[i]["ANMNR"].ToString());
        }
        
        txtSampleNumber.Text = (numberofanimal / Convert.ToInt16(txtAnimalPerSample.Text)).ToString();

        for (int i = 1; i <= Convert.ToInt16(txtSampleNumber.Text); i++)
        {
            System.Data.DataTable dt = _batchData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { i.ToString(), "" });
            _batchData = dt;

            
            this.GridView2.DataSource = _batchData;
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

    protected void GenerateRandomNumber(int totalsample)
    {
        BioPM.ClassObjects.RandomNumberCatalog.DeleteRandomNumber();
        for (int i = 1; i <= totalsample; i++)
        {
            BioPM.ClassObjects.RandomNumberCatalog.InsertRandomNumber(i, rand.Next(1, totalsample));
        }
    }

    protected void GetAnimalMonkeyType()
    {
        ddlSampleType.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalMonkeyType())
        {
            ddlSampleType.Items.Add(new ListItem(data[1].ToString(), data[0].ToString()));
        }
    }
    
    protected void InsertAnimalRandomIntoDatabase()
    {
        int buildingnumber = Convert.ToInt16(txtBuildingNumber.Text);
        int samplenumber = Convert.ToInt16(txtSampleNumber.Text);
        List<int> numberofanimals = new List<int>();

        for (int i = 0; i < _buildingData.Rows.Count; i++)
        {
            numberofanimal += Convert.ToInt16(_buildingData.Rows[i]["ANMNR"].ToString());
            numberofanimals.Add(Convert.ToInt16(_buildingData.Rows[i]["ANMNR"].ToString()));
        }
        
        GenerateRandomNumber(numberofanimal);

        string RNDID = (BioPM.ClassObjects.NvtCatalog.GetNVTMaxID() + 1).ToString();
        Session["id"] = RNDID;

        List<int> numbers = new List<int>(BioPM.ClassObjects.RandomNumberCatalog.GetRandomNumber());
        int building = 0;
        int dividedbatch = numberofanimal / samplenumber;
        int animalnumber = 1;
        int batch = 0;
        int index = 0;

        for (int i = 0; i < _buildingData.Rows.Count; i++)
        {
            for (int j = 0; j < numberofanimals[building]; j++)
            {
                BioPM.ClassObjects.NvtCatalog.InsertNVT(RNDID, txtRandomDate.Text, ddlSampleType.SelectedValue, "24", _buildingData.Rows[i]["BLDID"].ToString(), _buildingData.Rows[i]["BLDNM"].ToString(), numbers[index].ToString(), animalnumber.ToString(), _batchData.Rows[batch]["BATCH"].ToString(), Session["username"].ToString());
                animalnumber++;
                if ((index + 1) % dividedbatch == 0) batch++;
                index++;
            }
            building++;
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
                            <label class="col-sm-3 control-label"> ANIMAL NAME </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlSampleType" runat="server" class="form-control m-bot15">   
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF BUILDING</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtBuildingNumber" runat="server" AutoPostBack="true" class="form-control m-bot15" OnTextChanged="txtBuildingNumber_TextChanged" placeholder="NUMBER OF BUILDING" ></asp:TextBox>
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
                                <asp:TemplateField HeaderText="Building Number"> 
                                    <ItemTemplate>
                                        <asp:Label ID="BLDIDLabel" runat="server" Text='<%# Eval("BLDID") %>'></asp:Label>    
                                        <asp:TextBox ID="BLDID" runat="server" Text='<%# Eval("BLDID") %>' Width="175px" visible="false"></asp:TextBox>                       
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Building Name"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="BLDNMLabel" runat="server" Text='<%# Eval("BLDNM") %>'></asp:Label>      
                                        <asp:TextBox ID="BLDNM" runat="server" Text='<%# Eval("BLDNM") %>' Width="175px" visible="false"></asp:TextBox>                    
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                                <asp:TemplateField HeaderText="Number of Animal"> 
                                    <ItemTemplate> 
                                        <asp:Label ID="ANMNRLabel" runat="server" Text='<%# Eval("ANMNR") %>'></asp:Label>      
                                        <asp:TextBox ID="ANMNR" runat="server" Text='<%# Eval("ANMNR") %>' Width="175px" visible="false"></asp:TextBox>                    
                                    </ItemTemplate>                
                                </asp:TemplateField> 
                            </Columns> 
                        </asp:GridView>     
                        </div> 
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF SAMPLE</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtSampleNumber" runat="server" class="form-control m-bot15" placeholder="NUMBER OF SAMPLE" ></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> ANIMAL PER SAMPLE</label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtAnimalPerSample" runat="server" AutoPostBack="true"  OnTextChanged="txtAnimalPerSample_TextChanged" class="form-control m-bot15" placeholder="ANIMAL PER SAMPLE" ></asp:TextBox>
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
