<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageDummy.aspx.cs" Inherits="BioPM.PageDummy" %>

<!DOCTYPE html>
<script runat="server">
    protected void btnMax_Click(object sender, EventArgs e)
    {
        lbTest.Text = BioPM.ClassObjects.RiskCatalog.GetMaxRiskFrequency().ToString();
    }

    protected void btnMin_Click(object sender, EventArgs e)
    {
        lbTest.Text = BioPM.ClassObjects.RiskCatalog.GetMinRiskFrequency().ToString();
    }

    protected void btnGet_Click(object sender, EventArgs e)
    {
        double max = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetMaxRiskImpact());
        double min = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetMinRiskImpact());
        double selisih = max - min;
        double hasilbagi = selisih / 5;

        double range1 = min + hasilbagi;
        double range2 = range1 + hasilbagi;
        double range3 = range2 + hasilbagi;
        double range4 = range3 + hasilbagi;
        double range5 = range4 + hasilbagi; 
       
        lbTest.Text = selisih.ToString();

        Label1.Text = range1.ToString();
        Label2.Text = range2.ToString();
        Label3.Text = range3.ToString();
        Label4.Text = range4.ToString();
        Label5.Text = range5.ToString();   
    }

    protected void btnFrq_Click(object sender, EventArgs e)
    {
        double max = Convert.ToDouble(Convert.ToDecimal(BioPM.ClassObjects.RiskCatalog.GetMaxRiskFrequency()));
        double min = Convert.ToDouble(Convert.ToDecimal(BioPM.ClassObjects.RiskCatalog.GetMinRiskFrequency()));
        double selisih = max - min;
        double hasilbagi = selisih / 5;

        double range1 = min + hasilbagi;
        double range2 = range1 + hasilbagi;
        double range3 = range2 + hasilbagi;
        double range4 = range3 + hasilbagi;
        double range5 = range4 + hasilbagi;

        lbTest.Text = selisih.ToString();

        Label1.Text = range1.ToString();
        Label2.Text = range2.ToString();
        Label3.Text = range3.ToString();
        Label4.Text = range4.ToString();
        Label5.Text = range5.ToString(); 
    }

    protected double CalcMean()
    {
        double sumf = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetFrequencySum());
        double numf = Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetNumberofFunction());
        return sumf / numf;
    }

    protected double ProcStdDev(double x)
    {
        double mean = CalcMean();
        return Math.Pow((x - mean), 2);
    }

    protected double CalcStdDev()
    {
        double i = 0;

        foreach (object[] data in BioPM.ClassObjects.RiskCatalog.GetFrequenciesPerFunction())
        {
            i += ProcStdDev(Convert.ToDouble(data[1].ToString()));
        }

        return Math.Sqrt(i / (Convert.ToDouble(BioPM.ClassObjects.RiskCatalog.GetNumofData()) - 1));
    }
    
    
    protected void btnTesProb_Click(object sender, EventArgs e)
    {
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Button ID="btnMax" runat="server" AutoPostBack="true" Text="Get Max" OnClick="btnMax_Click"/>
        <asp:Button ID="btnMin" runat="server" AutoPostBack="true" Text="Get Min" OnClick="btnMin_Click"/>
        <asp:Button ID="btnGet" runat="server" AutoPostBack="true" Text="Get Range" OnClick="btnGet_Click" />
        <asp:Button ID="btnFrq" runat="server" AutoPostBack="true" Text="Get Freq" OnClick="btnFrq_Click" />
        <asp:Label ID="lbTest" runat="server" AutoPostBack="true"></asp:Label>  <br />
        <asp:Label ID="Label1" runat="server" AutoPostBack="true"></asp:Label>  <br />
        <asp:Label ID="Label2" runat="server" AutoPostBack="true"></asp:Label>  <br />   
        <asp:Label ID="Label3" runat="server" AutoPostBack="true"></asp:Label>  <br />
        <asp:Label ID="Label4" runat="server" AutoPostBack="true"></asp:Label>  <br />
        <asp:Label ID="Label5" runat="server" AutoPostBack="true"></asp:Label>  <br /> 
        <asp:Button ID="btnTesProb" runat="server" AutoPostBack="true" OnClick="btnTesProb_Click" />
        <asp:Label ID="lbTesPron" runat="server" AutoPostBack="true"></asp:Label>               
    </div>
    </form>
</body>
</html>
