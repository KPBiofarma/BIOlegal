<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageQualityControlTransaction.aspx.cs" Inherits="BioPM.PageQualityControlTransaction" %>

<!DOCTYPE html>
<script runat="server">
    private const int _firstEditCellIndexBatch = 99;
    private const int _firstEditCellIndexReviewer = 2;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
       
        if (!IsPostBack)
        {
            
            _QCData = null;
            this.GridViewQC.DataSource = _QCData;
            this.GridViewQC.DataBind();

            _ProductionData = null;
            this.GridViewProduction.DataSource = _ProductionData;
            this.GridViewProduction.DataBind(); 
            
            _ReviewerData = null;
            this.GridView1.DataSource = _ReviewerData;
            this.GridView1.DataBind();

            SetDataToForm();
        }

        if (this.GridView1.SelectedIndex > -1)
        {
            this.GridView1.UpdateRow(this.GridView1.SelectedIndex, false);
        }
        if (this.GridViewQC.SelectedIndex > -1)
        {
            
            this.GridViewQC.UpdateRow(this.GridViewQC.SelectedIndex, false);
        }

        if (this.GridViewProduction.SelectedIndex > -1)
        {
            
            this.GridViewProduction.UpdateRow(this.GridViewProduction.SelectedIndex, false);
        }
        
    }


    protected override void Render(HtmlTextWriter writer)
    {
        
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
        dt.Rows.Add(new object[] { newid, "", "" });
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
        btnSave.Visible = false;
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

    protected void GenerateDataQC(string BATCH)
    {
        int index = 1;
        _QCData = null;
        foreach (object[] data in BioPM.ClassObjects.ProductionCatalog.GetDataProductQualityControlByBatch(BATCH))
        {
            System.Data.DataTable dt = _QCData;
            int newid = dt.Rows.Count + 1;
            dt.Rows.Add(new object[] { index.ToString(), data[2].ToString(), data[6].ToString(), data[10].ToString(), data[0].ToString(), data[3].ToString(), data[0].ToString() });
            index++;
            _QCData = dt;
        }
        this.GridViewQC.DataSource = _QCData;
        this.GridViewQC.DataBind();
    }

    protected void GenerateDataReviewer(string BATCH)
    {
        int index = 1;
        _ReviewerData = null;
        foreach (object[] data in BioPM.ClassObjects.ProductionCatalog.GetProductReviewerByBatchAndType(BATCH, "2"))
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
            txtProductStatus.Text = BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1") == null ? "IN PROCESS" : BioPM.ClassObjects.ProductionCatalog.GetProductionStatusByBatchAndUntype(BATCH, "1")[2].ToString().ToUpper();
            GenerateDataProduction(BATCH);
            GenerateDataQC(BATCH);
            GenerateDataReviewer(BATCH);
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
    
    protected void InsertQCResultIntoDatabase()
    {
        for (int i = 0; i < _QCData.Rows.Count; i++ )
        {
            if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionQualityControlResult(txtBatch.Text, _QCData.Rows[i]["QCTYP"].ToString(), _QCData.Rows[i]["QCSTY"].ToString()) >= 1)
            {
                if (BioPM.ClassObjects.ProductionCatalog.ValidateProductionQualityControlChanged(txtBatch.Text, _QCData.Rows[i]["QCTYP"].ToString(), _QCData.Rows[i]["QCSTY"].ToString(), ((TextBox)GridViewQC.Rows[i].FindControl("QCRESText")).Text) == 0)
                {
                    BioPM.ClassObjects.ProductionCatalog.UpdateProductionQualityControlResult(txtBatch.Text, _QCData.Rows[i]["QCTYP"].ToString(), _QCData.Rows[i]["QCSTY"].ToString(), ((TextBox)GridViewQC.Rows[i].FindControl("QCRESText")).Text, _QCData.Rows[i]["UNTID"].ToString(), "0", Session["username"].ToString());
                }
            }
            else
            {
                BioPM.ClassObjects.ProductionCatalog.InsertProductionQualityControlResult(txtBatch.Text, _QCData.Rows[i]["QCTYP"].ToString(), _QCData.Rows[i]["QCSTY"].ToString(), ((TextBox)GridViewQC.Rows[i].FindControl("QCRESText")).Text, _QCData.Rows[i]["UNTID"].ToString(), "0", Session["username"].ToString());
            }       
        }
    }

    protected void InsertProductionTransactionFlow()
    {
        for (int i = 0; i < _ReviewerData.Rows.Count; i++)
        {
            if ((BioPM.ClassObjects.ProductionCatalog.ValidateProductionFlow(txtBatch.Text, _ReviewerData.Rows[i]["PERNR"].ToString()) == 0 && txtProductStatus.Text == "IN PROCESS") || txtProductStatus.Text == "CORECTION")
                BioPM.ClassObjects.ProductionCatalog.InsertProductionTransactionFlow(txtBatch.Text, "2", "QUARANTINE", _ReviewerData.Rows[i]["PERNR"].ToString(), "", Session["username"].ToString());
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        InsertQCResultIntoDatabase();
        InsertProductionTransactionFlow();
        Response.Redirect("PageBatchProductQualityControl.aspx");
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("PageUserPanel.aspx");
    }
    
</script>

<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>Product Quality Control Transaction</title>

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
                        Product Quality Control Transaction
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
                                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                                            Quality Control
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapseTwo" class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <label class="col-sm-3 control-label"> </label>
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
                                                            <asp:TextBox ID="QCRESText" runat="server" Text='<%# Eval("QCRES") %>'></asp:TextBox>      
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
