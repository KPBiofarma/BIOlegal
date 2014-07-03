using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BioPM.ClassObjects
{
    public class UserCatalog : DatabaseFactory
    {
        public static void InsertEmail(string PERNR, string EMAIL, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.USER_EMAIL (BEGDA, ENDDA, PERNR, EMAIL, CHGDT, USRDT)
                            VALUES ('"+ date +"','"+ maxdate +"','"+ PERNR +"','"+ EMAIL +"','"+ date +"','"+ USRDT +"');";

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

        public static void UpdateEmail(string PERNR, string EMAIL, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.USER_EMAIL SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (PERNR = '" + PERNR + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE());";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertEmail(PERNR, EMAIL, USRDT);
            }
        }

        public static void InsertPassword(string PERNR, string PASSW, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.USER_PASSWORD (BEGDA, ENDDA, PERNR, PASSW, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + PERNR + "','" + PASSW + "','" + date + "','" + USRDT + "');";

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

        public static void UpdatePassword(string PERNR, string PASSW, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.USER_PASSWORD SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (PERNR = '" + PERNR + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE());";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertPassword(PERNR, PASSW, USRDT);
            }
        }
        
        public static int GetPasswordActivePeriod(string PERNR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BEGDA, Convert(int,(GETDATE() - BEGDA))
                            FROM bioumum.USER_PASSWORD WHERE PERNR = '" + PERNR + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE();";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                reader.Read();
                return Convert.ToInt16(reader[1]);
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertUserRole(string PERNR, string ROLID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string maxdate = DateTime.MaxValue.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO bioumum.USER_OTORITY (BEGDA, ENDDA, PERNR, ROLID, CHGDT, USRDT)
                            VALUES ('" + date + "','" + maxdate + "','" + PERNR + "','" + ROLID + "','" + date + "','" + USRDT + "');";

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

        public static void UpdateUserRole(string PERNR, string ROLID, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.USER_OTORITY SET ENDDA = '" + yesterday + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (PERNR = '" + PERNR + "' AND BEGDA <= GETDATE() AND ENDDA >= GETDATE());";

            SqlCommand cmd = DatabaseFactory.GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                conn.Close();
                InsertPassword(PERNR, ROLID, USRDT);
            }
        }

        public static List<object[]> GetUserRole()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT ROLID, ROLNM
                            FROM bioumum.USER_ROLE ORDER BY ROLNM";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> role = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    role.Add(values);
                }
                return role;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetBioPMUserAccount()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT UD.PERNR, UD.CNAME, CC.COCNM, UE.EMAIL, UR.ROLNM
                            FROM bioumum.USER_ROLE UR, bioumum.USER_OTORITY UO, bioumum.USER_DATA UD, bioumum.USER_EMAIL UE, biopm.COST_CENTER CC
                            WHERE UO.PERNR = UD.PERNR AND UD.PERNR = UE.PERNR AND UR.ROLID = UO.ROLID AND UD.COCTR = CC.COCTR
                            AND UO.BEGDA <= GETDATE() AND UO.ENDDA >= GETDATE() AND UR.BEGDA <= GETDATE() AND UR.ENDDA >= GETDATE()
                            AND UE.BEGDA <= GETDATE() AND UE.ENDDA >= GETDATE()";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> users = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(),  };
                    users.Add(values);
                }
                return users;
            }
            finally
            {
                conn.Close();
            }
        }

        public static void UpdateCostCenter(string PERNR, string COCTR, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE bioumum.USER_DATA SET COCTR = '" + COCTR + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE (PERNR = '" + PERNR + "');";

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

        public static int ValidateNIKEmployee(string NIK)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT COUNT(*) 
                            FROM bioumum.USER_DATA
                            WHERE PERNR = '"+ NIK +"'";
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
        
        public static object[] GetUserApplicationData(string NIK)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT US.PERNR, US.CNAME, US.PRPOS, US.PRORG, US.GRPNM, US.SGRNM, US.PSGRP, UE.EMAIL, CC.COCNM
                            FROM bioumum.USER_DATA US, bioumum.USER_EMAIL UE, biopm.COST_CENTER CC
                            WHERE CC.COCTR = US.COCTR AND US.PERNR = UE.PERNR AND US.PERNR = '" + NIK + "';";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] user = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString() };
                    user = values;
                }
                return user;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetUserData(string NIK)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT US.PERNR, US.CNAME, US.PRPOS, US.PRORG, US.GRPNM, US.SGRNM, US.PSGRP
                            FROM bioumum.USER_DATA US WHERE US.PERNR = '"+ NIK +"' ORDER BY US.PERNR;";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] user = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
                    user = values;
                }
                return user;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetActiveUser(string PERNR, string PASSW)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT US.PERNR, PS.PASSW, EM.EMAIL, US.CNAME, US.PRORG, US.COCTR, CC.COCNM 
                            FROM bioumum.USER_DATA US, bioumum.USER_EMAIL EM, bioumum.USER_PASSWORD PS, biopm.COST_CENTER CC
                            WHERE US.PERNR = EM.PERNR AND US.PERNR = PS.PERNR AND US.COCTR = CC.COCTR 
                            AND EM.BEGDA <= GETDATE() AND PS.ENDDA >= GETDATE() AND PS.BEGDA <= GETDATE() AND PS.ENDDA >= GETDATE() AND US.PERNR = '" + PERNR + "' AND PS.PASSW = '" + PASSW + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] user = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
                    user = values;
                }

                return user;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetActiveUserFromCTI(string EMAIL)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT US.PERNR, PS.PASSW, EM.EMAIL, US.CNAME, US.COCTR, CC.COCNM 
                            FROM bioumum.USER_DATA US, bioumum.USER_EMAIL EM, bioumum.USER_PASSWORD PS, biopm.COST_CENTER CC
                            WHERE US.PERNR = EM.PERNR AND US.PERNR = PS.PERNR AND US.COCTR = CC.COCTR AND EM.BEGDA <= GETDATE() AND EM.ENDDA >= GETDATE() AND EM.EMAIL = '" + EMAIL + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] user = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    user = values;
                }

                return user;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetKadivCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PRPOS, PRORG, PERNR, CNAME, COCTR FROM bioumum.USER_DATA 
                            WHERE RVSTT = 3 AND SUBSTRING(COCTR,1,2) = '" + COCTR.Substring(0, 2) + "' ORDER BY PRORG";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> batchs = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    batchs.Add(values);
                }
                return batchs;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAllKadiv()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PRPOS, PRORG, PERNR, CNAME, COCTR FROM bioumum.USER_DATA 
                            WHERE RVSTT = 3 ORDER BY PRORG";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> batchs = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    batchs.Add(values);
                }
                return batchs;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetKabagByCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PRPOS, PRORG, PERNR, CNAME, COCTR FROM bioumum.USER_DATA 
                            WHERE RVSTT = 2  AND SUBSTRING(COCTR,1,2) = '" + COCTR.Substring(0, 2) + "' ORDER BY PRORG";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> batchs = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    batchs.Add(values);
                }
                return batchs;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetKasiByCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PRPOS, PRORG, PERNR, CNAME, COCTR FROM bioumum.USER_DATA 
                            WHERE RVSTT = 1  AND SUBSTRING(COCTR,1,3) = '" + COCTR.Substring(0, 3) + "' ORDER BY PRORG";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> batchs = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    batchs.Add(values);
                }
                return batchs;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAllActiveUser()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT US.PERNR, US.CNAME, US.PRPOS, US.PRORG, US.GRPNM, US.SGRNM, US.PSGRP
                            FROM bioumum.USER_DATA US ORDER BY US.PERNR;";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> batchs = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
                    batchs.Add(values);
                }
                return batchs;
            }
            finally
            {
                conn.Close();
            }
        }
    }

    public class ApplicationCatalog : DatabaseFactory
    {
        public static List<object[]> GetMenuApplicationByUserID(string MNPID, string PERNR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT UM.MENID, UM.MENAM, UM.MNURL , UM.MNICO
                            FROM bioumum.USER_OTORITY UO, bioumum.USER_ROLE UR, bioumum.USER_MENU UM
                            WHERE UO.ROLID = UR.ROLID AND UR.MENID = UM.MENID
                            AND UM.MNPID = '" + MNPID +"' AND UO.PERNR = '"+ PERNR +"' ORDER BY UM.MNSEQ;";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> menu = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    menu.Add(values);
                }

                return menu;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}