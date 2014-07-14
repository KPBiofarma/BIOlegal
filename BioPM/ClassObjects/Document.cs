using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BioPM.ClassObjects
{
    public class Document : DatabaseFactory
    { 
        public static void InsertDocument(string DOCID, string DOCNM, string TempDir)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm:ss");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm:ss");
            string url = TempDir + DOCNM;
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.DOCUMENT( BEGDA, ENDDA, DOCID, DOCNM, DOCPLC)
                                        VALUES (  '" + date + "' , '" + maxdate + "', '" + DOCID + "', '"+ DOCNM +"', '"+ url +"');";
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

        public static void UpdateRisk(string REGID, string RKEVT, string RKACT, string RKFNC, string SUPDT, string RKCAU, string RKLOC, string RKMGT, string RKFRQ, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string delimit = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");

            SqlConnection conn = GetConnection();
            //string sqlCmd = @"UPDATE biolegal.RISK SET BEGDA = '" + BEGDA + "', RISKEVT = '" + RISKEVT + "', RISKACT = '" + RISKACT + "', RISKCFUNC = '" + RISKFUNC + "', SUPPDT = '" + SUPPDT + "', RISKCAU = '" + RISKCAU + "', RISKLOC = '" + RISKLOC + "', RISKMGT = '" + RISKMGT + ", RISKFREQ = '" + RISKFREQ + "' WHERE REGID = '" + REGID + "';";

            string sqlCmd = @"UPDATE biolegal.RISK SET ENDDA = '" + delimit + "', RISKEVT = '" + RKEVT + "', RISKACT = '" + RKACT + "', RKFNC = '" + RKFNC + "', SUPDT = '" + SUPDT + "', RKCAU = '" + RKCAU + "', RKLOC = '" + RKLOC + "', RKMGT = '" + RKMGT + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (REGID = '" + REGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";
            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                //InsertRisk(REGID, RKEVT, RKACT, RKFNC, SUPDT, RKCAU, RKLOC, RKMGT, RKFRQ, USRDT);
            }
        }

        public static void DeleteRisk(string REGID, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string delimit = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();

            string sqlCmd = @"UPDATE biolegal.RISK SET ENDDA = '" + delimit + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (REGID = '" + REGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";
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

        public static List<object[]> GetDocument()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT D.BEGDA, D.DOCID, D.DOCNM, D.DOCPLC
                                FROM bioumum.DOCUMENT D";
            SqlCommand cmd = GetCommand(conn, sqlCmd); 
            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();
                while (reader.Read())
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
        public static int GetOrganizationMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(ORGID) FROM bioumum.ORGANIZATION G";
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
    }
}