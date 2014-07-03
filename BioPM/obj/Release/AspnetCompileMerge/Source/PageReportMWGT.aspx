<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageReportMWGT.aspx.cs" Inherits="BioPM.PageReportMWGT" %>

<!DOCTYPE html>
<script type="text/javascript">
    function printpage() {
        window.print();
    }
</script>
<script runat="server">
    string qcname, testdate, animaltype;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["id"] == null) Response.Redirect("PageUserPanel.aspx");
        if (Session["coctr"].ToString() != "52100" && Session["coctr"].ToString() != "64100") Response.Redirect("PageUserPanel.aspx");
        SetDataAnimalTest();
    }
    
    protected void SetDataAnimalTest()
    {
        object[] values = BioPM.ClassObjects.QualityControlCatalog.GetAllMWGTByID(Session["id"].ToString())[0];
        qcname = values[2].ToString();
        testdate = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[1].ToString());
        animaltype = values[3].ToString();
    }
    
    protected String GenerateAnimalTestData()
    {
        string htmlelement = "";

        foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAllMWGTByID(Session["id"].ToString()))
        {
            htmlelement += "<tr><td align='center'>" + data[4].ToString() + "</td><td align='center'>" + data[7].ToString() + "</td><td align='center'>" + data[0].ToString() + "</td><td align='center'>" + BioPM.ClassObjects.QualityControlCatalog.GetBatchDetailByBatch(data[0].ToString()).ToString() + "</td></tr>";
        }

        return htmlelement;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body onload="printpage()">
    <link rel="stylesheet" type="text/css" href="Scripts/tablezebra.css" />
    <form id="form1" runat="server">
    <div>
        <table>
            <tr><td width="15%">Test Name</td><td width="85%"> <% Response.Write(qcname); %></td></tr>
            <tr><td width="15%">Random Date</td><td width="85%"> <% Response.Write(testdate); %></td></tr>
            <tr><td width="15%">Animal Name</td><td width="85%"> <% Response.Write(animaltype); %></td></tr>
            </table>
        <table >
            <thead>
                <tr>
                    <th>Cage Number</th>
                    <th>Sample Number</th>
                    <th>Batch</th>
                    <th>Detail</th>
                </tr>
            </thead>
            <% Response.Write(GenerateAnimalTestData()); %>
        </table>
    </div>
    </form>
</body>
</html>
