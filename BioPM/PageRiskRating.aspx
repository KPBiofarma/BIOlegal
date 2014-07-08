<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageRiskRating.aspx.cs" Inherits="BioPM.PageRiskRating" %>

<!DOCTYPE html>
<script runat="server">
    string[] _ylegends;
    string[] _xlegends;
    string[,] _values;
    double[] _ruleRanges;
    int[] _ruleResult;

    protected void Page_Load(object sender, EventArgs e)
    {
        SetDataTest();
    }

    protected void SetDataTest()
    {
        _ylegends = new string[5] { "Y1", "Y2", "Y3", "Y4", "Y5" };
        _xlegends = new string[5] { "X1", "X2", "X3", "X4", "X5" };
        _values = new string[5, 5] { { "1.3", "2.1", "4.3", "3.3", "5.3" }, 
                                     { "1.8", "2.3", "4.3", "3.3", "5.8"}, 
                                     { "1.3", "2.2", "1.1", "8.3", "6.7"}, 
                                     { "1.2", "2.3", "2.9", "3.3", "7.3"}, 
                                     { "1.1", "2.5", "6.3", "8.3", "6.3"} };
        _ruleRanges = new double[5] { 1.0, 3.0, 5.0, 7.0, 9.0 };
        _ruleResult = new int[4] { 1, 2, 3, 4 };
    }

    enum Color : int
    {
        forestgreen = 1, yellow, orange, red,
    }

    private static T1 NumToEnum<T1>(int number)
    {
        return (T1)Enum.ToObject(typeof(T1), number);
    }

    protected String CreateAxisY(string[] ylegend)
    {
        StringBuilder str = new StringBuilder();
        
        for(int i = 0; i < ylegend.Length; i++)
        {
            str.Append("<tr><th align='right'>"+ ylegend[i] +"</th></tr>");
        }

        return str.ToString();
    }

    protected String CreateAxisX(string[] xlegend)
    {
        StringBuilder str = new StringBuilder();

        for (int i = 0; i < xlegend.Length; i++)
        {
            str.Append("<th>" + xlegend[i] + "</th>");
        }
        
        return str.ToString();
    }
    
    protected String CreateRatingValue(string[,] value)
    {
        StringBuilder str = new StringBuilder();
        
        for (int i = 0; i < value.GetLength(0); i++)
        {
            str.Append("<tr>");
            for (int j = 0; j < value.GetLength(1); j++)
            {
                str.Append("<td style='background-color:" + NumToEnum<Color>(GetRuleResult(_ruleRanges, _ruleResult, value[i,j])).ToString() +"'></td>");
            }
            str.Append("</tr>");
        }
        return str.ToString();
    }

    protected int GetRuleResult(double[] ruleRanges, int[] result, string value)
    {
        int index = 0;
        
        for(int i = 0; i < ruleRanges.Length - 1; i++)
        {
            if (Convert.ToDouble(value) >= ruleRanges[i] && Convert.ToDouble(value) < ruleRanges[i+1])
            {
                break;
            }
            index++;
        }
        
        return result[index];
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <link rel="stylesheet" type="text/css" href="Scripts/tablezebra.css" />
    <form id="form1" runat="server">
    <div>
        <table>
            <thead>
                
            </thead>
            <tbody>
            <tr>
            <td rowspan="5" style="width:90px">  
                <table>
            <thead>
                
            </thead>
            <tbody>
                <% Response.Write(CreateAxisY(_ylegends)); %>
            </tbody>
            <tfoot>
                 <tr>
                    <th></th>
                 </tr>
            </tfoot>
            </table>
            </td>
            <td rowspan="5"><table >
            <thead>
                
            </thead>
            <tbody> <!-- Refactor later : Value and Rule -->
                <% Response.Write(CreateRatingValue(_values)); %>
            </tbody>
            <tfoot>
                <tr>
                    <% Response.Write(CreateAxisX(_xlegends)); %>
                </tr>
            </tfoot>
            </table></td></tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
            </tbody>
            <tfoot>
            </tfoot>
        </table>
    </div>
    </form>
</body>
</html>
