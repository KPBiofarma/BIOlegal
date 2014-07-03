using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BioPM.ClassObjects
{
    public class LabelCatalog : DatabaseFactory
    {
        public static void InsertLabel(string LBLID, string LBLNM, string LBLWD, string LBLLT, string SCTID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.LABEL (BEGDA, ENDDA, LBLID, LBLNM, LBLWD, LBLLT, SCTID, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + LBLID + "','" + LBLNM + "','" + LBLWD + "','" + LBLLT + "','" + SCTID + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateLabel(string LBLID, string LBLNM, string LBLWD, string LBLLT, string SCTID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.LABEL SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (LBLID = '" + LBLID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertLabel(LBLID, LBLNM, LBLWD, LBLLT, SCTID, USRDT);
            }
        }

        public static void DeleteLabel(string LBLID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.LABEL SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (LBLID = '" + LBLID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

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

        public static object[] GetLabelByID(string LBLID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LB.LBLID, LB.LBLNM, LB.LBLWD, LB.LBLLT, SC.SCTNM, SC.SCTID
                            FROM bioumum.LABEL LB, bioumum.LABEL_SUB_KATEGORI SC
                            WHERE LB.SCTID = SC.SCTID
                            AND LB.BEGDA <= GETDATE() AND LB.ENDDA >= GETDATE()
                            AND SC.BEGDA <= GETDATE() AND SC.ENDDA >= GETDATE() AND LB.LBLID = '" + LBLID + "'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetLabels()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LB.LBLID, LB.LBLNM, LB.LBLWD, LB.LBLLT, SC.SCTNM, SC.SCTID
                            FROM bioumum.LABEL LB, bioumum.LABEL_SUB_KATEGORI SC
                            WHERE LB.SCTID = SC.SCTID
                            AND LB.BEGDA <= GETDATE() AND LB.ENDDA >= GETDATE()
                            AND SC.BEGDA <= GETDATE() AND SC.ENDDA >= GETDATE()";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    data.Add(values);
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetLabelsByCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LB.LBLID, LB.LBLNM, LB.LBLWD, LB.LBLLT, SC.SCTNM, SC.SCTID
                            FROM bioumum.LABEL_COST_CENTER LC JOIN bioumum.LABEL LB ON LB.LBLID = LC.LBLID, bioumum.LABEL_SUB_KATEGORI SC
                            WHERE LC.BEGDA <= GETDATE() AND LC.ENDDA >= GETDATE() AND LB.SCTID = SC.SCTID
                            AND SUBSTRING(LC.COCTR, 1, 3) = '" + COCTR.Substring(0,3) + "'";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    data.Add(values);
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }
        

        public static void InsertLabelCategory(string CTGID, string CTGNM, string CTDET, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.LABEL_KATEGORI (BEGDA, ENDDA, CTGID, CTGNM, CTDET, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + CTGID + "','" + CTGNM + "','" + CTDET + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateLabelCategory(string CTGID, string CTGNM, string CTDET, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.LABEL_KATEGORI SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (CTGID = '" + CTGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertLabelCategory(CTGID, CTGNM, CTDET, USRDT);
            }
        }

        public static void DeleteLabelCategory(string CTGID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.LABEL_KATEGORI SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (CTGID = '" + CTGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

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

        public static object[] GetLabelCategoryByID(string CTGID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LK.CTGID, LK.CTGNM, LK.CTDET
                            FROM bioumum.LABEL_KATEGORI LK
                            WHERE LK.BEGDA <= GETDATE() AND LK.ENDDA >= GETDATE() AND LK.CTGID = '" + CTGID + "'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetLabelCategories()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LK.CTGID, LK.CTGNM, LK.CTDET
                            FROM bioumum.LABEL_KATEGORI LK
                            WHERE LK.BEGDA <= GETDATE() AND LK.ENDDA >= GETDATE()";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    data.Add(values);
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertLabelSubCategory(string SCTID, string SCTNM, string SCDET, string CTGID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.LABEL_SUB_KATEGORI (BEGDA, ENDDA, SCTID, SCTNM, SCDET, CTGID, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + SCTID + "','" + SCTNM + "','" + SCDET + "','" + CTGID + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateLabelSubCategory(string SCTID, string SCTNM, string SCDET, string CTGID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.LABEL_SUB_KATEGORI SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (SCTID = '" + SCTID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertLabelSubCategory(SCTID, SCTNM, SCDET, CTGID, USRDT);
            }
        }

        public static void DeleteLabelSubCategory(string SCTID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.LABEL_KATEGORI SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (SCTID = '" + SCTID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

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

        public static object[] GetLabelSubCategoryByID(string SCTID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT SK.SCTID, SK.SCTNM, SK.SCDET, LK.CTGNM, LK.CTGID
                            FROM bioumum.LABEL_KATEGORI LK, bioumum.LABEL_SUB_KATEGORI SK
                            WHERE LK.BEGDA <= GETDATE() AND LK.ENDDA >= GETDATE() AND SK.BEGDA <= GETDATE() AND SK.ENDDA >= GETDATE() AND LK.CTGID = SK.CTGID AND SK.SCTID = '" + SCTID + "'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetLabelSubCategories()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT SK.SCTID, SK.SCTNM, SK.SCDET, LK.CTGNM, LK.CTGID
                            FROM bioumum.LABEL_KATEGORI LK, bioumum.LABEL_SUB_KATEGORI SK
                            WHERE LK.BEGDA <= GETDATE() AND LK.ENDDA >= GETDATE() AND SK.BEGDA <= GETDATE() AND SK.ENDDA >= GETDATE() AND LK.CTGID = SK.CTGID";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    data.Add(values);
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertLabelBatch(string BATCH, string GINNO, string LBLID, string PRDID, string COCTR, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.LABEL_BATCH (BEGDA, ENDDA, BATCH, GINNO, LBLID, PRDID, COCTR, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + BATCH + "','" + GINNO + "','" + LBLID + "','" + PRDID + "','" + COCTR + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateLabelBatch(string BATCH, string GINNO, string LBLID, string PRDID, string COCTR, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.LABEL_BATCH SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (BATCH = '" + BATCH + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertLabelBatch(BATCH, GINNO, LBLID, PRDID, COCTR, USRDT);
            }
        }

        public static void DeleteLabelBatch(string BATCH, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum._BATCH SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (BATCH = '" + BATCH + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

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

        public static object[] GetLabelBatchByID(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LB.BATCH, LB.GINNO, LA.LBLNM, PR.PRDNM, CC.COCNM, LB.LBLID, LB.PRDID, LB.COCTR
                            FROM bioumum.LABEL_BATCH LB, bioumum.LABEL LA, bioumum.PRODUK PR, biopm.COST_CENTER CC
                            WHERE LB.LBLID = LA.LBLID AND LB.PRDID = PR.PRDID AND LB.COCTR = CC.COCTR
                            AND LB.BEGDA <= GETDATE() AND LB.ENDDA >= GETDATE()
                            AND LA.BEGDA <= GETDATE() AND LA.ENDDA >= GETDATE()
                            AND PR.BEGDA <= GETDATE() AND PR.ENDDA >= GETDATE()
                            AND CC.BEGDA <= GETDATE() AND CC.ENDDA >= GETDATE() AND LB.BATCH = '"+ BATCH +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetLabelBatchs()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LB.BATCH, LB.GINNO, LA.LBLNM, PR.PRDNM, CC.COCNM, LB.LBLID, LB.PRDID, LB.COCTR
                            FROM bioumum.LABEL_BATCH LB, bioumum.LABEL LA, bioumum.PRODUK PR, biopm.COST_CENTER CC
                            WHERE LB.LBLID = LA.LBLID AND LB.PRDID = PR.PRDID AND LB.COCTR = CC.COCTR
                            AND LB.BEGDA <= GETDATE() AND LB.ENDDA >= GETDATE()
                            AND LA.BEGDA <= GETDATE() AND LA.ENDDA >= GETDATE()
                            AND PR.BEGDA <= GETDATE() AND PR.ENDDA >= GETDATE()
                            AND CC.BEGDA <= GETDATE() AND CC.ENDDA >= GETDATE()";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString() };
                    data.Add(values);
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static int ValidatePrintFlow(string PRTID, string PERNR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT COUNT(*) FROM biopm.PRINT_LABEL WHERE PRTID = '" + PRTID + "' AND PNRAP = '" + PERNR + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);


            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                reader.Read();
                return Convert.ToInt16(reader[0]);
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertLabelPrintFlow(string PRTID, string TRFTY, string FLWST, string PNRAP, string TRFNT, string USRDT)
        {
            string date = DateTime.Now.ToString();
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.PRINT_FLOW (PRTID, DATTR, TRFTY, FLWST, PNRAP, TRFNT, CHGDT, USRDT) 
                            VALUES ('" + PRTID + "','" + date + "','" + TRFTY + "','" + FLWST + "','" + PNRAP + "','" + TRFNT + "','" + date + "','" + USRDT + "');";

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

        public static void InsertLabelPrintData(string PRTID, string BATCH, string PRTTY, string QTYNO, string RQSDT, string EXPDT, string PRTDT, string PRTNO, string PRTRS, string USRDT)
        {
            string date = DateTime.Now.ToString();
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.PRINT_FLOW (BEGDA, PRTID, BATCH, PRTTY, QTYNO, RQSDT, EXPDT, PRTDT, PRTNO, PRTRS, CHGDT, USRDT) 
                            VALUES ('" + date + "','" + PRTID + "','" + BATCH + "','" + PRTTY + "','" + QTYNO + "','" + RQSDT + "','" + EXPDT + "','" + PRTDT + "','" + PRTNO+ "','" + PRTRS + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateLabelPrintData(string PRTID, string BATCH, string PRTTY, string QTYNO, string RQSDT, string EXPDT, string PRTDT, string PRTNO, string PRTRS, string USRDT)
        {
            string date = DateTime.Now.ToString();
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.PRINT_FLOW SET BATCH = '"+ BATCH +"', PRTTY = '"+ PRTTY +"', QTYNO = '"+ QTYNO +"', RQSDT = '"+ RQSDT +"', EXPDT = '"+ EXPDT +"', PRTDT = '"+ PRTDT +"', PRTNO = '"+ PRTNO +"', PRTRS ='"+ PRTRS +"', CHGDT ='"+ date +"', USRDT = '"+ USRDT +"'(WHERE PRTID = '" + PRTID + "')";

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

        public static void UpdateLabelPrintPrintedDate(string PRTID, string PRTDT, string USRDT)
        {
            string date = DateTime.Now.ToString();
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.PRINT_FLOW SET PRTDT = '" + PRTDT + "', CHGDT ='" + date + "', USRDT = '" + USRDT + "'(WHERE PRTID = '" + PRTID + "')";

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

        public static object[] GetBatchDetailByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LB.BATCH, LB.GINNO, PR.PRDNM, PT.BEGDA, PT.ENDDA, LA.LBLNM
                            FROM bioumum.PRODUK PR, bioumum.LABEL_BATCH LB, bioumum.LABEL LA, biopm.PRODUCTION PT
                            WHERE PR.PRDID = LB.PRDID AND LB.LBLID = LA.LBLID AND PT.BATCH = LB.BATCH AND LB.BATCH = '"+ BATCH +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetLabelPrintFlowByPrintIDAndType(string PRTID, string TRFTY)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PL.PRTID, PL.BATCH, PF.DATTR, PF.FLWST, PF.TRFTY, PNRAP, TRFNT
                            FROM biopm.PRINT_LABEL PL, (SELECT MAX(PF.DATTR) as MAXDATE FROM biopm.PRINT_FLOW PF WHERE PF.PRTID = '"+ PRTID +"' AND PF.TRFTY ='"+ TRFTY +"') ST, biopm.PRINT_FLOW PF WHERE PF.PRTID = PL.PRTID AND PF.DATTR = ST.MAXDATE AND PF.TRFTY ='"+ TRFTY +"' AND PL.PRTID = '"+ PRTID +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetLabelPrintData()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PL.PRTID, PL.RQSDT, PL.BATCH, LB.GINNO, PR.PRDNM, LA.LBLNM
                            FROM bioumum.PRODUK PR, biopm.PRINT_LABEL PL, bioumum.LABEL_BATCH LB, bioumum.LABEL LA
                            WHERE PR.PRDID = LB.PRDID AND LB.LBLID = LA.LBLID AND LB.BATCH = PL.BATCH";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    data.Add(values);
                }

                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetLabelPrintDataByApprover(string PERNR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT PL.PRTID, PL.RQSDT, PL.BATCH, LB.GINNO, PR.PRDNM, LA.LBLNM
                            FROM bioumum.PRODUK PR, biopm.PRINT_LABEL PL, bioumum.LABEL_BATCH LB, bioumum.LABEL LA, biopm.PRINT_FLOW PF
                            WHERE PR.PRDID = LB.PRDID AND LB.LBLID = LA.LBLID AND LB.BATCH = PL.BATCH AND PF.PRTID = PL.PRTID AND PF.PNRAP = '" + PERNR +"'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    data.Add(values);
                }

                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static int GetMaxPrintID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(PRTID) FROM biopm.PRINT_LABEL";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            string id = "0";
            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                while (reader.Read())
                {
                    if (!reader.IsDBNull(0)) id = reader[0].ToString() + "";
                }
                return Convert.ToInt16(id);
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetLabelPrintDataByPrintID(string PRTID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT LB.BATCH, LB.GINNO, PR.PRDNM, PT.BEGDA, PT.ENDDA, LA.LBLNM, PL.RQSDT, PL.PRTTY,PL.QTYNO, PL.PRTNO, PL.PRTRS
                            FROM bioumum.PRODUK PR, bioumum.LABEL_BATCH LB, bioumum.LABEL LA, biopm.PRODUCTION PT, biopm.PRINT_LABEL PL
                            WHERE PR.PRDID = LB.PRDID AND LB.LBLID = LA.LBLID AND PT.BATCH = LB.BATCH AND PL.BATCH = LB.BATCH AND PL.PRTID = '"+ PRTID +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString(), reader[9].ToString(), reader[10].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetPrintApproverByIDAndType(string PRTID, string TRFTY)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT PRTID, TRFTY, PNRAP, UD.PRPOS + ' ' + UD.PRORG + ' - ' + UD.CNAME
                            FROM biopm.PRINT_FLOW PF, bioumum.USER_DATA UD
                            WHERE UD.PERNR = PF.PNRAP AND PRTID = '"+ PRTID +"' AND TRFTY = '"+ TRFTY +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> reviewer = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    reviewer.Add(values);
                }
                return reviewer;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetBatchsByCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATCH, PR.PRDID, PR.PRDNM, PT.BEGDA, PT.ENDDA
                            FROM bioumum.PRODUK PR, bioumum.PRODUK_COST_CENTER PC, biopm.PRODUCTION PT JOIN biopm.BATCH BT ON PT.BATCH = BT.BATCH
                            WHERE PC.PRDID = BT.PRDID AND SUBSTRING(PC.COCTR,1,3) = '" + COCTR.Substring(0, 3) + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}