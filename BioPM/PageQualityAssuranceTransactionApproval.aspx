﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageQualityAssuranceTransactionApproval.aspx.cs" Inherits="BioPM.PageQualityAssuranceTransactionApproval" %>

<!DOCTYPE html>
<script runat="server">
    private const int _firstEditCellIndexBatch = 99, _firstEditCellIndexReviewer = 2;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        
        if (!IsPostBack)
        {
            _FormulaData = null;
            this.GridViewFormula.DataSource = _FormulaData;
            this.GridViewFormula.DataBind();
            
            _QCData = null;
            this.GridViewQC.DataSource = _QCData;
            this.GridViewQC.DataBind();

            _ProductionData = null;
            this.GridViewProduction.DataSource = _ProductionData;
            this.GridViewProduction.DataBind();

            SetDataToForm();
        }

        if (this.GridViewFormula.SelectedIndex > -1)
        {
            this.GridViewFormula.UpdateRow(this.GridViewFormula.SelectedIndex, false);
        }

        if (this.GridViewProduction.SelectedIndex > -1)
        {
            
            this.GridViewProduction.UpdateRow(this.GridViewProduction.SelectedIndex, false);
        }

        if (this.GridViewQC.SelectedIndex > -1)
        {
            
            this.GridViewQC.UpdateRow(this.GridViewQC.SelectedIndex, false);
        }

    }


    protected override void Render(HtmlTextWriter writer)
    {
        

        foreach (GridViewRow r in GridViewFormula.Rows)
        {
            if (r.RowType == DataControlRowType.DataRow)
            {
                for (int columnIndex = _firstEditCellIndexBatch; columnIndex < r.Cells.Count; columnIndex++)
                {
                    Page.ClientScript.RegisterForEventValidation(r.UniqueID + "$ctl00", columnIndex.ToString());
                }
            }
        }
        
        foreach (GridViewRow r in GridViewQC.Rows)
        {
            if (r.RowType == DataControlRowType.DataRow)
            {
                for (int columnIndex = _firstEditCellIndexBatch; columnIndex < r.Cells.Count; columnIndex++)
                {
                    Page.ClientScript.RegisterForEventValidation(r.UniqueID + "$ctl00", columnIndex.ToString());
                }
            }
        }

        foreach (GridViewRow r in GridViewProduction.Rows)
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
        Session["coctr"] = "64100";
    }

    protected void GridViewQC_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            
           
            
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

    protected void GridViewQC_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        switch (e.CommandName)
        {
            case ("SingleClick"):
                
                int _rowIndex = int.Parse(e.CommandArgument.ToString());
                
                int _columnIndex = int.Parse(Request.Form["__EVENTARGUMENT"]);
                
                _gridView.SelectedIndex = _rowIndex;
                
                _gridView.DataSource = _QCData;
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

    
    
    
    
    
    protected void GridViewQC_RowUpdating(object sender, GridViewUpdateEventArgs e)
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
                        
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("NOQCTLabel");
                        string id = idLabel.Text;
                        
                        System.Data.DataTable dt = _QCData;
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

                        
                        _QCData = dt;

                        
                        
                        _gridView.SelectedIndex = -1;

                        
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        
                        

                        
                        _gridView.DataSource = _QCData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    
    
    
    private System.Data.DataTable _QCData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["QCData"];

            if (dt == null)
            {
                
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("NOQCT", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("ALIAS", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("QCREQ", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("QCRES", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("QCTYP", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("QCSTY", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("UNTID", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("QCVAL", typeof(string)));

                
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["NOQCT"];
                dt.PrimaryKey = keys;

                _QCData = dt;
            }

            return dt;
        }
        set
        {
            Session["QCData"] = value;
        }
    }


    protected void GridViewProduction_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {


            
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

    protected void GridViewProduction_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        switch (e.CommandName)
        {
            case ("SingleClick"):
                
                int _rowIndex = int.Parse(e.CommandArgument.ToString());
                
                int _columnIndex = int.Parse(Request.Form["__EVENTARGUMENT"]);
                
                _gridView.SelectedIndex = _rowIndex;
                
                _gridView.DataSource = _ProductionData;
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

    
    
    
    
    
    protected void GridViewProduction_RowUpdating(object sender, GridViewUpdateEventArgs e)
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
                        
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("NOPRDLabel");
                        string id = idLabel.Text;
                        
                        System.Data.DataTable dt = _ProductionData;
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

                        
                        _ProductionData = dt;

                        
                        
                        _gridView.SelectedIndex = -1;

                        
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {
                        
                        

                        
                        _gridView.DataSource = _ProductionData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    
    
    
    private System.Data.DataTable _ProductionData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["ProductionData"];

            if (dt == null)
            {
                
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("NOPRD", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("BATCH", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("BEGDA", typeof(string)));
    
                
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["NOPRD"];
                dt.PrimaryKey = keys;

                _ProductionData = dt;
            }

            return dt;
        }
        set
        {
            Session["ProductionData"] = value;
        }
    }

    protected void GridViewFormula_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {


            
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

    protected void GridViewFormula_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridView _gridView = (GridView)sender;

        switch (e.CommandName)
        {
            case ("SingleClick"):
                
                int _rowIndex = int.Parse(e.CommandArgument.ToString());
                
                int _columnIndex = int.Parse(Request.Form["__EVENTARGUMENT"]);
                
                _gridView.SelectedIndex = _rowIndex;
                
                _gridView.DataSource = _FormulaData;
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

    
    
    
    
    
    protected void GridViewFormula_RowUpdating(object sender, GridViewUpdateEventArgs e)
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
                        
                        Label idLabel = (Label)_gridView.Rows[e.RowIndex].FindControl("NOFRMLabel");
                        string id = idLabel.Text;
                        
                        System.Data.DataTable dt = _FormulaData;
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

                        
                        _FormulaData = dt;

                        
                        
                        _gridView.SelectedIndex = -1;

                        
                        _gridView.DataSource = dt;
                        _gridView.DataBind();
                    }
                    catch (ArgumentException)
                    {

                        
                        _gridView.DataSource = _FormulaData;
                        _gridView.DataBind();
                    }
                }
            }
        }
    }

    
    
    
    private System.Data.DataTable _FormulaData
    {
        get
        {
            System.Data.DataTable dt = (System.Data.DataTable)Session["FormulaData"];

            if (dt == null)
            {
                
                dt = new System.Data.DataTable();
                dt.Columns.Add(new System.Data.DataColumn("NOFRM", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("ITMID", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("ITMNM", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("NOQTY", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("NOQPR", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("UNTID", typeof(string)));
                dt.Columns.Add(new System.Data.DataColumn("FRVAL", typeof(string)));

                
                System.Data.DataColumn[] keys = new System.Data.DataColumn[1];
                keys[0] = dt.Columns["NOFRM"];
                dt.PrimaryKey = keys;

                _FormulaData = dt;
            }

            return dt;
        }
        set
        {
            Session["FormulaData"] = value;
        }
    }

    protected void SetLabelVisible()
    {
        lblProductName.Visible = true;
        lblProductStatus.Visible = true;
        lblQuantity.Visible = true;
        lblStorage.Visible = true;
        lblPackage.Visible = true;
        lblProductionDate.Visible = true;
        lblExpiredDate.Visible = true;
        txtProductName.Visible = true;
        txtProductStatus.Visible = true;
        txtQuantity.Visible = true;
        txtPackage.Visible = true;
        txtStorage.Visible = true;
        txtProductionDate.Visible = true;
        txtExpiredDate.Visible = true;
        btnCancel.Visible = true;
        txtUnit.Visible = true;
    }

    protected void SetLabelInvisible()
    {
        lblProductName.Visible = false;
        lblProductStatus.Visible = false;
        lblQuantity.Visible = false;
        lblStorage.Visible = false;
        lblPackage.Visible = false;
        lblProductionDate.Visible = false;
        lblExpiredDate.Visible = false;
        txtProductName.Visible = false;
        txtProductStatus.Visible = false;
        txtQuantity.Visible = false;
        txtPackage.Visible = false;
        txtStorage.Visible = false;
        txtProductionDate.Visible = false;
        txtExpiredDate.Visible = false;
        btnCancel.Visible = false;
        txtUnit.Visible = false;
    }

    protected void GenerateDataProduction(string BATCH)
    {
        int index = 1;
        _ProductionData = null;
        foreach (object[] data in BioPM.ClassObjects.ProductionCatalog.GetProductProductionByBatch(BATCH))
        {
            System.Data.DataTable dt = _ProductionData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { index.ToString(), data[2].ToString(), BioPM.ClassEngines.DateFormatFactory.GetDateFormat(data[0].ToString()) });
            index++;
            _ProductionData = dt;
        }
        this.GridViewProduction.DataSource = _ProductionData;
        this.GridViewProduction.DataBind();
    }

    protected void GenerateDataFormula(string BATCH)
    {
        int index = 1;
        _FormulaData = null;
        foreach (object[] data in BioPM.ClassObjects.ProductionCatalog.GetProductionFormulaByBatch(BATCH))
        {
            System.Data.DataTable dt = _FormulaData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { index.ToString(), data[0].ToString(), data[1].ToString(), Convert.ToDecimal(data[2]).ToString("F"), data[3].ToString(), data[4].ToString(), data[5].ToString() == "1" ? "true" : "false" });
            index++;
            _FormulaData = dt;
        }
        this.GridViewFormula.DataSource = _FormulaData;
        this.GridViewFormula.DataBind();
    }

    protected void GenerateDataQC(string BATCH)
    {
        int index = 1;
        _QCData = null;
        foreach (object[] data in BioPM.ClassObjects.ProductionCatalog.GetDataProductQualityControlByBatch(BATCH))
        {
            System.Data.DataTable dt = _QCData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { index.ToString(), data[2].ToString(), data[6].ToString(), data[10].ToString(), data[0].ToString(), data[3].ToString(), data[0].ToString(), data[12].ToString() == "1" ? "true" : "false" });
            index++;
            _QCData = dt;
        }
        this.GridViewQC.DataSource = _QCData;
        this.GridViewQC.DataBind();
    }

    protected void SetDataToForm()
    {
        string BATCH = Request.QueryString["key"];

        if (BioPM.ClassObjects.ProductionCatalog.ValidateProductBatch(BATCH) >= 1)
        {
            object[] values = BioPM.ClassObjects.ProductionCatalog.GetProductBatchByBatch(BATCH);
            txtBatch.Text = values[1].ToString();
            Session["PRDID"] = values[2].ToString();
            txtProductName.Text = values[3].ToString();
            txtProductionDate.Text = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[0].ToString());
            txtProductStatus.Text = BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1") == null ? "QUARANTINE" : BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1")[2].ToString().ToUpper();
            GenerateDataProduction(BATCH);
            GenerateDataFormula(BATCH);
            GenerateDataQC(BATCH);
        }

        if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionBatch(BATCH) >= 1)
        {
            object[] values = BioPM.ClassObjects.ProductionCatalog.GetProductionByBatch(BATCH);
            txtQuantity.Text = Convert.ToDecimal(values[6].ToString()).ToString("F");
            txtUnit.Text = values[7].ToString();
            txtPackage.Text = values[4].ToString();
            txtStorage.Text = values[5].ToString();
            txtExpiredDate.Text = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[1].ToString());
        }

        SetLabelVisible();
    }

    protected void InsertProductionTransactionFlow()
    {
        BioPM.ClassObjects.ProductionCatalog.InsertProductionTransactionFlow(txtBatch.Text, "3", ddlApprovalStatus.SelectedValue, Session["username"].ToString().ToString(), txtNote.Text, Session["username"].ToString());
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Session["password"].ToString() == BioPM.ClassEngines.CryptographFactory.Encrypt(txtConfirmation.Text, true))
        {
            InsertProductionTransactionFlow();
            Response.Redirect("PageBatchProductQualityAssuranceApproval.aspx");
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + "YOUR PASSWORD IS INCORRECT" + "');", true);
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
    
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>Product Transaction</title>

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
                        Product Transaction
                          <span class="tools pull-right">
                            <a class="fa fa-chevron-down" href="javascript:;"></a>
                            <a class="fa fa-times" href="javascript:;"></a>
                         </span>
                    </header>
                    <div class="panel-body">
                        <form class="form-horizontal " runat="server" >
                       
                        <div class="form-group">
                            <asp:Label runat="server"  class="col-sm-3 control-label"> PRODUCT BATCH </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Textbox ID="txtBatch" AutoPostBack="true" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblProductStatus" Visible="false" class="col-sm-3 control-label"> STATUS </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Textbox ID="txtProductStatus" Visible="false" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblProductName" Visible="false" class="col-sm-3 control-label"> PRODUCT NAME </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtProductName" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblProductionDate" Visible="false" class="col-sm-3 control-label"> PRODUCTION DATE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtProductionDate" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <asp:Label runat="server" ID="lblQuantity" Visible="false" class="col-sm-3 control-label"> QUANTITY </asp:Label>
                            <div class="col-lg-2 col-md-3">
                                <asp:Label ID="txtQuantity" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                            <div class="col-lg-1 col-md-1">
                                <asp:Label ID="txtUnit" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblPackage" Visible="false" class="col-sm-3 control-label"> PACKAGING </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtPackage" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblStorage" Visible="false" class="col-sm-3 control-label"> STORAGE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtStorage" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblExpiredDate" Visible="false" class="col-sm-3 control-label"> EXPIRED DATE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Label ID="txtExpiredDate" Visible="false" runat="server" class="form-control m-bot15"></asp:Label>
                            </div>
                        </div>

                        <div class="panel-group m-bot20" id="accordion">
                        
                            <div class="panel">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                                            Production Data
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapseOne" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <label class="col-sm-3 control-label"> </label>
                                        <div class="adv-table col-lg-6 col-md-4">
                                        <div class="clearfix">
                                            
                                        </div>
                                        <asp:GridView ID="GridViewProduction" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                                                BorderStyle="Solid" BorderWidth="2px" CellPadding="4" ForeColor="Black" GridLines="Both"
                                                OnRowDataBound="GridViewProduction_RowDataBound" OnRowCommand="GridViewProduction_RowCommand" OnRowUpdating="GridViewProduction_RowUpdating" ShowFooter="True"> 
                                                <Columns>                 
                                                    <asp:ButtonField Text="SingleClick" CommandName="SingleClick" Visible="false"/> 
                                                    <asp:TemplateField HeaderText="No."> 
                                                        <ItemTemplate>
                                                            <asp:Label ID="NOPRDLabel" runat="server" Text='<%# Eval("NOPRD") %>'></asp:Label>    
                                                        </ItemTemplate>                
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="Batch"> 
                                                        <ItemTemplate>
                                                            <asp:Label ID="BATCHLabel" runat="server" Text='<%# Eval("BATCH") %>'></asp:Label>    
                                                        </ItemTemplate>                
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="Production Date"> 
                                                        <ItemTemplate> 
                                                            <asp:Label ID="BEGDALabel" runat="server" Text='<%# Eval("BEGDA") %>'></asp:Label>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns> 
                                            </asp:GridView>     
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
                                            Formula
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapseThree" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <div class="col-sm-3">
                                        
                                        </div>
                                        <div class="adv-table col-lg-6 col-md-4">
                                        <div class="clearfix">
                                            
                                        </div>
                                        <asp:GridView ID="GridViewFormula" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                                                BorderStyle="Solid" BorderWidth="2px" CellPadding="4" ForeColor="Black" GridLines="Both"
                                                OnRowDataBound="GridViewFormula_RowDataBound" OnRowCommand="GridViewFormula_RowCommand" OnRowUpdating="GridViewFormula_RowUpdating" ShowFooter="True"> 
                                                <Columns>                 
                                                    <asp:ButtonField Text="SingleClick" CommandName="SingleClick" Visible="false"/> 
                                                    <asp:TemplateField HeaderText="No."> 
                                                        <ItemTemplate>
                                                            <asp:Label ID="NOFRMLabel" runat="server" Text='<%# Eval("NOFRM") %>'></asp:Label>    
                                                        </ItemTemplate>                
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="Item ID"> 
                                                        <ItemTemplate>
                                                            <asp:Label ID="ITMIDLabel" runat="server" Text='<%# Eval("ITMID") %>'></asp:Label>    
                                                        </ItemTemplate>                
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="Item Name"> 
                                                        <ItemTemplate> 
                                                            <asp:Label ID="ITMNMLabel" runat="server" Text='<%# Eval("ITMNM") %>'></asp:Label>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="Quantity Reference"> 
                                                        <ItemTemplate> 
                                                            <asp:Label ID="NOQTYLabel" runat="server" Text='<%# Eval("NOQTY") %>'></asp:Label>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Quantity Production"> 
                                                        <ItemTemplate> 
                                                            <asp:TextBox ID="NOQPRLabel" runat="server" Text='<%# Eval("NOQPR") %>'></asp:TextBox>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Unit"> 
                                                        <ItemTemplate> 
                                                            <asp:Label ID="UNTIDLabel" runat="server" Text='<%# Eval("UNTID") %>'></asp:Label>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <%--<asp:TemplateField HeaderText="Review"> 
                                                        <ItemTemplate> 
                                                            <asp:CheckBox ID="FRVALReview" runat="server" Checked='<%# Convert.ToBoolean(Eval("FRVAL")) %>' class="switch-small"></asp:CheckBox>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>
                                                </Columns> 
                                            </asp:GridView>     
                                            </div>
                                        </div>
                                </div>
                            </div>
                            <div class="panel">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                                            Quality Control
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapseTwo" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <div class="col-sm-3">
                                        
                                        </div>
                                        <div class="adv-table col-lg-6 col-md-4">
                                        <div class="clearfix">
                                            
                                        </div>
                                            <asp:GridView ID="GridViewQC" runat="server" BackColor="White" BorderColor="#e9ecef" AutoGenerateColumns="False"  
                                                BorderStyle="Solid" BorderWidth="2px" CellPadding="4" ForeColor="Black" GridLines="Both"
                                                OnRowDataBound="GridViewQC_RowDataBound" OnRowCommand="GridViewQC_RowCommand" OnRowUpdating="GridViewQC_RowUpdating" ShowFooter="True"> 
                                                <Columns>                 
                                                    <asp:ButtonField Text="SingleClick" CommandName="SingleClick" Visible="false"/> 
                                                    <asp:TemplateField HeaderText="No."> 
                                                        <ItemTemplate>
                                                            <asp:Label ID="NOQCTLabel" runat="server" Text='<%# Eval("NOQCT") %>'></asp:Label>    
                                                        </ItemTemplate>                
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="QC Name"> 
                                                        <ItemTemplate>
                                                            <asp:Label ID="ALIASLabel" runat="server" Text='<%# Eval("ALIAS") %>'></asp:Label>    
                                                        </ItemTemplate>                
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="QC Requirement"> 
                                                        <ItemTemplate> 
                                                            <asp:Label ID="QCREQLabel" runat="server" Text='<%# Eval("QCREQ") %>'></asp:Label>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField> 
                                                    <asp:TemplateField HeaderText="QC Result"> 
                                                        <ItemTemplate> 
                                                            <asp:Label ID="QCRSTLabel" runat="server" Text='<%# Eval("QCRES") %>'></asp:Label>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField> 
                                                    <%--<asp:TemplateField HeaderText="Review"> 
                                                        <ItemTemplate> 
                                                            <asp:CheckBox ID="QCVALReview" runat="server" Checked='<%# Convert.ToBoolean(Eval("QCVAL")) %>' class="switch-small"></asp:CheckBox>      
                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>
                                                </Columns> 
                                            </asp:GridView>     
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Modal -->
                        <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="myModal" class="modal fade">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title">Reviewer Confirmation</h4>
                                    </div>
                                    <div class="modal-body">
                                        <p>You Are Logged In As <% Response.Write(Session["name"].ToString()); %></p>
                                        <asp:DropDownList ID="ddlApprovalStatus" runat="server" class="form-control m-bot15">
                                            <asp:ListItem Value="QA APPROVE">Approve</asp:ListItem> 
                                            <asp:ListItem Value="QA REJECT">Unapprove</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" placeholder="Your Note If Any" class="form-control placeholder-no-fix"></asp:TextBox>
                                        <p></p>
                                        <asp:TextBox ID="txtConfirmation" runat="server" TextMode="Password" placeholder="Confirmation Password" class="form-control placeholder-no-fix"></asp:TextBox>

                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="btnClose" runat="server" data-dismiss="modal" class="btn btn-default" Text="Cancel"></asp:Button>
                                        <asp:Button ID="btnSubmit" runat="server" class="btn btn-success" Text="Confirm" OnClick="btnSave_Click"></asp:Button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- modal -->

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:LinkButton data-toggle="modal" class="btn btn-round btn-primary" ID="btnAction" runat="server" Text="Approve" href="#myModal"/>
                                <asp:Button class="btn btn-round btn-primary" ID="btnCancel" Visible="false" runat="server" Text="Cancel" OnClick="btnCancel_Click"/>
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
