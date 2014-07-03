using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BioPM.ClassEngines
{
    public class ValidationFactory
    {
        //validation dictionary : 
        // 1. Null Data Input (v)
        // 2. Mod : Not Zero Result (v)
        // 3. Compare 2 Integer or Decimal Value (v)
        // 4. Not Valid Input For Number Decimal (v)
        // 5. Not valid Input For Number Int (v)
        // 6. Not Valid Input For Text (v)
        // 7. Not Valid Positive Value
        // 8. Not Valid Zero Value
        // 9. Not valid Negative Value
        // 10. Data Not Found
        // 11. Password Not Match
        // 12. Input Null By 0 Number
        // 13. Password Format (alphabet, symbol, number)

        public static string GetErrorMessage(int validationid, string firstinput, string secondinput)
        {
            switch (validationid)
            {
                case 1:
                    {
                        return "INPUT DATA FOR " + firstinput + " IS NULL!";
                    }
                case 2:
                    {
                        return "MOD RESULT BETWEEN " + firstinput + " WITH " + secondinput + " IS NOT ZERO!";
                    }
                case 3:
                    {
                        return "INPUT VALUE " + firstinput + " IS SMALLER THAN "+ secondinput +"!";
                    }
                case 4:
                    {
                        return "INPUT DATA " + firstinput + " AS DECIMAL IS NOT VALID!";
                    }
                case 5:
                    {
                        return "INPUT DATA " + firstinput + " AS NUMBER IS NOT VALID!";
                    }
                case 6:
                    {
                        return "INPUT DATA " + firstinput + " AS TEXT IS NOT VALID!";
                    }
                case 7:
                    {
                        return "INPUT VALUE FOR " + firstinput + " IS NOT VALID / MUST POSITIVE VALUE!";
                    }
                case 8:
                    {
                        return "INPUT VALUE FOR " + firstinput + " IS NOT VALID / NOT ZERO VALUE!";
                    }
                case 9:
                    {
                        return "INPUT VALUE FOR " + firstinput + " IS NOT VALID / MUST NEGATIVE VALUE!";
                    }
                case 10:
                    {
                        return "DATA " + firstinput + " NOT FOUND FROM DATABASE";
                    }
                case 11:
                    {
                        return "" + firstinput + " IS NOT MATCHED";
                    }
                case 12:
                    {
                        return "INPUT DATA FOR " + firstinput + " IS NULL! SET 0 IF YOU WANT TO IGNORE NULL.";
                    }
                case 13:
                    {
                        return "INPUT DATA " + firstinput + " NOT VALID FORMAT! AT LEAST HAVE ALPHABET, NUMBER, SYMBOL, AND MINIMUM 8 CHARACTERS";
                    }
                default:
                    {
                        return "";
                    }
            }
        }

        public static bool ValidatePasswordConfirmation(string password, string confirm)
        {
            if (password != confirm)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateNullInput(string data)
        {
            if (data.Length == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateToCompareValue(int smallvalue, int bigvalue)
        {
            if (smallvalue > bigvalue)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateToCompareValue(decimal smallvalue, decimal bigvalue)
        {
            if (smallvalue > bigvalue)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidatePositiveValue(int value)
        {
            if (value < 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidatePositiveValue(decimal value)
        {
            if (value < 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateNegativeValue(int value)
        {
            if (value >= 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateNegativeValue(decimal value)
        {
            if (value >= 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateZeroValue(int value)
        {
            if (value == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateZeroValue(decimal value)
        {
            if (value == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateModResult(int value, int divider)
        {
            if (value % divider != 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static bool ValidateTextInput(string data)
        {
            bool isValid = true;
            for (int i = 0; i < data.Length; i++)
            {
                if (((int)data[i] < 'A' || (int)data[i] > 'Z') && ((int)data[i] < 'a' || (int)data[i] > 'z'))
                {
                    isValid = false;
                    break;
                }       
            }

            return isValid;
        }

        public static bool ValidateNumberIntInput(string data)
        {
            bool isValid = true;
            for (int i = 0; i < data.Length; i++)
            {
                if ((int)data[i] < '0' || (int)data[i] > '9')
                {
                    isValid = false;
                    break;
                }       
            }

            return isValid;
        }

        public static bool ValidateNumberDecInput(string data)
        {
            bool isValid = false;
            int counter = 0;
            for (int i = 0; i < data.Length; i++)
            {
                if ((int)data[i] == '.' && i == 0)
                {
                    isValid = false;
                    break;
                }
                else if ((int)data[i] == '.')
                {
                    counter++;
                    if (counter == 1)
                    {
                        isValid = true;
                    }
                    else
                    {
                        isValid = false;
                        break;
                    }
                }
                else if ((int)data[i] < '0' || (int)data[i] > '9')
                {
                    isValid = false;
                    break;
                }
            }

            return isValid;
        }

        public static bool ValidatePasswordCombination(string data)
        {
            bool isSymbol = false, isAlphabet = false, isNumber = false, isLength = false;

            if (data.Length >= 8)
            {
                isLength = true;

                for (int i = 0; i < data.Length; i++)
                {
                    if (((int)data[i] < 'A' || (int)data[i] > 'Z') && ((int)data[i] < 'a' || (int)data[i] > 'z') && ((int)data[i] < '0' || (int)data[i] > '9'))
                    {
                        isSymbol = true;
                    }
                    if (((int)data[i] >= 'A' || (int)data[i] <= 'Z') || ((int)data[i] >= 'a' || (int)data[i] <= 'z'))
                    {
                        isAlphabet = true;
                    }
                    if (((int)data[i] >= '0' || (int)data[i] <= '9'))
                    {
                        isNumber = true;
                    }
                }
            }

            if (isAlphabet && isNumber && isSymbol && isLength) return true;
            else return false;
        }
    }
}