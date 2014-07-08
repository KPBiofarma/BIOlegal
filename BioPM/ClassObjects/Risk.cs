using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace BioPM.ClassObjects
{
    public class RiskCatalog : DatabaseFactory
    {
        public static void InsertRisk(string REGID, string RKEVT, string RKACT, string RKFNC, string SUPDT, string RKCAU, string RKLOC, string RKPRB, string RKIMP, string RKSTT, string RKMGT, string RKFRQ, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm:ss");
            SqlConnection conn = GetConnection();
            
            string sqlCmd = @"INSERT INTO biolegal.RISK( BEGDA, ENDDA, REGID, RKEVT, RKACT, RKFNC, SUPDT, RKCAU, RKLOC, RKPRB, RKIMP, RKSTT, RKMGT, RKFRQ, CHGDT, USRDT )
                            VALUES (  '"+ date + "' , '" + maxdate + "', '" + REGID + "',  '" + RKEVT + "', '" + RKACT + "', '" + RKFNC + "', '" + SUPDT + "', '" + RKCAU + "', '" + RKLOC + "', '" + RKPRB + "', '" + RKIMP + "', '" + RKSTT + "', '" + RKMGT + "', '" + RKFRQ + "', '" + date + "', '" + USRDT + "');";
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

        public static void UpdateRisk(string REGID, string RKEVT, string RKACT, string RKFNC, string SUPDT, string RKCAU, string RKLOC, string RKPRB, string RKIMP, string RKSTT, string RKMGT, string RKFRQ, string USRDT)
        {
            /*
            string date = DateTime.Now.ToString("MM/dd/yyyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string delimit = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biolegal.RISK SET ENDDA = '" + delimit + "', RKEVT = '" + RKEVT +"', RKACT = '" + RKACT + "', RKFNC = '"+ RKFNC +"', SUPDT = '"+ SUPDT +"', RKCAU = '"+ RKCAU +"', RKLOC = '" + RKLOC +"', RKPRB = '"+ RKPRB +"', RKIMP = '"+ RKIMP +"', RKSTT = '"+ RKSTT +"', RKMGT = '"+ RKMGT +"', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (REGID = '" + REGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE())";
            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);
            */

            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string yesterday = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biolegal.RISK SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (REGID = '" + REGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE())";
            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertRisk(REGID, RKEVT, RKACT, RKFNC, SUPDT, RKCAU, RKLOC, RKPRB, RKIMP, RKSTT, RKMGT, RKFRQ, USRDT);
            }
        }


        public static void DeleteRisk(string REGID, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string yesterday = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biolegal.RISK SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE( REGID = '" + REGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE())";

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

        public static object[] GetRiskByID(string REGID)
        {
            SqlConnection conn = GetConnection();
            //                          0       1       2       3       4           5       6           7       8           9       10   11         
            string sqlCmd = @"SELECT R.REGID, R.RKEVT, R.RKACT, R.RKFNC, R.SUPDT, R.RKCAU, R.RKLOC, R.RKPRB, R.RKIMP, R.RKSTT, R.RKMGT, R.RKFRQ
                            FROM biolegal.RISK R
                            WHERE R.BEGDA <= GETDATE() AND R.ENDDA >= GETDATE() AND R.REGID = '" + REGID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString(), reader[9].ToString(), reader[10].ToString(), reader[11].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }


        public static int GetRiskMatchID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(REGID) FROM biolegal.RISK";
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

        public static List<object[]> GetRisk()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT R.BEGDA, R.REGID, R.RKEVT, R.RKMGT
                                FROM biolegal.RISK R";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while(reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    samples.Add(values);
                }
                return samples;
            }
            finally
            {
                conn.Close();
            }
        }



        /*
        public static List<object[]> GetBagian()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT GET
        }
         * */
            
    }
}