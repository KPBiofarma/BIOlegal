using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BioPM.ClassObjects
{
    public class OrganizationCatalog : DatabaseFactory
    {
        public static void InsertOrganization(string ORGID, string QAOID, string ORGTY, string ORGNM, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.ORGANIZATION (BEGDA, ENDDA, ORGID, QAOID, ORGTY, ORGNM, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + ORGID + "','" + QAOID + "','" + ORGTY + "','" + ORGNM + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateOrganization(string ORGID, string QAOID, string ORGTY, string ORGNM, string USRDT)
       {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string delimit = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.ORGANIZATION SET ENDDA = '" + delimit + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (ORGID = '" + ORGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE()";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertOrganization(ORGID, QAOID, ORGTY, ORGNM, USRDT);
            }
        }
        public static void DeleteOrganization(string ORGID, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string delimit = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.ORGANIZATION SET ENDDA = '" + delimit + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (ORGID = '" + ORGID + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE())";

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

        public static object[] GetOrganizationByID(string ORGID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT OG.ORGID, OG.ORGTY, OG.ORGNM, OG.QAOID
                            FROM bioumum.ORGANIZATION OG
                            WHERE OG.BEGDA <= GETDATE() AND OG.ENDDA >= GETDATE() AND OG.ORGID = '" + ORGID +"'";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] data = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    data = values;
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetOrganizations()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT OG.ORGID, OG.ORGTY, OG.ORGNM, OG.QAOID
                            FROM bioumum.ORGANIZATION OG
                            WHERE OG.BEGDA <= GETDATE() AND OG.ENDDA >= GETDATE()";

            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> data = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    data.Add(values);
                }
                return data;
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertOrganizationStructure(string STRID, string PRTID, string PRTTY, string CLDID, string CLDTY, string ORGLV, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.ORGANIZATION_STRUCTURE (STRID, PRTID, PRTTY, CLDID, CLDTY, ORGLV, CHGDT, USRDT)
                            VALUES ('" + STRID + "','" + PRTID + "','" + PRTTY + "','" + CLDID + "','" + CLDTY + "','" + ORGLV + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateOrganizationStructure(string STRID, string PRTID, string PRTTY, string CLDID, string CLDTY, string ORGLV, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string delimit = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.ORGANIZATION_STRUCTURE SET PRTID = '" + PRTID + "', PRTTY = '" + PRTTY + "', CLDID = '" + CLDID + "', CLDTY = '" + CLDTY + "', ORGLV = '" + ORGLV + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE STRID = '" + STRID + "'";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertOrganizationStructure(STRID, PRTID, PRTTY, CLDID, CLDTY, ORGLV, USRDT);
            }
        }
        public static void DeleteOrganizationStructure(string STRID, string USRDT)
        {
            string date = DateTime.Now.ToString("MM/dd/yyyy HH:mm");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy HH:mm");
            string delimit = DateTime.Now.AddMinutes(-1).ToString("MM/dd/yyyy HH:mm");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"DELETE FROM bioumum.ORGANIZATION_STRUCTURE WHERE PRTID = '" + STRID + "'";

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
        
        public static object[] GetOrganizationStructureByID(string STRID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT OG1.ORGID, OG1.ORGTY, OG1.ORGNM, OG2.ORGID, OG2.ORGTY, OG2.ORGNM, OS.ORGLV, OS.STRID
                            FROM bioumum.ORGANIZATION OG1, bioumum.ORGANIZATION OG2, bioumum.ORGANIZATION_STRUCTURE OS
                            WHERE OG1.ORGID = OS.PRTID AND OG2.ORGID = OS.CLDID 
                            AND OG1.BEGDA <= GETDATE() AND OG1.ENDDA >= GETDATE() 
                            AND OG2.BEGDA <= GETDATE() AND OG2.ENDDA >= GETDATE()  
                            AND OS.STRID = '" + STRID + "'";

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

        public static List<object[]> GetOrganizationStructures()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT OG1.ORGID, OG1.ORGTY, OG1.ORGNM, OG2.ORGID, OG2.ORGTY, OG2.ORGNM, OS.ORGLV, OS.STRID
                            FROM bioumum.ORGANIZATION OG1, bioumum.ORGANIZATION OG2, bioumum.ORGANIZATION_STRUCTURE OS
                            WHERE OG1.ORGID = OS.PRTID AND OG2.ORGID = OS.CLDID 
                            AND OG1.BEGDA <= GETDATE() AND OG1.ENDDA >= GETDATE() 
                            AND OG2.BEGDA <= GETDATE() AND OG2.ENDDA >= GETDATE()";

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

        public static int GetOrganizationMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(ORGID) FROM bioumum.ORGANIZATION";
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

        public static int GetOrganizationStructureMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(STRID) FROM bioumum.ORGANIZATION_STRUCTURE";
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