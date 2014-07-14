using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BioPM.ClassEngines
{
    public partial class PageDataExport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataSet data = DataImportFactory.ImportDataFromExcel("C:\\Users\\Public\\Documents\\KP\\Excel Data\\Data Risk Activity.xlsx");
            if (data != null)
            {
                DataExportFactory.ExportDataToSqlServerForRiskAct(data);
                Response.Write("Export Successed!");
            }
            else
            {
                Response.Write("Export Failed!");
            }
        }
    }
}