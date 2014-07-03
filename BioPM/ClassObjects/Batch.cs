using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BioPM.ClassObjects
{
    public class BatchCatalog : DatabaseFactory
    {
        public static void InsertBatch(string BATID, string BEGDA, string BATCH, string PRDID, string BTDET, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.BATCH (BATID, BEGDA, BATCH, PRDID, BTDET, CHGDT, USRDT)
                            VALUES ('" + BATID + "','" + BEGDA + "','" + BATCH + "','" + PRDID + "','" + BTDET + "','" + date + "','" + USRDT + "');";
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

        public static void UpdateBatch(string BATID, string BEGDA, string BATCH, string PRDID, string BTDET, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.BATCH SET BEGDA = '" + BEGDA + "', BATCH = '" + BATCH + "', PRDID = '" + PRDID + "', BTDET ='" + BTDET + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE BATID = '" + BATID + "';";
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


        public static void UpdateBatchTransaction(string BATID, string BEGDA, string BATCH, string PRDID, string BTDET, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.BATCH SET BEGDA = '" + BEGDA + "', BATCH = '" + BATCH + "', PRDID = '" + PRDID + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE BATID = '" + BATID + "';";
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

        public static void DeleteBatch(string BATID)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"DELETE FROM biopm.BATCH WHERE BATID = '" + BATID + "';";
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

        public static int GetBatchMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(BATID) FROM biopm.BATCH";
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

        public static List<object[]> GetProductByCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PR.PRDID, PR.PRDNM
                            FROM bioumum.PRODUK PR, bioumum.PRODUK_COST_CENTER PC
                            WHERE PC.PRDID = PR.PRDID AND PC.COCTR = '"+ COCTR +"' ORDER BY PRDNM";
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
        public static List<object[]> GetProduct()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PR.PRDID, PR.PRDNM
                            FROM bioumum.PRODUK PR ORDER BY PRDNM";
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

        public static List<object[]> GetDilutionSampleByCOCTR(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATCH, PR.PRDNM, DS.DILNO, DS.DILCN, DS.PRDID
                            FROM biopm.QC_DILUTION_SAMPLE DS, biopm.BATCH BT, bioumum.PRODUK PR, bioumum.PRODUK_COST_CENTER PC
                            WHERE DS.BEGDA <= GETDATE() AND DS.ENDDA >= GETDATE() AND PR.BEGDA <= GETDATE() AND PR.ENDDA >= GETDATE()
                            AND BT.PRDID = DS.PRDID AND PR.PRDID = BT.PRDID AND PC.PRDID = PR.PRDID AND PC.COCTR = '"+ COCTR +"'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetDilutionSample()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATCH, PR.PRDNM, DS.DILNO, DS.DILCN, DS.PRDID
                            FROM biopm.QC_DILUTION_SAMPLE DS, biopm.BATCH BT, bioumum.PRODUK PR 
                            WHERE BT.PRDID = DS.PRDID AND PR.PRDID = BT.PRDID";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetBatchByCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATID, BT.BEGDA, BT.BATCH, PR.PRDNM, BT.BTDET, PR.PRDID
                            FROM biopm.BATCH BT, bioumum.PRODUK PR, bioumum.PRODUK_COST_CENTER PC
                            WHERE PR.BEGDA <= GETDATE() AND PR.ENDDA >= GETDATE() 
                            AND PR.PRDID = BT.PRDID AND PC.PRDID = PR.PRDID AND PC.COCTR = '" + COCTR + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetBatchByReviewer(string PERNR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT BT.BATID, BT.BEGDA, BT.BATCH, PR.PRDNM, BT.BTDET
                            FROM biopm.BATCH BT, bioumum.PRODUK PR, biopm.PRODUCTION_FLOW PF
                            WHERE PR.PRDID = BT.PRDID AND PF.BATCH = BT.BATCH AND PF.PNRAP = '"+ PERNR +"'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetBatchByReviewerAndType(string PERNR, string TRFTY)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT BT.BATID, BT.BEGDA, BT.BATCH, PR.PRDNM, BT.BTDET
                            FROM biopm.BATCH BT, bioumum.PRODUK PR, biopm.PRODUCTION_FLOW PF
                            WHERE PR.PRDID = BT.PRDID AND PF.BATCH = BT.BATCH AND PF.PNRAP = '" + PERNR + "' AND PF.TRFTY = '"+ TRFTY +"'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static int GetBatchByFlowTypeStatus(string BATCH, string TRFTY, string FLWST)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT(PF.FLWST))
                            FROM biopm.BATCH BT, bioumum.PRODUK PR, biopm.PRODUCTION_FLOW PF
                            WHERE PR.PRDID = BT.PRDID AND PF.BATCH = BT.BATCH AND PF.BATCH = '" + BATCH + "' AND PF.TRFTY = '" + TRFTY + "' AND PF.FLWST = '" + FLWST + "'";
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

        public static List<object[]> GetBatch()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATID, BT.BEGDA, BT.BATCH, PR.PRDNM, BT.BTDET
                            FROM biopm.BATCH BT, bioumum.PRODUK PR
                            WHERE PR.PRDID = BT.PRDID";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetBatchByID(string BATID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATID, BT.BEGDA, BT.BATCH, BT.PRDID, BT.BTDET
                            FROM biopm.BATCH BT
                            WHERE BT.BATID = '" + BATID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] samples =  null;

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples = values;
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetRawMaterialByGIN(string GINNO)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT RM.GINNO, RM.BATCH, IT.ITMNM, RM.QNTTY, RM.QPERP
                            FROM bioumum.RAW_MATERIAL RM, bioumum.ITEM IT
                            WHERE RM.ITMID = IT.ITMID AND GINNO = '" + GINNO +"'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] samples =  null;

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    samples = values;
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