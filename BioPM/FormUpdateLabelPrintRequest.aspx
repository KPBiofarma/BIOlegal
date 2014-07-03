<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormUpdateLabelPrintRequest.aspx.cs" Inherits="BioPM.FormUpdateLabelPrintRequest" %>

<!DOCTYPE html>
<script runat="server">
    private const int _firstEditCellIndexReviewer = 2;
   
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        
        if (!IsPostBack)
        {
            SetDataToForm();
        }

        if (this.GridView1.SelectedIndex > -1)
        {
            this.GridView1.UpdateRow(this.GridView1.SelectedIndex, false);
        }
        
    }
    protected override void Render(HtmlTextWriter writer)
    {
        foreach (GridViewRow r in GridView1.Rows)
        {
            if (r.RowType == DataControlRowType.DataRow)
            {
                for (int columnIndex = _firstEditCellIndexReviewer; columnIndex < r.Cells.Count; columnIndex++)
                {
                    Page.ClientScript.RegisterForEventValidation(r.UniqueID + "$ctl00", columnIndex.ToString());
                }
            }
        }
        
        base.Render(writer);
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddlReviewer = (e.Row.FindControl("AssignedTo") as DropDownList);
            
            foreach (ListItem item in GetReviewer(Session["coctr"].ToString()).Items)
            {
                ddlReviewer.Items.Add(item);
            }

            
            LinkButton _singleClickButton = (LinkButton)e.Row.Cells[0].Controls[0];
            string _jsSingle = ClientScript.GetPostBackClientHyperlink(_singleClickButton, "");

            if (Page.Validators.Count > 0)
                _jsSingle = _jsSingle.Insert(11, "if(Page_ClientValidate())");

            for (int columnIndex = _firstEditCellIndexReviewer; columnIndex < e.Row.Cells.Count; columnIndex++)
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
                _gridView.DataSource = _ReviewerData;
                _gridView.DataBind();

                Control _displayControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[1];
                _displayControl.Visible = false;
                Control _editControl = _gridView.Rows[_rowIndex].Cells[_columnIndex].Controls[3];
                _editControl.Visible = true;
                _gridView.Rows[_rowIndex].Cells[_columnIndex].Attributes.Clear();

                ScriptManager.RegisterStartupScript(this, GetType(), "SetFocus",
                    "document.getElementById('" + _editControl.ClientID + "').focus();", true);
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
            for (int i = _firstEditCellIndexReviewer; i < _gridView.Columns.Count; i++)
            {
                Control _editControl = _gridView.Rows[e.RowIndex].Cells[i].Controls[3];
                if (_editControl.Visible)
                {
                    int _dataTableColumnIndex = i - 1;

                    try
                    {
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("NOMORLabel");
                        int id = int.Parse(idLabel.Text);
                        System.Data.DataTable dt = _ReviewerData;
                        System.Data.DataRow dr = dt.Rows.Find(id);
                        dr.BeginEdit();
                        if (_editControl is TextBox)
                        {
                            dr[_dataTableColumnIndex] = ((TextBox)_editControl).Text;
                        }
                        else if (_editControl is DropDownList)
                        {
                            dr[_dataTableColumnIndex] = ((DropDownList)_editControl).SelectedValue.Split('|')[0];
                            dr[_dataTableColumnIndex + 1] = ((DropDownList)_editControl).SelectedValue.Split('|')[1];
                        }
                        else if (_editControl is CheckBox)
                        {
                            dr[_dataTableColumnIndex] = ((CheckBox)_editControl).Checked;
                        }
                        dr.EndEdit();

                        _ReviewerData = dt;

                        _gridView.SelectedIndex = -1;

                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        _gridView.DataSource = _ReviewerData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    private System.Data.DataTable _ReviewerData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["ReviewerData"];

            if (dt == null)
            {
                dt = new System.Data.DataTable();

                dt.Columns.Add(new System.Data.DataColumn("NOMOR", typeof(int)));
                dt.Columns.Add(new System.Data.DataColumn("REVNM", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("PERNR", typeof(string)));

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

    protected void btnAddData_Click(object sender, EventArgs e)
    {
        System.Data.DataTable dt = _ReviewerData;
        int newid = dt.Rows.Count + 1;
        dt.Rows.Add(new object[] { newid, "" , "" });
        _ReviewerData = dt;

        this.GridView1.DataSource = _ReviewerData;
        this.GridView1.DataBind();
    }

    DropDownList ddlSample = new DropDownList();
    
    protected DropDownList GetReviewer(string COCTR)
    {
        ddlSample.Items.Clear();
        int SEQ1 = 1;
        foreach (object[] data in BioPM.ClassObjects.UserCatalog.GetKadivCostCenter(COCTR))
        {
            ddlSample.Items.Add(new ListItem(SEQ1.ToString() + ". " + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString() + "|" + data[2].ToString()));
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
            ddlSample.Items.Add(new ListItem(SEQ1.ToString() + "." + SEQ2.ToString() + ". " + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString() + "|" + data[2].ToString()));
            GetReviewerKasi(data[4].ToString(), SEQ1, SEQ2);
            SEQ2++;
        }
    }

    protected void GetReviewerKasi(string COCTR, int SEQ1, int SEQ2)
    {
        int SEQ3 = 1;
        foreach (object[] data in BioPM.ClassObjects.UserCatalog.GetKasiByCostCenter(COCTR))
        {
            ddlSample.Items.Add(new ListItem(SEQ1.ToString() + "." + SEQ2.ToString() + "." + SEQ3.ToString() + "." + data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString(), data[0].ToString() + " " + data[1].ToString() + " - " + data[3].ToString() + "|" + data[2].ToString()));
            SEQ3++;
        }
    }
    
    protected void GenerateDataReviewer(string PRTID)
    {
        int index = 1;
        _ReviewerData = null;
        foreach (object[] data in BioPM.ClassObjects.LabelCatalog.GetPrintApproverByIDAndType(PRTID, "1"))
        {
            System.Data.DataTable dt = _ReviewerData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { index.ToString(), data[3].ToString(), data[2].ToString() });
            index++;
            _ReviewerData = dt;
        }
        this.GridView1.DataSource = _ReviewerData;
        this.GridView1.DataBind();
    }
    
    protected void UpdateLabelPrintData()
    {
        object[] values = BioPM.ClassObjects.LabelCatalog.GetBatchDetailByBatch(ddlBatch.SelectedValue);
        BioPM.ClassObjects.LabelCatalog.UpdateLabelPrintData(Request.QueryString["key"], ddlBatch.SelectedValue, txtPrintStatus.Text == "First-Print" ? "" : "X", txtQuantity.Text, txtRequestDate.Text, values[4].ToString(), "", "", "", Session["username"].ToString());
    }
    
    protected void InsertLabelPrintFlow()
    {
        for (int i = 0; i < _ReviewerData.Rows.Count; i++)
        {
            if ((BioPM.ClassObjects.LabelCatalog.ValidatePrintFlow(Request.QueryString["key"], _ReviewerData.Rows[i]["PERNR"].ToString()) == 0))
                BioPM.ClassObjects.LabelCatalog.InsertLabelPrintFlow(Request.QueryString["key"], "1", "PENDING", _ReviewerData.Rows[i]["PERNR"].ToString(), "", Session["username"].ToString());
        }
    }

    protected void GenerateExistingBatch()
    {
        ddlBatch.Items.Clear();
        foreach (object[] data in BioPM.ClassObjects.LabelCatalog.GetLabelBatchs())
        {
            ddlBatch.Items.Add(new ListItem(data[0].ToString(), data[0].ToString()));
        }
    }

    protected void SetDataToForm()
    {
        GenerateExistingBatch();
        GenerateDataReviewer(Request.QueryString["key"]);
        object[] values = BioPM.ClassObjects.LabelCatalog.GetLabelPrintDataByPrintID(Request.QueryString["key"]);
        ddlBatch.SelectedValue = values[0].ToString();
        txtGin.Text = values[1].ToString();
        txtProductName.Text = values[2].ToString();
        txtProductionDate.Text = values[3].ToString();
        txtExpiredDate.Text = values[4].ToString();
        txtLabelName.Text = values[5].ToString();
        txtRequestDate.Text = values[6].ToString();
        txtPrintStatus.Text = values[7].ToString() == "" ? "First-Print" : "Re-Print";
        txtQuantity.Text = values[8].ToString();
        txtNumberOfLabel.Text = values[9].ToString();
        txtReason.Text = values[10].ToString();

        if (values[7].ToString() == "X")
        {
            lblNumberOfLabel.Visible = true;
            lblReason.Visible = true;
            txtNumberOfLabel.Visible = true;
            txtReason.Visible = true;
        }
    }
    
    protected void UpdateDropdownlistData()
    {
        object[] values = BioPM.ClassObjects.LabelCatalog.GetBatchDetailByBatch(ddlBatch.SelectedValue);
        txtGin.Text = values[1].ToString();
        txtProductName.Text = values[2].ToString();
        txtProductionDate.Text = values[3].ToString();
        txtExpiredDate.Text = values[4].ToString();
        txtLabelName.Text = values[5].ToString();
    }

    protected void ddlBatch_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack) UpdateDropdownlistData();   
    }
    
    protected void SetInitialData()
    {
        txtPrintStatus.Text = "First-Print";
    }
    
    protected void btnSave_Click(object sender, EventArgs e)
    {
        UpdateLabelPrintData();
        InsertLabelPrintFlow();
        Response.Redirect("PageLabelPrintRequest.aspx");
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
    
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>Label Print</title>
    
    <% Response.Write(BioPM.ClassScripts.StyleScripts.GetCoreStyle()); %>
    <% Response.Write(BioPM.ClassScripts.StyleScripts.GetGritterStyle()); %>
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
                        Print Request
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                       
                        <div class="form-group">
                            <label class="control-label col-md-3">REQUEST DATE</label>
                            <div class="col-md-4 col-lg-3">
                                <asp:TextBox ID="txtRequestDate" size="16" class="form-control form-control-inline input-medium default-date-picker" runat="server"></asp:TextBox>
                                <span class="help-block">Request Date Format : month-day-year e.g. 01-31-2014</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" class="col-sm-3 control-label"> BATCH </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:DropDownList ID="ddlBatch" AutoPostBack="true" OnSelectedIndexChanged="ddlBatch_SelectedIndexChanged" runat="server" class="form-control m-bot15"></asp:DropDownList>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" class="col-sm-3 control-label"> GIN </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                  <asp:Label ID="txtGin" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblProductName" class="col-sm-3 control-label"> PRODUCT NAME </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtProductName" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblProductionDate" class="col-sm-3 control-label"> PRODUCTION DATE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtProductionDate" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblExpiredDate" class="col-sm-3 control-label"> EXPIRED DATE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtExpiredDate" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblLabelName" class="col-sm-3 control-label"> LABEL NAME </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtLabelName" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblQuantity" class="col-sm-3 control-label"> QUANTITY NUMBER </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Textbox ID="txtQuantity" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblPrintStatus" class="col-sm-3 control-label"> PRINT STATUS </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtPrintStatus" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblNumberOfLabel" Visible="false" class="col-sm-3 control-label"> NUMBER OF LABEL </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtNumberOfLabel" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblReason" Visible="false" class="col-sm-3 control-label"> REASON </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtReason" TextMode="MultiLine" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="panel-group m-bot20" id="accordion">
                        
                            <div class="panel">
                                <div class="panel">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseFour">
                                                Label Approver
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseFour" class="panel-collapse collapse">
                                        <div class="panel-body">
                                            <div class="col-lg-3 col-md-4">
                                                <asp:Button ID="Button1" runat="server" OnClick="btnAddData_Click" Text="Add Data" class="btn btn-round btn-primary pull-right"  />
                                            </div>
                                            <div class="adv-table col-lg-6 col-md-4">
                                                <div class="clearfix">
                                            
                                                </div>
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
                                                <asp:TemplateField HeaderText="Approver"> 
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
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnSave" Visible="true" runat="server" Text="Save" OnClick="btnSave_Click"/>
                                <asp:Button class="btn btn-round btn-primary" ID="btnCancel" Visible="true" runat="server" Text="Cancel" OnClick="btnCancel_Click"/>
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
<% Response.Write(BioPM.ClassScripts.JS.GetGritterScript()); %>
</body>
</html>
