<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageProductionTransaction.aspx.cs" Inherits="BioPM.PageProductionTransaction" %>

<!DOCTYPE html>
<script runat="server">
    private const int _firstEditCellIndexBatch = 99;
    private const int _firstEditCellIndexReviewer = 2;
   
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["coctr"].ToString() != "64100") Response.Redirect("PageUserPanel.aspx");
        
        if (!IsPostBack)
        {
            _FormulaData = null;
            this.GridViewFormula.DataSource = _FormulaData;
            this.GridViewFormula.DataBind();

            _ProductionData = null;
            this.GridViewProduction.DataSource = _ProductionData;
            this.GridViewProduction.DataBind();
            
            _ReviewerData = null;
            this.GridView1.DataSource = _ReviewerData;
            this.GridView1.DataBind();

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

        if (this.GridView1.SelectedIndex > -1)
        {
            this.GridView1.UpdateRow(this.GridView1.SelectedIndex, false);
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

    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
        Session["coctr"] = "64100";
    }

    protected void GridViewFormula_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LinkButton _singleClickButton = (LinkButton)e.Row.Cells[0].Controls[0];
            string _jsSingle = ClientScript.GetPostBackClientHyperlink(_singleClickButton, "");
            
            if (Page.Validators.Count > 0) _jsSingle = _jsSingle.Insert(11, "if(Page_ClientValidate())");

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
        btnSave.Visible = true;
        btnCancel.Visible = true;
        ddlUnit.Visible = true;
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
        btnSave.Visible = false;
        btnCancel.Visible = false;
        ddlUnit.Visible = false;
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
            dt.Rows.Add(new object[] { index.ToString(), data[0].ToString(), data[1].ToString(), Convert.ToDecimal(data[2]).ToString("F"), data[3].ToString(), data[4].ToString() });
            index++;
            _FormulaData = dt;
        }
        this.GridViewFormula.DataSource = _FormulaData;
        this.GridViewFormula.DataBind();
    }

    protected void GenerateDataReviewer(string BATCH)
    {
        int index = 1;
        _ReviewerData = null;
        foreach (object[] data in BioPM.ClassObjects.ProductionCatalog.GetProductReviewerByBatchAndType(BATCH, "1"))
        {
            System.Data.DataTable dt = _ReviewerData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { index.ToString(), data[4].ToString(), data[2].ToString() });
            index++;
            _ReviewerData = dt;
        }
        this.GridView1.DataSource = _ReviewerData;
        this.GridView1.DataBind();
    }
    
    protected void SetUnitToDropdownlist()
    {
        ddlUnit.Items.Clear();
        foreach(string data in BioPM.ClassObjects.ProductionCatalog.GetProductUnit())
        {
            ddlUnit.Items.Add(new ListItem(data, data));
        }
    }
    
    protected void SetDataToForm()
    {
        string BATCH = Request.QueryString["key"];
        SetUnitToDropdownlist();
        
        if (BioPM.ClassObjects.ProductionCatalog.ValidateProductBatch(BATCH) >= 1)
        {
            object[] values = BioPM.ClassObjects.ProductionCatalog.GetProductBatchByBatch(BATCH);
            txtBatch.Text = values[1].ToString();
            Session["PRDID"] = values[2].ToString();
            txtProductName.Text = values[3].ToString();
            txtProductionDate.Text = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[0].ToString());
            txtProductStatus.Text = BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatch(BATCH, "2") == null ? "QUARANTINE" : BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatch(BATCH, "2")[2].ToString().ToUpper();
            GenerateDataProduction(BATCH);
            GenerateDataFormula(BATCH);
            GenerateDataReviewer(BATCH);
        }

        if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionBatch(BATCH) >= 1)
        {
            object[] values = BioPM.ClassObjects.ProductionCatalog.GetProductionByBatch(BATCH);
            txtQuantity.Text = Convert.ToDecimal(values[6].ToString()).ToString("F");
            ddlUnit.SelectedValue = values[7].ToString();
            txtPackage.Text = values[4].ToString();
            txtStorage.Text = values[5].ToString();
            txtExpiredDate.Text = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[1].ToString());
        }
        
        SetLabelVisible();
    }

    protected void ValidateInputHeader()
    {
        
    }
    
    protected void ValidateInputProductionFormula()
    {
        
    }
    
    protected void InsertDataProductionIntoDatabase()
    {
        string BEGDA = BioPM.ClassEngines.DateFormatFactory.GetMonthFromEnum(txtProductionDate.Text.Split(' ')[1]) + "/" + txtProductionDate.Text.Split(' ')[0] + "/" + txtProductionDate.Text.Split(' ')[2];
        string ENDDA = BioPM.ClassEngines.DateFormatFactory.GetMonthFromEnum(txtExpiredDate.Text.Split(' ')[1]) + "/" + txtExpiredDate.Text.Split(' ')[0] + "/" + txtExpiredDate.Text.Split(' ')[2];
        if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionBatch(txtBatch.Text) >= 1)
        {
            BioPM.ClassObjects.ProductionCatalog.UpdateDataProduction(ENDDA, txtBatch.Text, Session["PRDID"].ToString(), txtPackage.Text, txtQuantity.Text, ddlUnit.SelectedValue, Session["username"].ToString());
        }
        else
        {
            BioPM.ClassObjects.ProductionCatalog.InsertDataProduction(BEGDA, ENDDA, txtBatch.Text, Session["PRDID"].ToString(), txtPackage.Text, txtQuantity.Text, ddlUnit.SelectedValue, Session["username"].ToString());
        }
    }

    protected void InsertDataProductionFormulaIntoDatabase()
    {
        for(int i = 0; i < _FormulaData.Rows.Count; i++)
        {
            if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionFormula(txtBatch.Text, _FormulaData.Rows[i]["ITMID"].ToString()) >= 1)
            {
                if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionFormulaChanged(txtBatch.Text, _FormulaData.Rows[i]["ITMID"].ToString(), ((TextBox)GridViewFormula.Rows[i].FindControl("NOQPRLabel")).Text) == 0)
                {
                    BioPM.ClassObjects.ProductionCatalog.UpdateProductionFormula(txtBatch.Text, _FormulaData.Rows[i]["ITMID"].ToString(), ((TextBox)GridViewFormula.Rows[i].FindControl("NOQPRLabel")).Text == "" ? "0" : ((TextBox)GridViewFormula.Rows[i].FindControl("NOQPRLabel")).Text, "0", Session["username"].ToString());
                }
            }
            else
            {
                BioPM.ClassObjects.ProductionCatalog.InsertProductionFormula(txtBatch.Text, _FormulaData.Rows[i]["ITMID"].ToString(), ((TextBox)GridViewFormula.Rows[i].FindControl("NOQPRLabel")).Text == "" ? "0" : ((TextBox)GridViewFormula.Rows[i].FindControl("NOQPRLabel")).Text, "0", Session["username"].ToString());
            }
        }
    }
    
    protected void InsertProductionTransactionFlow()
    {
        for (int i = 0; i < _ReviewerData.Rows.Count; i++)
        {
            if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionFlow(txtBatch.Text, _ReviewerData.Rows[i]["PERNR"].ToString()) == 0 && BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatch(txtBatch.Text, "2")[2].ToString().ToUpper() == "QUARANTINE")
            BioPM.ClassObjects.ProductionCatalog.InsertProductionTransactionFlow(txtBatch.Text, "1", "QUARANTINE", _ReviewerData.Rows[i]["PERNR"].ToString(), "", Session["username"].ToString());
        }
    }
    
    protected void btnSave_Click(object sender, EventArgs e)
    {
        InsertDataProductionIntoDatabase();
        InsertDataProductionFormulaIntoDatabase();
        InsertProductionTransactionFlow();
        Response.Redirect("PageBatchProductProduction.aspx");
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
                            <asp:Label runat="server" class="col-sm-3 control-label"> PRODUCT BATCH </asp:Label>
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
                                <asp:Textbox ID="txtProductName" Visible="false" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblProductionDate" Visible="false" class="col-sm-3 control-label"> PRODUCTION DATE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Textbox ID="txtProductionDate" Visible="false" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <asp:Label runat="server" ID="lblQuantity" Visible="false" class="col-sm-3 control-label"> QUANTITY </asp:Label>
                            <div class="col-lg-2 col-md-3">
                                <asp:Textbox ID="txtQuantity" Visible="false" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                            <div class="col-lg-1 col-md-1">
                                <asp:DropDownList ID="ddlUnit" Visible="false" runat="server" class="form-control m-bot15"></asp:DropDownList>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblPackage" Visible="false" class="col-sm-3 control-label"> PRESENTATION </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Textbox ID="txtPackage" Visible="false" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblStorage" Visible="false" class="col-sm-3 control-label"> STORAGE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Textbox ID="txtStorage" Visible="false" runat="server" class="form-control m-bot15"></asp:Textbox>
                            </div>
                        </div>

                        <div class="form-group">
                            <asp:Label runat="server" ID="lblExpiredDate" Visible="false" class="col-sm-3 control-label"> EXPIRED DATE </asp:Label>
                            <div class="col-lg-3 col-md-4">
                                <asp:Textbox ID="txtExpiredDate" Visible="false" runat="server" class="form-control m-bot15"></asp:Textbox>
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
                                        <label class="col-sm-3 control-label"> </label>
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
                                                </Columns> 
                                            </asp:GridView>     
                                    </div>
                                    </div>
                                </div>
                                <div class="panel">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseFour">
                                                Production Reviewer
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
                                    </div>
                                </div>

                            </div>
                        </div>
                    
                        <%--<div class="form-group">
                            <div class="col-lg-3 col-md-4">
                                            <asp:Button ID="btnAddData" runat="server" OnClick="btnAddData_Click" Text="Add Data" class="btn btn-round btn-primary pull-right"  />
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
                        </div>--%>

                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-lg-3 col-md-3">
                                <asp:Button class="btn btn-round btn-primary" ID="btnSave" Visible="false" runat="server" Text="Save" OnClick="btnSave_Click"/>
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
