<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageRiskRating.aspx.cs" Inherits="BioPM.PageRiskRating" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        SetDataTest();
    }

    protected void sessionCreator()
    {
        Session["username"] = "K495";
        Session["name"] = "ALLAN PRAKOSA";
        Session["password"] = "admin1234";
        Session["role"] = "111111";
    }

    string[] _ylegends;
    string[] _xlegends;
    string[,] _values;
    double[] _ruleRanges;
    double[] _ruleRangesX;
    double[] _ruleRangesY;
    int[] _ruleResult;
    
    protected void SetDataTest()
    {
        //BioPM.ClassObjects.RiskCatalog.GetRiskByStat();

        double maksX = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetMaxRiskImpact());
        double minX = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetMinRiskImpact());
        double maksY = Convert.ToDouble(Convert.ToDecimal(BioPM.ClassObjects.RiskCatalog.GetMaxRiskFrequency()));
        double minY = Convert.ToDouble(Convert.ToDecimal(BioPM.ClassObjects.RiskCatalog.GetMinRiskFrequency()));
        double selisihX = maksX - minX;
        double selisihY = maksY - minY;
        double resultX = selisihX / 5;
        double resultY = selisihY / 5;

        double rangeX1 = minX + resultX;
        double rangeX2 = rangeX1 + resultX;
        double rangeX3 = rangeX2 + resultX;
        double rangeX4 = rangeX3 + resultX;
        double rangeX5 = rangeX4 + resultX;

        double rangeY1 = minY + resultY;
        double rangeY2 = rangeY1 + resultY;
        double rangeY3 = rangeY2 + resultY;
        double rangeY4 = rangeY3 + resultY;
        double rangeY5 = rangeY4 + resultY;
        
        
        
        _ylegends = new string[5] { "Rare", "Possible", "Likely", "Certain", "Almost" };
        _xlegends = new string[5] { "Insignificant", "Minor", "Moderate", "Major", "Extreme" };
        _values = new string[5, 5] { { "1.3", "2.1", "4.3", "3.3", "5.3" }, 
                                     { "1.8", "2.3", "4.3", "3.3", "5.8"}, 
                                     { "1.3", "2.2", "1.1", "8.3", "6.7"}, 
                                     { "1.2", "2.3", "2.9", "3.3", "7.3"}, 
                                     { "1.1", "2.5", "6.3", "8.3", "6.3"} };
        _ruleRanges = new double[5] { 1.0, 3.0, 5.0, 7.0, 9.0 };
        _ruleRangesX = new double[5] { rangeX1, rangeX2, rangeX3, rangeX4, rangeX5 };
        _ruleRangesY = new double[5] { rangeY1, rangeY2, rangeY3, rangeY4, rangeY5 };
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
<html lang="en">
<head>
    <% Response.Write(BioPM.ClassScripts.BasicScripts.GetMetaScript()); %>

    <title>RISK MAP</title>
    
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetCoreStyle()); %>
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetTableStyle()); %>
<% Response.Write(BioPM.ClassScripts.StyleScripts.GetCustomStyle()); %>
</head>
<body>

<section id="Section1" >
 
<!--header start--> 
 <%Response.Write( BioPM.ClassScripts.SideBarMenu.TopMenuElement(Session["name"].ToString())); %> 
<!--header end-->
   
<!--left side bar start-->
 <%Response.Write(BioPM.ClassScripts.SideBarMenu.LeftSidebarMenuElementAutoGenerated(Session["username"].ToString())); %> 
<!--left side bar end-->

    <!--main content start-->
    <section id="main-content">
        <section class="wrapper">
        <!-- page start-->

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

        <!-- page end-->
        </section>
    </section>
    <!--main content end-->
<!--right sidebar start-->
    <%Response.Write( BioPM.ClassScripts.SideBarMenu.RightSidebarMenuElement() ); %> 
<!--right sidebar end-->
</section>

<!-- Placed js at the end of the document so the pages load faster -->
<% Response.Write(BioPM.ClassScripts.JS.GetCoreScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetDynamicTableScript()); %>
<% Response.Write(BioPM.ClassScripts.JS.GetInitialisationScript()); %>
</body>

</html>
