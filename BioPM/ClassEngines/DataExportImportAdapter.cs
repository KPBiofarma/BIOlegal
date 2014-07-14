using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BioPM.ClassEngines
{
    public class DataImportFactory
    {
        public static DataSet ImportDataFromExcel(string filepath)
        {
            if (System.IO.File.Exists(filepath))
            {
                string connectionString = String.Format(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=""Excel 8.0;HDR=YES;IMEX=1"";", filepath);
                string query = String.Format("select * from [{0}$]", "Sheet1");
                OleDbDataAdapter dataAdapter = new OleDbDataAdapter(query, connectionString);
                DataSet dataSet = new DataSet();
                dataAdapter.Fill(dataSet);
                return dataSet;
            }
            else
            {
                return null;
            }
        }
    }

    

    public class DataExportFactory : DatabaseFactory
    {
        public static void ExportDataToSqlServerForRiskAct(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO biolegal.RISK_ACTIVITY (BEGDA, ENDDA, ACTID, ACTNM, CHGDT, USRDT) 
                                VALUES('" + "03/07/2014 " + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][0].ToString() + "','" + data.Tables[0].Rows[i][1].ToString() + "', GETDATE(), 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForUserRole(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.USER_ROLE (BEGDA, ENDDA, APPID, ROLID, ROLNM, MENID, ACCID, CHGDT, USRDT) 
                                VALUES('" + "01/01/2014" + "','" + "12/31/2014" + "','" + data.Tables[0].Rows[i][1].ToString() + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + data.Tables[0].Rows[i][5].ToString() + "', GETDATE(), 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForApplication(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.USER_APPLICATION (BEGDA, ENDDA, APPGR, APPID, APPNM, CHGDT, USRDT) 
                                VALUES('" + "01/01/2014" + "','" + "12/31/2014" + "','" + data.Tables[0].Rows[i][0].ToString() + "','" + data.Tables[0].Rows[i][1].ToString() + "','" + data.Tables[0].Rows[i][2].ToString() + "', GETDATE(), 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForMenuApp(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.USER_MENU (BEGDA, ENDDA, APPID, MENID, MENAM, MNURL, MNPID, MNSEQ, MNICO, CHGDT, USRDT) 
                                VALUES('" + "01/01/2014" + "','" + "12/31/2014" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][8].ToString() + "','" + data.Tables[0].Rows[i][6].ToString() + "','" + data.Tables[0].Rows[i][7].ToString() + "','" + data.Tables[0].Rows[i][9].ToString() + "','" + data.Tables[0].Rows[i][10].ToString() + "','" + data.Tables[0].Rows[i][11].ToString() + "', GETDATE(), 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }
        public static void ExportDataToSqlServerForFormula(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.FORMULA (BEGDA, ENDDA, PRDID, QCFLG, ITMID, NOQTY, STYID, UNTID, CHGDT, USRDT) 
                                VALUES(GETDATE(), '12/31/9999', '30.03.001', '','" + data.Tables[0].Rows[i][0].ToString() + "','" + data.Tables[0].Rows[i][2].ToString() + "','','" + data.Tables[0].Rows[i][3].ToString() + "', GETDATE(),'" + "K495" + "')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForItemERP(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO dbo.Barang_ERP (KodeBarang, NamaBarang, Satuan, KodeKategori, Status, InventoryUnit, PurchaseUnitId) VALUES('" + data.Tables[0].Rows[i][0].ToString() + "','" + data.Tables[0].Rows[i][1].ToString() + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + data.Tables[0].Rows[i][6].ToString() + "','" + data.Tables[0].Rows[i][7].ToString() + "')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForItemERP2(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO dbo.Barang_ERP2 (KodeBarang, NamaBarang, Satuan, KodeKategori, Status) VALUES('" + data.Tables[0].Rows[i][0].ToString() + "','" + data.Tables[0].Rows[i][1].ToString() + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForCostCenter(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                string date = DateTime.Today.ToString("MM/dd/yyyy");
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO biopm.COST_CENTER (BEGDA, ENDDA, COCTR, COCNM, CHGDT, USRDT) VALUES('" + "01/01/2014" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + data.Tables[0].Rows[i][0].ToString() + "','" + date + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForVaccineGroup(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.VACCINE_GROUP (BEGDA, ENDDA, VACGR, VACNM, ALIAS, CHGDT, USRDT) VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + "04/28/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForProductType(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.PRODUCT_TYPE (BEGDA, ENDDA, PRDTY, PRTNM, ALIAS, CHGDT, USRDT) VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + "04/28/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForProductGroup(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.PRODUCT_GROUP (BEGDA, ENDDA, PRDGR, PRGNM, ALIAS, VACGR, CHGDT, USRDT) VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + data.Tables[0].Rows[i][5].ToString() + "','" + "04/28/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForProduct(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.PRODUK (BEGDA, ENDDA, PRDGR, PRDID, PRDNM, ALIAS, UNTID, PRSPC, PRSTO, PRDTY, CHGDT, USRDT) 
                                VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + data.Tables[0].Rows[i][5].ToString() + "','" + data.Tables[0].Rows[i][6].ToString() + "','" + data.Tables[0].Rows[i][7].ToString() + "','" + data.Tables[0].Rows[i][8].ToString() + "','" + data.Tables[0].Rows[i][9].ToString() + "','" + "04/28/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForQCType(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO biopm.QC_TYPE (BEGDA, ENDDA, QCTYP, QCTNM, ALIAS, CHGDT, USRDT) VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + "04/28/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForQC(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO biopm.QC_REFERENSI_PRODUK (BEGDA, ENDDA, PRDID, QCTYP, QCSTY, QCSNM, ALIAS, QCREQ, QCSYA, QCMIN, QCMAX, CHGDT, USRDT) 
                VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + data.Tables[0].Rows[i][5].ToString() + "','" + data.Tables[0].Rows[i][6].ToString() + "','" + data.Tables[0].Rows[i][7].ToString() + "','" + data.Tables[0].Rows[i][8].ToString() + "','" + data.Tables[0].Rows[i][9].ToString() + "','" + data.Tables[0].Rows[i][10].ToString() + "','" + "04/28/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForItem(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.ITEM (BEGDA, ENDDA, ITMID, ITMNM, ITMGR, UNTID, CHGDT, USRDT) 
                                VALUES('" + "01/01/2013" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + data.Tables[0].Rows[i][6].ToString() + "','" + data.Tables[0].Rows[i][7].ToString() + "','" + "04/29/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForItemGroup(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.ITEM_GROUP (BEGDA, ENDDA, ITMGR, ITGNM, CHGDT, USRDT) 
                                VALUES('" + "01/01/2013" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + "04/29/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForVendor(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.VENDOR (BEGDA, ENDDA, VDRGR, VDRID, VDRNM, CHGDT, USRDT) 
                                VALUES ('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + "04/29/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForVendorGroup(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.VENDOR_GROUP (BEGDA, ENDDA, VDRGR, VDGNM, CHGDT, USRDT) 
                                VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + "04/29/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        public static void ExportDataToSqlServerForStyle(DataSet data)
        {
            for (int i = 0; i < data.Tables[0].Rows.Count; i++)
            {
                SqlConnection conn = GetConnection();
                string sqlCmd = @"INSERT INTO bioumum.PABRIKAN (BEGDA, ENDDA, ITMID, STYID, STYNM, CHGDT, USRDT) 
                                VALUES('" + "01/01/2000" + "','" + "12/31/9999" + "','" + data.Tables[0].Rows[i][2].ToString() + "','" + data.Tables[0].Rows[i][3].ToString() + "','" + data.Tables[0].Rows[i][4].ToString() + "','" + "04/29/2014" + "', 'K495')";
                SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

    }
}