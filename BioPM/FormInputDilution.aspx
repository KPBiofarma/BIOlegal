<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormInputDilution.aspx.cs" Inherits="BioPM.FormInputDilution" %>

<!DOCTYPE html>
<script runat="server">
    private const int _firstEditCellIndex = 2;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (!IsPostBack)
        {
            SetDataToForm();
            _sampleData = null;
            this.GridView1.DataSource = _sampleData;
            this.GridView1.DataBind();
        }

        if (this.GridView1.SelectedIndex > -1)
        {
            
            this.GridView1.UpdateRow(this.GridView1.SelectedIndex, false);
        }
    }
    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
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
                
                _gridView.DataSource = _sampleData;
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
                        
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("DILNOLabel");
                        string id = idLabel.Text;
                        
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

                        
                        _sampleData = dt;

                        
                        
                        _gridView.SelectedIndex = -1;

                        
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        
                        

                        
                        _gridView.DataSource = _sampleData;
                        _gridView.DataBind();
                    }
                }
            }
        }
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

        base.Render(writer);
    }

    
    
    
    private System.Data.DataTable _sampleData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["Data"];

            if (dt == null)
            {
                
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("DILNO", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("DILCN", typeof(string)));

                
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["DILNO"];
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

    protected void txtDilutionNumber_TextChanged(object sender, EventArgs e)
    {
        _sampleData = null;
        for (int i = 1; i <= Convert.ToInt16(txtDiluntionNumber.Text); i++)
        {
            System.Data.DataTable dt = _sampleData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { i.ToString(), "0" });
            _sampleData = dt;

            
            this.GridView1.DataSource = _sampleData;
            this.GridView1.DataBind();
        }
    }

    protected void SetProduct()
    {
        ddlProductType.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.BatchCatalog.GetProductByCostCenter(Session["coctr"].ToString()))
        {
            ddlProductType.Items.Add(new ListItem(data[1].ToString(), data[0].ToString()));
        }
    }

    protected void SetDataToForm()
    {
        SetProduct();
    }

    protected void InsertDilutionIntoDatabase()
    {
        for (int i = 0; i < Convert.ToInt16(txtDiluntionNumber.Text); i++)
        {   
            BioPM.ClassObjects.DilutionCatalog.InsertDilution(ddlProductType.SelectedValue, (i+1).ToString(), _sampleData.Rows[i]["DILCN"].ToString(), Session["username"].ToString());
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (IsPostBack) InsertDilutionIntoDatabase();
        Response.Redirect("PageDilutionSample.aspx");
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
</script>

<html lang="en">
<head>
    
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>QC DILUTION ENTRY</title>
  
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
                        QC DILUTION ENTRY FORM
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                        
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> PRODUCT NAME </label>
                            <div class="col-lg-3 col-md-4">
                            <asp:DropDownList ID="ddlProductType" runat="server" class="form-control m-bot15">
                                </asp:DropDownList> 
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> NUMBER OF DILUTION </label>
                            <div class="col-lg-3 col-md-4">
                                <asp:TextBox ID="txtDiluntionNumber" AutoPostBack="true" runat="server" class="form-control m-bot15" OnTextChanged="txtDilutionNumber_TextChanged"  placeholder="NUMBER OF DILUTION" ></asp:TextBox>
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
                                <asp:Button class="btn btn-round btn-primary" ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click"/>
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
