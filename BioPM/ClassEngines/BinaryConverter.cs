using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BioPM.ClassEngines
{
    //Updated last 2011,
    //To perform fixed binary length
    //To support  menu configuration such as : CRUD + DOWNLOAD/EXPORT + PRINT

    public class BinaryConverter
    {
        protected class BinnaryToDecimal
        {
            public int bin;
            public string stringProg;
            public int dec;

            public BinnaryToDecimal(string number) { bin = int.Parse(number); }

            protected void countDer(int der)
            {
                int hasIn = 1;

                for (int i = 1; i < der; i++)
                {
                    hasIn = hasIn * 2;
                }
                dec += hasIn;
            }

            public void Converter()
            {
                stringProg = bin.ToString();
                int deriv = stringProg.Length;

                foreach (char value in stringProg)
                {
                    if (value == '1')
                    {
                        countDer(deriv);
                    }
                    deriv--;
                }
            }

        }

        protected class DecimalToBinnary
        {
            public int dec;
            public char[] chargeValue = new char[6];
            public string bin;
            public int n;

            public DecimalToBinnary(string number) { this.dec = int.Parse(number); }

            public void Converter()
            {
                int value = dec;
                int index = 0;
                string result = "";

                while (index != 6)
                {
                    if (value > 1)
                    {
                        result = char.Parse((value % 2).ToString()) + result;
                    }
                    else if (value == 1 || value == 0)
                    {
                        result = char.Parse((value).ToString()) + result;
                    }
                    else
                    {
                        result = '0' + result;
                    }
                    
                    if (value <= 0) value--;
                    else value = value / 2;
                    index++;
                }
                bin = result;
            }
            
        }

        public class Converter
        {
            public static String BinaryToDecimal(string number)
            {
                BinnaryToDecimal num = new BinnaryToDecimal(number);
                num.Converter();
                return num.dec.ToString(); 
            }

            public static String DecimalToBinary(string number)
            {
                DecimalToBinnary num = new DecimalToBinnary(number);
                num.Converter();
                return num.bin.ToString();
            }
        }
    }
}