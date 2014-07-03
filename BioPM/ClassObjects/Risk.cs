using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace BioPM.ClassObjects
{
    public class RiskCatalog : DatabaseFactory
    {
        public static void InsertRisk(string BEGDA, string REGID, string RISKEVT, string RISKACT, string RISKFUNC, string SUPPDT, string RISKCAU, string RISKLOC, string RISKMGT, string RISKFREQ)
        {
            string date = DateTime.Today.ToString("MM/dd/YYYY");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biolegal.RISK( BEGDA, REGID, RISKEVT, RISKACT, RISKFUNC, SUPPDT, RISKCAU, RISKLOC, RISKMGT, RISKFREQ 
                            VALUES ('" + BEGDA + "', '" + REGID + "', '" + RISKEVT + "', '" + RISKACT + "', '" + RISKFUNC + "', '" + SUPPDT + "', '" + RISKCAU + "', '" + RISKLOC + "', '" + RISKMGT + "', '" + RISKFREQ + "');";
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

        public static void UpdateRisk(string BEGDA, string REGID, string RISKEVT, string RISKACT, string RISKFUNC, string SUPPDT, string RISKCAU, string RISKLOC, string RISKMGT, string RISKFREQ)
        {
            string date = DateTime.Today.ToString("MM/dd/YYYY");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biolegal.RISK SET BEGDA = '" + BEGDA + "', RISKEVT = '" + RISKEVT + "', RISKACT = '" + RISKACT + "', RISKCFUNC = '" + RISKFUNC + "', SUPPDT = '" + SUPPDT + "', RISKCAU = '" + RISKCAU + "', RISKLOC = '" + RISKLOC + "', RISKMGT = '" + RISKMGT + ", RISKFREQ = '" + RISKFREQ + "' WHERE REGID = '" + REGID + "';";
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

        public static void DeleteRisk(string REGID)
        {
            string date = DateTime.Today.ToString("MM/dd/YYYY");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"DELETE FROM biolegal.RISK WHERE REGID = '" + REGID + "';";
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
            string sqlCmd = @"SELECT R.BEGDA, R.REGID, R.RISKEVT, R.RISKMGT
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
            
    }
}