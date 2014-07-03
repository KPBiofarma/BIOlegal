using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BioPM.ClassObjects
{
    public class ProductionCatalog : DatabaseFactory
    {
        public static List<string> GetProductUnit()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT UNTID FROM bioumum.PRODUK WHERE UNTID != ''";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<string> unit = new List<string>();
                
                while (reader.Read())
                {
                    unit.Add(reader[0].ToString());
                }
                
                return unit;
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertDataProduction(string BEGDA, string ENDDA, string BATCH, string PRDID, string PRDPT, string NOQTY, string UNTID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.PRODUCTION (BEGDA, ENDDA, BATCH, PRDID, PRDPT, NOQTY, UNTID, CHGDT, USRDT)
                            VALUES ('" + BEGDA + "','" + ENDDA + "','" + BATCH + "','" + PRDID + "','" + PRDPT + "','" + NOQTY + "','" + UNTID + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateDataProduction(string ENDDA, string BATCH, string PRDID, string PRDPT, string NOQTY, string UNTID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.PRODUCTION SET ENDDA = '"+ ENDDA +"', PRDPT = '" + PRDPT + "', NOQTY = '" + NOQTY + "', UNTID = '" + UNTID + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (BATCH = '" + BATCH + "');";

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

        public static void UpdateDataProductionReview()
        {

        }

        public static void InsertProductionFormula(string BATCH, string ITMID, string NOQTP, string RVFLG, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.PRODUCTION_FORMULA (BEGDA, ENDDA, BATCH, ITMID, NOQTP, RVFLG, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + BATCH + "','" + ITMID + "','" + NOQTP + "','" + RVFLG + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateProductionFormula(string BATCH, string ITMID, string NOQTP, string RVFLG, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.PRODUCTION_FORMULA SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (BATCH = '" + BATCH + "' AND ITMID = '" + ITMID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE());";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertProductionFormula(BATCH, ITMID, NOQTP, RVFLG, USRDT);
            }
        }

        public static void UpdateProductionFormulaReview(string BATCH, string ITMID, string RVFLG, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.PRODUCTION_FORMULA SET RVFLG = '" + RVFLG + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (BATCH = '" + BATCH + "' AND ITMID = '" + ITMID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE());";

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

        public static int ValidateProductionFormulaChanged(string BATCH, string ITMID, string VALUE)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(*)
                            FROM biopm.PRODUCTION_FORMULA WHERE BEGDA <= GETDATE() AND ENDDA >= GETDATE() 
                            AND BATCH = '"+ BATCH +"' AND ITMID = '"+ ITMID +"'  AND NOQTP = '"+ VALUE +"'";
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

        public static int ValidateProductionFormula(string BATCH, string ITMID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT COUNT(*) 
                            FROM biopm.PRODUCTION_FORMULA
                            WHERE BATCH = '" + BATCH + "' AND ITMID = '" + ITMID + "'";
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

        public static void InsertProductionQualityControlResult(string BATCH, string QCTYP, string QCSTY, string QCRSL, string UNTID, string QCVAL, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_RESULT (BEGDA, ENDDA, BATCH, QCTYP, QCSTY, QCRSL, UNTID, QCVAL, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + BATCH + "','" + QCTYP + "','" + QCSTY + "','" + QCRSL + "','" + UNTID + "','" + QCVAL + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateProductionQualityControlResult(string BATCH, string QCTYP, string QCSTY, string QCRSL, string UNTID, string QCVAL, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_RESULT SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (BATCH = '" + BATCH + "' AND QCTYP = '" + QCTYP + "' AND QCSTY = '" + QCSTY + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE());";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertProductionQualityControlResult(BATCH, QCTYP, QCSTY, QCRSL, UNTID, QCVAL, USRDT);
            }
        }

        public static void UpdateProductionQualityControlResultReview(string BATCH, string QCTYP, string QCSTY, string QCRSL, string UNTID, string QCVAL, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_RESULT SET QCVAL = '" + QCVAL + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (BATCH = '" + BATCH + "' AND QCTYP = '" + QCTYP + "' AND QCSTY = '" + QCSTY + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE());";

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

        public static int ValidateProductionQualityControlChanged(string BATCH, string QCTYP, string QCSTY, string VALUE)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(*)
                            FROM biopm.QC_RESULT WHERE BEGDA <= GETDATE() AND ENDDA >= GETDATE() 
                            AND BATCH = '" + BATCH + "' AND QCTYP = '" + QCTYP + "' AND QCSTY = '" + QCSTY + "'  AND QCRSL = '" + VALUE + "'";
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

        public static int ValidateProductionQualityControlResult(string BATCH, string QCTYP, string QCSTY)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT COUNT(*) 
                            FROM biopm.QC_RESULT
                            WHERE BATCH = '" + BATCH + "' AND QCTYP = '" + QCTYP + "' AND QCSTY = '" + QCSTY + "'";
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

        public static List<object[]> GetDataProductQualityControlByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT  QT.QCTYP, QT.QCTNM, QT.ALIAS, QP.QCSTY, QP.QCSNM, QP.ALIAS, QP.QCREQ, QP.QCSYA, QP.QCMIN, QP.QCMAX, QR.QCRSL, QR.UNTID, QR.QCVAL
                            FROM biopm.BATCH BT, biopm.QC_TYPE QT, biopm.QC_REFERENSI_PRODUK QP FULL JOIN biopm.QC_RESULT QR ON QR.QCSTY = QP.QCSTY AND QP.QCTYP = QR.QCTYP
                            WHERE BT.PRDID = QP.PRDID AND QT.QCTYP = QP.QCTYP AND QT.BEGDA <= GETDATE() AND QT.ENDDA >= GETDATE() AND QP.BEGDA <= GETDATE() AND QP.ENDDA >= GETDATE()
                            AND (QR.BEGDA IS NULL OR QR.BEGDA <= GETDATE()) AND (QR.ENDDA IS NULL OR QR.ENDDA >= GETDATE()) AND BT.BATCH = '"+ BATCH +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> reviewer = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString(), reader[9].ToString(), reader[10].ToString(), reader[11].ToString(), reader[12].ToString() };
                    reviewer.Add(values);
                }
                return reviewer;
            }
            finally
            {
                conn.Close();
            }
        }        
        
        public static void InsertProductionTransactionFlow(string BATCH, string TRFTY, string FLWST, string PNRAP, string TRFNT, string USRDT)
        {
            string date = DateTime.Now.ToString();
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.PRODUCTION_FLOW (BATCH, DATTR, TRFTY, FLWST, PNRAP, TRFNT, CHGDT, USRDT) 
                            VALUES ('" + BATCH + "','" + date + "','" + TRFTY + "','" + FLWST + "','" + PNRAP + "','" + TRFNT + "','" + date + "','" + USRDT + "');";

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

        
        public static int ValidateProductionFlowByStatus(string BATCH, string FLWST)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT COUNT(*) FROM biopm.PRODUCTION_FLOW WHERE BATCH = '"+ BATCH +"' AND FLWST = '"+ FLWST +"'";
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

        public static int ValidateProductionFlow(string BATCH, string PERNR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT COUNT(*) FROM biopm.PRODUCTION_FLOW WHERE BATCH = '"+ BATCH +"' AND PNRAP = '"+ PERNR +"'";
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

        public static int ValidateProductionBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT COUNT(*) 
                            FROM biopm.PRODUCTION
                            WHERE BATCH = '" + BATCH + "'";
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

        public static int ValidateProductBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(*) 
                            FROM biopm.BATCH
                            WHERE BATCH = '" + BATCH + "'";
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

        public static List<object[]> GetProductReviewerByBatchAndType(string BATCH, string TRFTY)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT BATCH, TRFTY, PNRAP, UD.PRPOS + ' ' + UD.PRORG + ' - ' + UD.CNAME
                              FROM biopm.PRODUCTION_FLOW PF, bioumum.USER_DATA UD
                              WHERE UD.PERNR = PF.PNRAP AND BATCH = '"+ BATCH +"' AND TRFTY = '"+ TRFTY +"'";
                            
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

        public static object[] GetProductionStatusByBatchAndType(string BATCH, string TRFTY)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PT.BATCH, PF.DATTR, PF.FLWST, PF.TRFTY, PNRAP, TRFNT
                            FROM biopm.PRODUCTION PT, (SELECT MAX(PF.DATTR) as MAXDATE FROM biopm.PRODUCTION_FLOW PF WHERE PF.BATCH = '" + BATCH + "' AND PF.TRFTY ='" + TRFTY + "') ST, biopm.PRODUCTION_FLOW PF WHERE PF.BATCH = PT.BATCH AND PF.DATTR = ST.MAXDATE AND PF.TRFTY ='" + TRFTY + "' AND PT.BATCH = '" + BATCH + "'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] batch = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    batch = values;
                }
                return batch;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetProductionStatusByBatchAndUntype(string BATCH, string XTRFTY)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PT.BATCH, PF.DATTR, PF.FLWST, PF.TRFTY, PNRAP, TRFNT
                            FROM biopm.PRODUCTION PT, (SELECT MAX(PF.DATTR) as MAXDATE FROM biopm.PRODUCTION_FLOW PF WHERE PF.BATCH = '" + BATCH + "' AND PF.TRFTY !='" + XTRFTY + "') ST, biopm.PRODUCTION_FLOW PF WHERE PF.BATCH = PT.BATCH AND PF.DATTR = ST.MAXDATE AND PF.TRFTY !='" + XTRFTY + "' AND PT.BATCH = '" + BATCH + "'";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] batch = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    batch = values;
                }
                return batch;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetProductBatchByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BEGDA, BT.BATCH, BT.PRDID, PR.PRDNM
                            FROM biopm.BATCH BT, bioumum.PRODUK PR
                            WHERE PR.PRDID = BT.PRDID AND BT.BATCH = '"+ BATCH +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] batch = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    batch = values;
                }
                return batch;
            }
            finally
            {
                conn.Close();
            }
        }



        public static object[] GetProductionByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PT.BEGDA, PT.ENDDA, PT.BATCH, PT.PRDID, PT.PRDPT, PR.PRSTO, PT.NOQTY, PT.UNTID, PR.PRDNM
                            FROM biopm.PRODUCTION PT, bioumum.PRODUK PR
                            WHERE PT.PRDID = PR.PRDID AND PT.BATCH = '"+ BATCH +"'";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] batch = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString() };
                    batch = values;
                }
                return batch;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetProductionBatchByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PT.BATCH, PR.PRDID, PR.PRDNM, PT.NOQTY, PR.PRSTO, PT.BEGDA, PT.ENDDA, PF.FLWST, PR.UNTID, PT.PRDPT
                            FROM biopm.PRODUCTION PT, bioumum.PRODUK PR, (SELECT MAX(PF.DATTR) as MAXDATE FROM biopm.PRODUCTION_FLOW PF WHERE PF.BATCH = '" + BATCH + "') ST, biopm.PRODUCTION_FLOW PF WHERE PF.BATCH = PT.BATCH AND PF.DATTR = ST.MAXDATE AND PT.PRDID = PR.PRDID AND PT.BATCH = '" + BATCH + "' GROUP BY PT.BATCH, PR.PRDID, PR.PRDNM, PT.NOQTY, PR.PRSTO, PT.BEGDA, PT.ENDDA, PF.FLWST, PR.UNTID";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] batch = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString(), reader[9].ToString() };
                    batch = values;
                }
                return batch;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetProductQCByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PT.BEGDA, PT.ENDDA, PT.BATCH, QC.QCTNM, QC.ALIAS, QP.QCSTY, QP.QCSNM, QP.QCREQ
                            FROM biopm.PRODUCTION PT, biopm.QC_REFERENSI_PRODUK QP, biopm.QC_TYPE QC
                            WHERE QC.QCTYP = QP.QCTYP AND PT.PRDID = QP.PRDID AND PT.BATCH = '" + BATCH + "' GROUP BY PT.BEGDA, PT.ENDDA, PT.BATCH, QC.QCTNM, QC.ALIAS, QP.QCSTY, QP.QCSNM, QP.QCREQ ORDER BY QC.ALIAS";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> qc = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString() };
                    qc.Add(values);
                }
                return qc;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetProductionFormulaByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT IT.ITMID, IT.ITMNM, FR.NOQTY, PF.NOQTP, FR.UNTID, PF.RVFLG
                            FROM biopm.PRODUCTION_FORMULA PF FULL JOIN bioumum.FORMULA FR ON PF.ITMID = FR.ITMID, biopm.BATCH BT, bioumum.ITEM IT
                            WHERE BT.PRDID = FR.PRDID AND FR.ITMID = IT.ITMID AND ((PF.BEGDA IS NULL OR PF.BEGDA <= GETDATE()) AND (PF.ENDDA IS NULL OR PF.ENDDA >= GETDATE()))
                            AND FR.BEGDA <= GETDATE() AND FR.ENDDA >= GETDATE() AND BT.BATCH = '" + BATCH + "'";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> formula = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    formula.Add(values);
                }
                return formula;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetProductFormulaByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PT.BEGDA, PT.ENDDA, PT.BATCH, FR.ITMID, IT.ITMNM, FR.NOQTY, FR.UNTID
                            FROM biopm.PRODUCTION PT, bioumum.FORMULA FR, bioumum.ITEM IT
                            WHERE PT.PRDID = FR.PRDID AND IT.ITMID = FR.ITMID AND PT.BATCH = '"+ BATCH +"'";
                            
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> formula = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
                    formula.Add(values);
                }
                return formula;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetProductProductionByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PT.BEGDA, PT.ENDDA, PT.BATCH, PR.PRDID, PR.PRDNM
                            FROM biopm.PRODUCTION PT, bioumum.PRODUK PR
                            WHERE PR.PRDID = PT.PRDID AND PT.BATCH = '"+ BATCH +"' GROUP BY PT.BEGDA, PT.ENDDA, PT.BATCH, PR.PRDID, PR.PRDNM";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> production = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    production.Add(values);
                }
                return production;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}