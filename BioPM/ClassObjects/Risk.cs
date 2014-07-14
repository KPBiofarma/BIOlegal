using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace BioPM.ClassObjects
{
    public class RiskCatalog : DatabaseFactory
    {
        public static void InsertRisk( string ORGID, string ACTID, string RSKID, string RKEVT, string RKACT, 
                                       string RKFNC, string SUPDT, string RKCAU, string RKLOC, string RKPRB, 
                                       string RKIMP, string RKSTT, string RKMGT, string USRDT )
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm:ss");
            SqlConnection conn = GetConnection();

            string sqlCmd = @"INSERT INTO biolegal.RISK( BEGDA, ENDDA, ORGID, ACTID, RSKID, RKEVT, RKACT, RKFNC, SUPDT, RKCAU, RKLOC, RKPRB, RKIMP, RKSTT, RKMGT, CHGDT, USRDT )
                            VALUES ( '"+ date +"', '"+ maxdate +"', '"+ ORGID +"', '"+ ACTID +"', '"+ RSKID +"', '"+ RKEVT +"', '"+ RKACT +"', '"+ RKFNC +"', '"+ SUPDT +"', '"+ RKCAU +"', '"+ RKLOC +"', '"+ RKPRB +"', '"+ RKIMP +"', '"+ RKSTT +"', '"+ RKMGT +"', '"+ date +"', '"+ USRDT +"');";         
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

        public static void UpdateRisk( string ORGID, string ACTID, string RSKID, string RKEVT, string RKACT, 
                                       string RKFNC, string SUPDT, string RKCAU, string RKLOC, string RKPRB, 
                                       string RKIMP, string RKSTT, string RKMGT, string USRDT )
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string yesterday = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biolegal.RISK SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (RSKID = '" + RSKID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE())";
            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertRisk(ORGID, ACTID, RSKID, RKEVT, RKACT, RKFNC, SUPDT, RKCAU, RKLOC, RKPRB, RKIMP, RKSTT, RKMGT, USRDT);
            }
        }


        public static void DeleteRisk(string RSKID, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string yesterday = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biolegal.RISK SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE( RSKID = '" + RSKID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE())";

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

        public static object[] GetFrequenciesPerFunction()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT R.RKFNC, COUNT(1) AS RKFRQ
                            FROM BIOFARMA.biolegal.RISK R
                            GROUP BY R.RKFNC";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }
        

        public static object[] GetRiskByID(string RSKID)
        {
            SqlConnection conn = GetConnection();       
            string sqlCmd = @"SELECT R.ORGID, R.ACTID, R.RSKID, R.RKEVT, R.RKACT, R.RKFNC, R.SUPDT, R.RKCAU, R.RKLOC, R.RKPRB, R.RKIMP, R.RKSTT, R.RKMGT
                            FROM biolegal.RISK R
                            WHERE R.BEGDA <= GETDATE() AND R.ENDDA >= GETDATE() AND R.RSKID = '" + RSKID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString(), reader[9].ToString(), reader[10].ToString(), reader[11].ToString(), reader[12].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

//        public static object[] GetRiskByStat()
//        {
//            SqlConnection conn = GetConnection();

//            string sqlCmd = @"SELECT R.RKSTT 
//                              FROM biolegal.RISK R";
//            SqlCommand cmd = GetCommand(conn, sqlCmd);

//            try
//            {
//                conn.Open();
//                SqlDataReader reader = GetDataReader(cmd);
//                object[] data = null;
//                while (reader.Read())
//                {
//                    object[] values = { reader[0] };
//                }
//                return data;
//            }
//            finally
//            {
//                conn.Close();
//            }
//        }

        public static Object GetMaxRiskImpact()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"biolegal.GetMaxDampak";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            Object returnVal;

            try
            {
                conn.Open();
                returnVal = cmd.ExecuteScalar();
                return returnVal;
            }
            finally
            {
                conn.Close();
            }

        }

        public static Object GetMinRiskImpact()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"biolegal.GetMinDampak";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            Object returnVal;

            try
            {
                conn.Open();
                returnVal = cmd.ExecuteScalar();
                return returnVal;
            }
            finally
            {
                conn.Close();
            }

        }

        public static Object GetMaxRiskFrequency()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"biolegal.GetMaxFrekuensi";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            Object returnVal;

            try
            {
                conn.Open();
                returnVal = cmd.ExecuteScalar();
                return returnVal;
            }
            finally
            {
                conn.Close();
            }

        }

        public static Object GetMinRiskFrequency()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"biolegal.GetMinFrekuensi";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            Object returnVal;

            try
            {
                conn.Open();
                returnVal = cmd.ExecuteScalar();
                return returnVal;
            }
            finally
            {
                conn.Close();
            }

        }

        public static Object GetFrequencyByFunction(string function)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(1) AS RKFRQ
                            FROM BIOFARMA.biolegal.RISK R
                            WHERE R.RKFNC = '"+ function +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);
            Object returnVal;

            try
            {
                conn.Open();
                returnVal = cmd.ExecuteScalar();
                return returnVal;
            }
            finally
            {
                conn.Close();
            }
        }


        public static Object GetNumberofFunction()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT(R.FNCID))
	                        FROM BIOFARMA.biolegal.RISK_FUNCTION R";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            Object returnVal;

            try
            {
                conn.Open();
                returnVal = cmd.ExecuteScalar();
                return returnVal;
            }
            finally
            {
                conn.Close();
            }
        }

        public static Object GetFrequencySum()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT SUM(T1.RKFRQ) AS SMFRQ
	                        FROM 
	                        (
		                        SELECT R.RKFNC, COUNT(1) AS RKFRQ
                                FROM BIOFARMA.biolegal.RISK R
                                GROUP BY R.RKFNC
	                        ) T1";

            SqlCommand cmd = GetCommand(conn, sqlCmd);
            Object returnVal;

            try
            {
                conn.Open();
                returnVal = cmd.ExecuteScalar();
                return returnVal;
            }
            finally
            {
                conn.Close();
            }  
        }
        
        public static int GetRiskMatchID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(RSKID) FROM biolegal.RISK";
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

        public static List<object[]> GetRisks()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT R.BEGDA, R.ORGID, R.ACTID, R.RSKID, R.RKEVT, R.RKFNC, R.RKMGT
                                FROM biolegal.RISK R
                                ORDER BY R.BEGDA ASC, R.RSKID DESC";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while(reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
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