using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BioPM.ClassEngines
{
    public class MathFactory
    {
        public static int DoFactorial(string number)
        {
            int result = 1;
            for (int i = Convert.ToInt32(number); i >= 1; i--)
            {
                result *= i;
            }
            return result;
        }
    }

    public class ProbabilityAndStatisticFactory : MathFactory
    {
        public static double DoPoissonProbability(string occurrence, string occurrenceMean)
        {
            return (Math.Pow(Convert.ToDouble(occurrenceMean), Convert.ToDouble(occurrence)) * Math.Pow(Math.E, ((-1) * Convert.ToDouble(occurrenceMean)))) / Convert.ToDouble(DoFactorial(occurrence));
        }

        public static double DoBinomialProbability(string failure, string occcurrence, string sampleSuccess)
        {
            double sukses = 1-Convert.ToDouble(failure);
            double sample = Convert.ToDouble(DoFactorial(occcurrence)) / (Convert.ToDouble(DoFactorial(sampleSuccess) * Convert.ToDouble(DoFactorial((Convert.ToInt16(occcurrence) - Convert.ToInt16(sampleSuccess)).ToString()))));
            return (sample * Math.Pow(sukses, Convert.ToDouble(sampleSuccess)) * Math.Pow(Convert.ToDouble(failure), Convert.ToDouble((Convert.ToInt16(occcurrence) - Convert.ToInt16(sampleSuccess)))));
        }

        public static double DoNormalDistribution(string value, string valueMean, string deviasi)
        {
            return (Convert.ToDouble(value) - Convert.ToDouble(valueMean)) / Convert.ToDouble(deviasi);
        }

    }
}