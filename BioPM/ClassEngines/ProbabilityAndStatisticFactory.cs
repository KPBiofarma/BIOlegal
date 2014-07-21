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
            return ((Convert.ToDouble(value) - Convert.ToDouble(valueMean)) / Convert.ToDouble(deviasi));
        }

        /*
        public static double CalculateMean(string function)
        {
            double sum = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetImpactSumByFunction(function));
            double n = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function));
            return (sum / n);
        }

        public static double CalculateVariance(string function, double x)
        {
            double mean = BioPM.ClassEngines.ProbabilityAndStatisticFactory.CalculateMean(function);
            return (Math.Pow((x - mean), 2));
        }

        public static double CalculateStandardDeviation(string function)
        {
            double sum = 0;
            double n = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencyByFunction(function));
            foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetListofImpacts(function))
            {
                sum += CalculateVariance(function, Convert.ToDouble(data[0]));
            }
            return (sum / (n - 1));
        }
        */

        public static double CalculateMean()
        {
            double n = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetNumberofFunction());
            double sum = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencySum());
            return (sum / n);
        }

        public static double CalculateVariance(double mean, double x)
        {
            return (Math.Pow((x - mean), 2));
        }

        public static double CalculateStandardDeviation()
        {
            double sum = 0;
            double mean = CalculateMean();
            double n = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetNumberofFunction());
            foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetFrequenciesPerFunction())
            {
                sum += CalculateVariance(mean, Convert.ToDouble(data[1]));
            }
            return Math.Abs(( Math.Sqrt(sum / (n - 1)) ));
        }


        public static double Z_MAX = 6;
        public static double ROUND_FLOAT = 6;

        public static double poz(double z)
        {
            double y, x, w;

            if (z == 0.0) {
                x = 0.0;
            } else {
                y = 0.5 * Math.Abs(z);
                if (y > (Z_MAX * 0.5)) {
                    x = 1.0;
                } else if (y < 1.0) {
                    w = y * y;
                    x = ((((((((0.000124818987 * w
                                - 0.001075204047) * w + 0.005198775019) * w
                                - 0.019198292004) * w + 0.059054035642) * w
                                - 0.151968751364) * w + 0.319152932694) * w
                                - 0.531923007300) * w + 0.797884560593) * y * 2.0;
                } else {
                    y -= 2.0;
                    x = (((((((((((((-0.000045255659 * y
                                    + 0.000152529290) * y - 0.000019538132) * y
                                    - 0.000676904986) * y + 0.001390604284) * y
                                    - 0.000794620820) * y - 0.002034254874) * y
                                    + 0.006549791214) * y - 0.010557625006) * y
                                    + 0.011630447319) * y - 0.009279453341) * y
                                    + 0.005353579108) * y - 0.002141268741) * y
                                    + 0.000535310849) * y + 0.999936657524;
                }
            }
            return z > 0.0 ? ((x + 1.0) * 0.5) : ((1.0 - x) * 0.5);
        }

        public static double critz(double p)
        {
            double Z_EPSILON = 0.000001;     /* Accuracy of z approximation */
            double minz = -Z_MAX;
            double maxz = Z_MAX;
            double zval = 0.0;
            double pval;

            if (p < 0.0 || p > 1.0)
            {
                return -1;
            }

            while ((maxz - minz) > Z_EPSILON)
            {
                pval = poz(zval);
                if (pval > p)
                {
                    maxz = zval;
                }
                else
                {
                    minz = zval;
                }
                zval = (maxz + minz) * 0.5;
            }
            return (zval);
        }

    }
}