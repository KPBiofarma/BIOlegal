using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BioPM.ClassObjects
{

    public class QualityControlCatalog : DatabaseFactory
    {
        public static int GetQCDilutionMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(QCTID) FROM biopm.QC_DILUTION";
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

        public static void InsertQCDilutionTest(string RNDDT, string RNDID, string QCTID, string QCTYP, string ITMID, string CAGNO, string DILNO, string SMPNO, string USRDT)
        {
            UpdateAnimalTest(RNDID, CAGNO);
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_DILUTION (BATCH, RNDDT, RNDID, QCTID, QCTYP, ITMID, PRDID, CAGNO, DILNO, SMPNO, CHGDT, USRDT) 
                            VALUES('" + "" + "','" + RNDDT + "', '" + RNDID + "', '" + QCTID + "','" + QCTYP + "','" + ITMID + "','" + "" + "','" + CAGNO + "','" + DILNO + "','" + SMPNO + "','" + date + "', '" + USRDT + "')";
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

        public static void InsertQCDilutionTestNegatifControl(string RNDDT, string RNDID, string QCTID, string QCTYP, string ITMID, string CAGNO, string DILNO, string SMPNO, string USRDT)
        {
            UpdateAnimalTest(RNDID, CAGNO);
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_DILUTION (BATCH, RNDDT, RNDID, QCTID, QCTYP, ITMID, CAGNO, DILCN, CHGDT, USRDT) 
                            VALUES('" + "Negative Control" + "','" + RNDDT + "', '" + RNDID + "', '" + QCTID + "','" + QCTYP + "','" + ITMID + "','" + CAGNO + "','" + "0" + "','" + date + "', '" + USRDT + "')";
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

        public static void UpdateQCDilutionTest(string QCTID, string SMPNO, string DILNO, string BATCH, string DILCN)
        {
            UpdateBatchQCDilutionTest(QCTID, SMPNO, BATCH);
            UpdateConcentrationQCDilutionTest(QCTID, DILNO, DILCN);
        }

        public static void UpdateQCMWGT(string QCTID, string SMPNO, string BATCH)
        {
            UpdateBatchQCDilutionTest(QCTID, SMPNO, BATCH);
        }

        public static void UpdateBatchQCDilutionTest(string QCTID, string SMPNO, string BATCH)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_DILUTION SET BATCH = '" + BATCH + "' WHERE (QCTID = '" + QCTID + "' AND SMPNO = '" + SMPNO + "')";
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

        public static void UpdateConcentrationQCDilutionTest(string QCTID, string DILNO, string DILCN)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_DILUTION SET DILCN = '" + DILCN + "' WHERE (QCTID = '" + QCTID + "' AND DILNO = '" + DILNO + "')";
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

        public static List<object[]> GetAllMWGTByID(string QCTID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QD.BATCH, QD.RNDDT, QT.QCTNM, IT.ITMNM, QD.CAGNO, QD.DILNO, QD.DILCN, QD.SMPNO
                            FROM biopm.QC_DILUTION QD, bioumum.ITEM IT, biopm.QC_TYPE QT, biopm.BATCH BT
                            WHERE IT.ITMID = QD.ITMID AND  QT.QCTYP = QD.QCTYP 
                            AND QD.QCTID  = '" + QCTID + "' GROUP BY QD.BATCH, QD.RNDDT, QD.RNDID, QT.QCTNM, IT.ITMNM,  QD.CAGNO, QD.DILNO, QD.DILCN, QD.SMPNO ORDER BY QD.CAGNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAllMWGTByIDUnsorted(string QCTID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QD.BATCH, QD.RNDDT, QT.QCTNM, IT.ITMNM, QD.CAGNO, QD.DILNO, QD.DILCN, QD.SMPNO
                            FROM biopm.QC_DILUTION QD, bioumum.ITEM IT, biopm.QC_TYPE QT, biopm.BATCH BT
                            WHERE IT.ITMID = QD.ITMID AND  QT.QCTYP = QD.QCTYP 
                            AND QD.QCTID  = '" + QCTID + "' GROUP BY QD.BATCH, QD.RNDDT, QD.RNDID, QT.QCTNM, IT.ITMNM,  QD.CAGNO, QD.DILNO, QD.DILCN, QD.SMPNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }


        public static object GetBatchDetailByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT BT.BTDET
                            FROM biopm.BATCH BT
                            WHERE BT.BATCH = '" + BATCH + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object sample = "";

                while (reader.Read())
                {
                    object values = reader[0].ToString();
                    sample = values;
                }

                return sample;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAllQCDilutionTestByID(string QCTID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT QD.BATCH, QD.RNDDT, QD.RNDID, QT.QCTNM, IT.ITMNM, QD.CAGNO, QD.DILNO, QD.DILCN, QD.SMPNO, AN.ANMTY
                            FROM biopm.QC_DILUTION QD, bioumum.ITEM IT, biopm.QC_TYPE QT, biopm.QC_ANIMAL AN, biopm.BATCH BT
                            WHERE IT.ITMID = QD.ITMID AND  QT.QCTYP = QD.QCTYP  AND QD.CAGNO = AN.CAGNO
                            AND  QD.RNDID = AN.RNDID AND QD.QCTID  = '" + QCTID + "' ORDER BY QD.DILNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString(), reader[8].ToString(), reader[9].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }


        public static List<object[]> GetConcentrationByBATCH(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DS.DILCN FROM biopm.QC_DILUTION_SAMPLE DS, biopm.BATCH BT
                            WHERE DS.BEGDA <= GETDATE() AND DS.ENDDA >= GETDATE() AND DS.PRDID = BT.PRDID AND BT.BATCH = '" + BATCH + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static int GetNumberOfDilutionByBatch(string BATCH)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(*) FROM biopm.QC_DILUTION_SAMPLE DS, biopm.BATCH BT
                            WHERE DS.BEGDA <= GETDATE() AND DS.ENDDA >= GETDATE() AND DS.PRDID = BT.PRDID AND BT.BATCH = '" + BATCH + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                int dilutions = 0;

                while (reader.Read())
                {
                    dilutions = Convert.ToInt16(reader[0]);
                }

                return dilutions;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetConcentrationByPRDID(string PRDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DS.DILCN FROM biopm.QC_DILUTION_SAMPLE DS
                            WHERE DS.BEGDA <= GETDATE() AND DS.ENDDA >= GETDATE() AND DS.PRDID = '" + PRDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> samples = new List<object[]>();

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString() };
                    samples.Add(values);
                }

                return samples;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAllBatch()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATCH, BT.PRDID FROM biopm.BATCH BT";
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

        public static List<object[]> GetAllBatchByCostCenter(string COCTR)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATCH, BT.PRDID FROM biopm.BATCH BT, bioumum.PRODUK_COST_CENTER PC
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

        public static List<object[]> GetBatchByNumberBatchPerDilution(string NPDIL)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT BT.BATCH
                            FROM biopm.QC_DILUTION_SAMPLE DS, biopm.BATCH BT
                            WHERE DS.BEGDA <= GETDATE() AND DS.ENDDA >= GETDATE() AND BT.PRDID = DS.PRDID
                            GROUP BY BT.BATCH HAVING COUNT(DS.PRDID) = '" + NPDIL + "'";
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


        public static DataTable GetAllQCDilutionTestBySampleCloned(string QCTID, string SMPNO)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT DILNO, DILCN
                            FROM biopm.QC_DILUTION
                            WHERE QCTID = '" + QCTID + "' AND SMPNO = '" + SMPNO + "' ORDER BY DILNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            DataTable dt = new DataTable();

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                dt.Load(reader);
                return dt;
            }
            finally
            {
                conn.Close();
            }
        }

        public static DataTable GetAllQCDilutionTestBySample(string QCTID, string SMPNO)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT CAGNO, DILNO, DILCN
                            FROM biopm.QC_DILUTION
                            WHERE QCTID = '" + QCTID + "' AND SMPNO = '" + SMPNO + "' ORDER BY DILNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);
            DataTable dt = new DataTable();

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                dt.Load(reader);
                return dt;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetQCDilutionTestByIDAndSampleNumber(string QCTID, string SMPNO)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT QD.BATCH, QD.SMPNO
                            FROM biopm.QC_DILUTION QD
                            WHERE QD.SMPNO = '" + SMPNO + "' AND QD.QCTID = '" + QCTID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] sample = null;

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    sample = values;
                }

                return sample;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetQCDilutionTestByIDAndDilutionNumber(string QCTID, string DILNO)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT QD.BATCH, QD.DILCN
                            FROM biopm.QC_DILUTION QD
                            WHERE QD.DILNO = '" + DILNO + "' AND QD.QCTID = '" + QCTID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] sample = null;

                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    sample = values;
                }

                return sample;
            }
            finally
            {
                conn.Close();
            }
        }



        public static void InsertNumberTest(int number, int random)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.ANIMAL_TEMP (ANMNO, ANMSH) 
                            VALUES('" + number + "', '" + random + "')";
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

        public static void DeleteNumberTest()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"DELETE FROM biopm.ANIMAL_TEMP";
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

        public static List<int> GetNumberTest()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT AT.ANMNO, AT.ANMSH
                              FROM biopm.ANIMAL_TEMP AT ORDER BY AT.ANMSH";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<int> numbers = new List<int>();
                while (reader.Read())
                {
                    numbers.Add(Convert.ToInt16(reader[0]));
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertAnimalTest(string randomid, string testdate, string animaltype, string animalnumber, string cagenumber, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_ANIMAL (RNDID, RNDDT, ITMID, CAGNO, ANMNO, ISUSD, CHGDT, USRDT) 
                            VALUES ('" + randomid + "','" + testdate + "','" + animaltype + "','" + cagenumber + "','" + animalnumber + "', '0', '" + date + "', '" + USRDT + "')";

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

        public static void UpdateAnimalTest(string RNDID, string CAGNO)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_ANIMAL SET ISUSD='1' WHERE (RNDID = '" + RNDID + "' AND CAGNO ='" + CAGNO + "')";

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

        public static int GetQCAnimalMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(RNDID) FROM biopm.QC_ANIMAL";
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

        public static List<object[]> GetAnimalMouseType()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT IT.ITMID, IT.ITMNM FROM bioumum.ITEM IT
                              WHERE IT.ITMGR = 'BYTIKUS'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalTestRandomDate()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QC.RNDID, QC.RNDDT, IT.ITMNM FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT WHERE IT.ITMID = QC.ITMID GROUP BY QC.RNDID, QC.RNDDT, IT.ITMNM ORDER BY QC.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalTestRandomDateByQCTYPE(string ITMID, string RNDDT)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT ROW_NUMBER() OVER (ORDER BY QC.RNDDT), QC.RNDID, QC.RNDDT, IT.ITMNM, QC.ITMID FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT 
                            WHERE IT.ITMID = QC.ITMID AND QC.RNDDT = '' AND QC.ITMID = '' GROUP BY QC.RNDID, QC.RNDDT, IT.ITMNM ORDER BY QC.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalTestRandomDateByQCTYPE(string QCTYP)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QC.RNDID, QC.RNDDT, IT.ITMNM, QT.QCTNM
                            FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT, biopm.QC_TYPE QT
                            WHERE IT.ITMID = QC.ITMID AND QC.QCTYP = QT.QCTYP AND QC.QCTYP = '" + QCTYP + "' GROUP BY QC.RNDID, QC.RNDDT, QT.QCTNM, IT.ITMNM ORDER BY QC.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalRandomDateByType(string QCTYP)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QC.RNDID, QC.RNDDT, IT.ITMNM
                            FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT 
                            WHERE IT.ITMID = QC.ITMID AND QC.QCTYP = '" + QCTYP + "' GROUP BY QC.RNDID, QC.RNDDT, IT.ITMNM, QC.ISUSD HAVING QC.ISUSD = '0' ORDER BY QC.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetQCTestRandomDate(string QCTYP)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QC.QCTID, QC.RNDDT, IT.ITMNM 
                            FROM biopm.QC_DILUTION QC, bioumum.ITEM IT 
                            WHERE IT.ITMID = QC.ITMID AND QC.QCTYP = '" + QCTYP + "' GROUP BY QC.QCTID, QC.RNDDT, IT.ITMNM ORDER BY QC.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetAllCageAndSampleDilutionNumberByID(string QCTID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT QC.CAGNO), COUNT(DISTINCT QC.SMPNO), COUNT(DISTINCT QC.DILNO)
                            FROM biopm.QC_DILUTION QC
                            WHERE QC.QCTID = '" + QCTID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] animaltest = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest = values;
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<int> GetCageNumberByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT CAGNO
                            FROM biopm.QC_ANIMAL
                            WHERE RNDID = '" + RNDID + "' AND ISUSD = '0' GROUP BY CAGNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<int> numbers = new List<int>();
                while (reader.Read())
                {
                    numbers.Add(Convert.ToInt16(reader[0].ToString()));
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<int> GetCageNumberMaleAnimalByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT [CAGNO]
                            FROM [BIOFARMA].[biopm].[QC_ANIMAL]
                            WHERE ISUSD = '0' AND RNDID = '" + RNDID + "' AND ANMTY = 'M' GROUP BY CAGNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<int> numbers = new List<int>();
                while (reader.Read())
                {
                    numbers.Add(Convert.ToInt16(reader[0].ToString()));
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<int> GetCageNumberFemaleAnimalByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT [CAGNO]
                            FROM [BIOFARMA].[biopm].[QC_ANIMAL]
                            WHERE ISUSD = '0' AND RNDID = '" + RNDID + "' AND ANMTY = 'F' GROUP BY CAGNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<int> numbers = new List<int>();
                while (reader.Read())
                {
                    numbers.Add(Convert.ToInt16(reader[0].ToString()));
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalTestByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT QC.RNDID, IT.ITMNM, QC.ANMNO, QC.CAGNO, QC.RNDDT, QC.ITMID
                            FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT
                            WHERE QC.ITMID = IT.ITMID AND IT.BEGDA <= QC.RNDDT AND IT.ENDDA >= QC.RNDDT AND
                            QC.RNDID = '" + RNDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetAllCageAndAnimalNumberByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT QC.CAGNO), COUNT(DISTINCT QC.ANMNO)
                            FROM biopm.QC_ANIMAL QC
                            WHERE QC.RNDID = '" + RNDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] animaltest = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    animaltest = values;
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetCageAndAnimalNumberByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT QC.CAGNO), COUNT(DISTINCT QC.ANMNO)
                            FROM biopm.QC_ANIMAL QC
                            WHERE QC.RNDID = '" + RNDID + "' AND QC.ISUSD = '0'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] animaltest = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    animaltest = values;
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalTest(string RNDID, string RNDDT)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QC.RNDID, IT.ITMNM, QC.ANMNO, QC.CAGNO, CONVERT(VARCHAR(11),QC.RNDDT,106)
                            FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT
                            WHERE QC.ITMID = IT.ITMID AND IT.BEGDA <= QC.RNDDT AND IT.ENDDA >= QC.RNDDT AND
                            QC.RNDID = '" + RNDID + "' AND QC.RNDDT = '" + RNDDT + "' ORDER BY QC.ANMNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static void InsertRawMaterialSample(string randomid, string testdate, string animaltype, string animalnumber, string cagenumber, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_RAW_MATERIAL (BATCH, ITMID, CAGNO, ANMNO, ISUSD, CHGDT, USRDT) 
                            VALUES ('" + randomid + "','" + testdate + "','" + animaltype + "','" + cagenumber + "','" + animalnumber + "', '0', '" + date + "', '" + USRDT + "')";

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

    public class DilutionCatalog : DatabaseFactory
    {
        public static void InsertDilution(string PRDID, string DILNO, string DILCN, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_DILUTION_SAMPLE (BEGDA, ENDDA, PRDID, DILNO, DILCN, CHGDT, USRDT) 
                            VALUES ('" + date + "','" + "12/31/9999" + "','" + PRDID + "','" + DILNO + "','" + DILCN + "', '" + date + "', '" + USRDT + "')";

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

        public static void DeleteDilution(string PRDID, string USRDT)
        {
            string yesterday = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_DILUTION_SAMPLE SET ENDDA = '" + yesterday + "' WHERE (PRDID = '" + PRDID + "')";

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

        public static List<object[]> GetDilutionByID(string PRDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PRDID, DILNO, DILCN FROM biopm.QC_DILUTION_SAMPLE
                            WHERE PRDID = '" + PRDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetDilutionByProductID(string PRDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT PRDID, DILNO, DILCN FROM biopm.QC_DILUTION_SAMPLE
                            WHERE PRDID = '" + PRDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }
    }


    public class NvtCatalog : DatabaseFactory
    {
        public static void InsertNVTBuilding(string BLDID, string BLDNM, string ITMID, string STRNO, string NOANM, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_NVT_BUILDING (BLDID, BLDNM, ITMID, STRNO, NOANM, CHGDT, USRDT)
                            VALUES ('" + BLDID + "','" + BLDNM + "','" + ITMID + "','" + STRNO + "','" + NOANM + "','" + date + "','" + USRDT + "');";
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

        public static void UpdateNVTBuilding(string BLDID, string BLDNM, string ITMID, string STRNO, string NOANM, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_NVT_BUILDING SET BLDNM = '" + BLDNM + "', ITMID = '" + ITMID + "', STRNO = '" + STRNO + "', NOANM ='" + NOANM + "', CHGDT = '" + date + "', USRDT = '" + USRDT + "' WHERE BLDID = '" + BLDID + "';";
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

        public static void DeleteNVTBuilding(string BLDID)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"DELETE FROM biopm.QC_NVT_BUILDING WHERE BLDID = '" + BLDID + "';";
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
        public static object[] GetDataNVTBuildingByID(string BLDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT NB.BLDID, NB.BLDNM, IT.ITMNM, NB.STRNO, NB.NOANM, IT.ITMID
                            FROM biopm.QC_NVT_BUILDING NB, bioumum.ITEM IT
                            WHERE IT.ITMID = NB.ITMID AND NB.BLDID = '" + BLDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] building = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    building = values;
                }
                return building;
            }
            finally
            {
                conn.Close();
            }
        }
        public static List<object[]> GetAllDataNVTBuilding()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT NB.BLDID, NB.BLDNM, IT.ITMNM, NB.STRNO, NB.NOANM
                            FROM biopm.QC_NVT_BUILDING NB, bioumum.ITEM IT
                            WHERE IT.ITMID = NB.ITMID";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetNvtRandom()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT RNDID, RNDDT, QCTYP, BLDNM, COUNT(*)
                            FROM biopm.QC_NVT GROUP BY RNDID, RNDDT, QCTYP, BLDNM";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> nvt = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    nvt.Add(values);
                }
                return nvt;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetDetailNVTRandombyRNDID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT BATCH), COUNT(ANMNO)
                            FROM biopm.QC_NVT WHERE RNDID = '" + RNDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] nvt = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    nvt = values;
                }
                return nvt;
            }
            finally
            {
                conn.Close();
            }
        }
        public static int GetNVTBuildingMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(BLDID) FROM biopm.QC_NVT_BUILDING";
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

        public static List<object[]> GetDataNVTBuilding()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT NB.BLDID, NB.BLDNM, IT.ITMNM, NB.STRNO, NB.NOANM
                            FROM biopm.QC_NVT_BUILDING NB, bioumum.ITEM IT
                            WHERE IT.ITMID = NB.ITMID";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetDataOfBuildingByID(string BLDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT NB.ITMID, NB.BLDNM FROM biopm.QC_NVT_BUILDING NB
                            WHERE NB.BLDID = '" + BLDID + "'";
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

        public static List<object[]> GetAnimalFromNVTBuilding()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT NB.BLDID, NB.BLDNM, IT.ITMNM, NB.NOANM 
                            FROM biopm.QC_NVT_BUILDING NB, bioumum.ITEM IT
                            WHERE NB.ITMID = IT.ITMID";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetNumberOfAnimalFromNVTBuilding(string BLDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT NB.STRNO, NB.NOANM FROM biopm.QC_NVT_BUILDING NB
                            WHERE NB.BLDID = '" + BLDID + "'";
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

        public static void InsertNVT(string RNDID, string RNDDT, string ITMID, string QCTYP, string BLDID, string BLDNM, string INJNO, string ANMNO, string BATCH, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_NVT (RNDID, RNDDT, ITMID, QCTYP, BLDID, BLDNM, INJNO, ANMNO, BATCH, ISUSD, CHGDT, USRDT) 
                            VALUES ('" + RNDID + "','" + RNDDT + "','" + ITMID + "','" + QCTYP + "','" + BLDID + "','" + BLDNM + "','" + INJNO + "','" + ANMNO + "','" + BATCH + "', '0', '" + date + "', '" + USRDT + "')";

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

        public static void UpdateAnimalRandom(string RNDID, string CAGNO, string BATCH)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_ANIMAL SET ISUSD='1' BATCH = '" + BATCH + "' WHERE (RNDID = '" + RNDID + "' AND CAGNO ='" + CAGNO + "')";

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

        public static int GetNVTMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(RNDID) FROM biopm.QC_NVT";
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

        public static List<object[]> GetNVTByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT QC.RNDID, IT.ITMNM, QC.ANMNO, QC.INJNO, QC.RNDDT, QC.ITMID, QC.BLDNM, QC.BATCH
                            FROM biopm.QC_NVT QC, bioumum.ITEM IT
                            WHERE QC.ITMID = IT.ITMID AND IT.BEGDA <= QC.RNDDT AND IT.ENDDA >= QC.RNDDT AND
                            QC.RNDID = '" + RNDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString(), reader[7].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }
    }

    public class RawMaterialCatalog : DatabaseFactory
    {
        public static void InsertRawMaterialSample(string BATCH, string RNDID, string QCMID, string RNDDT, string SMPNO, string SETNO, string ISUSD, string USRDT)
        {

            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_RAW_MATERIAL (BATCH, RNDID, QCMID, RNDDT, SMPNO, SETNO, ISUSD, CHGDT, USRDT) 
                            VALUES ('" + BATCH + "','" + RNDID + "','" + QCMID + "','" + RNDDT + "','" + SMPNO + "','" + SETNO + "', '" + ISUSD + "', '" + date + "', '" + USRDT + "')";

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

        public static void InsertRawMaterialNPlanSample(string BATCH, string RNDID, string QCMID, string RNDDT, string SMPNO, string SETNO, string PIENO, string ISUSD, string USRDT)
        {

            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_RAW_MATERIAL (BATCH, RNDID, QCMID, RNDDT, SMPNO, SETNO, PIENO, ISUSD, CHGDT, USRDT) 
                            VALUES ('" + BATCH + "','" + RNDID + "','" + QCMID + "','" + RNDDT + "','" + SMPNO + "','" + SETNO + "','" + PIENO + "', '" + ISUSD + "', '" + date + "', '" + USRDT + "')";

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

        public static void UpdateRawMaterialSample(string RNDID, string SMPNO, string SETNO)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_RAW_MATERIAL SET ISUSD='1', SMPNO = '" + SMPNO + "' WHERE (RNDID = '" + RNDID + "' AND SETNO ='" + SETNO + "')";

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

        public static void UpdateAvailableDateRawMaterialSample(string RNDID, string QCMID, string RNDDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_RAW_MATERIAL SET RNDDT ='" + RNDDT + "', QCMID = '" + QCMID + "' WHERE (RNDID = '" + RNDID + "' AND ISUSD ='0')";

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

        public static int GetRawMaterialMaxMaterialID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(QCMID) FROM biopm.QC_RAW_MATERIAL WHERE RNDID = '" + RNDID + "'";
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

        public static int GetRawMaterialMaxRandomID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(RNDID) FROM biopm.QC_RAW_MATERIAL";
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

        public static List<object[]> GetRawMaterialRandomDate()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT RM.BATCH, RM.RNDID, MAX(RM.RNDDT)
                            FROM biopm.QC_RAW_MATERIAL RM GROUP BY RM.BATCH, RNDID";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetRawMaterialRandomDateByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT RM.BATCH, RM.RNDID, RM.RNDDT, RW.BATCH, IT.ITMNM 
                            FROM biopm.QC_RAW_MATERIAL RM, bioumum.RAW_MATERIAL RW, bioumum.ITEM IT WHERE RM.RNDID = '" + RNDID + "' AND RM.BATCH = RW.GINNO AND RW.ITMID = IT.ITMID";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] material = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    material = values;
                }
                return material;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetRawMaterialSample()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT RM.BATCH, RM.RNDDT, RM.RNDID, RM.QCMID
                            FROM biopm.QC_RAW_MATERIAL RM GROUP BY RM.BATCH, RM.RNDID, RM.QCMID, RM.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> material = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    material.Add(values);
                }
                return material;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetRawMaterialSampleByID(string RNDID, string QCMID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT RM.BATCH, RM.RNDID, RM.RNDDT, RM.SETNO
                            FROM biopm.QC_RAW_MATERIAL RM
                            WHERE RM.RNDID = '" + RNDID + "' AND RM.QCMID = '" + QCMID + "' AND RM.ISUSD = '1'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> sample = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString() };
                    sample.Add(values);
                }
                return sample;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetRawMaterialNPlanSampleByID(string RNDID, string QCMID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT RM.BATCH, RM.RNDID, RM.RNDDT, RM.SETNO, RM.PIENO
                            FROM biopm.QC_RAW_MATERIAL RM
                            WHERE RM.RNDID = '" + RNDID + "' AND RM.QCMID = '" + QCMID + "' AND RM.ISUSD = '1' ORDER BY RM.SETNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> sample = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    sample.Add(values);
                }
                return sample;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetRawMaterialByID(string RNDID, string QCMID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT RM.BATCH, RM.RNDID, RM.RNDDT, RM.SMPNO, RM.SETNO, RM.PIENO 
                            FROM biopm.QC_RAW_MATERIAL RM
                            WHERE RM.RNDID ='" + RNDID + "' AND RM.QCMID = '" + QCMID + "' AND RM.ISUSD = '1' ORDER BY RM.SMPNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }
        public static int GetNumberOfSampleByID(string RNDID, string QCMID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(*)
                            FROM biopm.QC_RAW_MATERIAL RM 
                            WHERE RM.RNDID = '" + RNDID + "' AND RM.QCMID = '" + QCMID + "' AND RM.ISUSD = '1' GROUP BY RM.BATCH, RM.RNDID, RM.QCMID, RM.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                int numbers = 0;
                while (reader.Read())
                {
                    numbers = Convert.ToInt32(reader[0].ToString());
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }


        public static int GetAvailableNumberOfSetByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(*)
                            FROM biopm.QC_RAW_MATERIAL RM
                            WHERE RM.RNDID = '" + RNDID + "' AND RM.ISUSD = '0'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                int numbers = 0;
                while (reader.Read())
                {
                    numbers = Convert.ToInt32(reader[0].ToString());
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<int> GetAvailableSetNumberByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT RM.SETNO  
                            FROM biopm.QC_RAW_MATERIAL RM
                            WHERE RM.RNDID = '" + RNDID + "' AND RM.ISUSD = '0'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<int> numbers = new List<int>();
                while (reader.Read())
                {
                    numbers.Add(Convert.ToInt32(reader[0].ToString()));
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetRawMaterialRandom(string RNDID, string RNDDT)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }
    }

    public class AnimalRandomCatalog : DatabaseFactory
    {
        public static void InsertAnimalRandom(string RNDID, string RNDDT, string ITMID, string QCTYP, string ANMTY, string CAGNO, string ANMNO, string USRDT)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_ANIMAL (RNDID, RNDDT, ITMID, QCTYP, ANMTY, CAGNO, ANMNO, ISUSD, CHGDT, USRDT) 
                            VALUES ('" + RNDID + "','" + RNDDT + "','" + ITMID + "','" + QCTYP + "','" + ANMTY + "','" + CAGNO + "','" + ANMNO + "', '0', '" + date + "', '" + USRDT + "')";

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

        public static void UpdateAnimalRandom(string RNDID, string CAGNO, string BATCH)
        {
            string date = DateTime.Today.ToString("MM/dd/yyyy");
            SqlConnection conn = GetConnection();
            string sqlCmd = @"UPDATE biopm.QC_ANIMAL SET ISUSD='1' BATCH = '" + BATCH + "' WHERE (RNDID = '" + RNDID + "' AND CAGNO ='" + CAGNO + "')";

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

        public static int GetAnimalRandomMaxID()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT MAX(RNDID) FROM biopm.QC_ANIMAL";
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

        public static List<object[]> GetAnimalMonkeyType()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT ITMID, ITMNM
                            FROM bioumum.ITEM
                            WHERE ITMGR = 'BYKERA'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalMouseType()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT IT.ITMID, IT.ITMNM FROM bioumum.ITEM IT
                              WHERE IT.ITMGR = 'BYTIKUS'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalRandomDate(string QCTYP)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QC.RNDID, QC.RNDDT, IT.ITMNM FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT WHERE IT.ITMID = QC.ITMID AND QCTYP = '" + QCTYP + "' GROUP BY QC.RNDID, QC.RNDDT, IT.ITMNM ORDER BY QC.RNDDT";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object> GetAnimalGenderByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT ANMTY FROM biopm.QC_ANIMAL 
                            WHERE RNDID = '" + RNDID + "' GROUP BY ANMTY";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object> genders = new List<object>();
                while (reader.Read())
                {
                    object values = reader[0];
                    genders.Add(values);
                }
                return genders;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalRandomByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT QC.RNDID, IT.ITMNM, QC.ANMNO, QC.CAGNO, QC.RNDDT, QC.ITMID, QC.ANMTY
                            FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT
                            WHERE QC.ITMID = IT.ITMID AND IT.BEGDA <= QC.RNDDT AND IT.ENDDA >= QC.RNDDT AND
                            QC.RNDID = '" + RNDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetMultiAnimalRandomByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT DISTINCT QC.RNDID, IT.ITMNM, QC.ANMNO, QC.CAGNO, QC.RNDDT, QC.ITMID, QC.ANMTY
                            FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT
                            WHERE QC.ITMID = IT.ITMID AND IT.BEGDA <= QC.RNDDT AND IT.ENDDA >= QC.RNDDT AND
                            QC.RNDID = '" + RNDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString(), reader[5].ToString(), reader[6].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetAllCageAndAnimalNumberByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT QC.CAGNO), COUNT(DISTINCT QC.ANMNO)
                            FROM biopm.QC_ANIMAL QC
                            WHERE QC.RNDID = '" + RNDID + "'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] animaltest = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    animaltest = values;
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static object[] GetCageAndAnimalNumberByID(string RNDID)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT COUNT(DISTINCT QC.CAGNO), COUNT(DISTINCT QC.ANMNO)
                            FROM biopm.QC_ANIMAL QC
                            WHERE QC.RNDID = '" + RNDID + "' AND QC.ISUSD = '0'";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                object[] animaltest = null;
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString() };
                    animaltest = values;
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }

        public static List<object[]> GetAnimalRandomResult(string RNDID, string RNDDT)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT QC.RNDID, IT.ITMNM, QC.ANMNO, QC.CAGNO, CONVERT(VARCHAR(11),QC.RNDDT,106)
                            FROM biopm.QC_ANIMAL QC, bioumum.ITEM IT
                            WHERE QC.ITMID = IT.ITMID AND IT.BEGDA <= QC.RNDDT AND IT.ENDDA >= QC.RNDDT AND
                            QC.RNDID = '" + RNDID + "' AND QC.RNDDT = '" + RNDDT + "' ORDER BY QC.ANMNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<object[]> animaltest = new List<object[]>();
                while (reader.Read())
                {
                    object[] values = { reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), reader[3].ToString(), reader[4].ToString() };
                    animaltest.Add(values);
                }
                return animaltest;
            }
            finally
            {
                conn.Close();
            }
        }
    }

    public class RandomNumberCatalog : DatabaseFactory
    {
        public static void InsertRandomNumber(int number, int random)
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"INSERT INTO biopm.QC_RANDOM (SMPNO, RNDNO) 
                            VALUES('" + number + "', '" + random + "')";
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

        public static void DeleteRandomNumber()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"TRUNCATE TABLE biopm.QC_RANDOM";
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

        public static List<int> GetRandomNumber()
        {
            SqlConnection conn = GetConnection();
            string sqlCmd = @"SELECT RD.SMPNO, RD.RNDNO
                              FROM biopm.QC_RANDOM RD ORDER BY RD.RNDNO";
            SqlCommand cmd = GetCommand(conn, sqlCmd);

            try
            {
                conn.Open();
                SqlDataReader reader = GetDataReader(cmd);
                List<int> numbers = new List<int>();
                while (reader.Read())
                {
                    numbers.Add(Convert.ToInt16(reader[0]));
                }
                return numbers;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}