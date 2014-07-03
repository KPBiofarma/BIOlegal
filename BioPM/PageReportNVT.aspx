<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageReportNVT.aspx.cs" Inherits="BioPM.PageReportNVT" %>

<!DOCTYPE html>
<script type="text/javascript">
    function printpage() {
        window.print();
    }
</script>
<script runat="server">
    string testdate, animaltype, anmsex;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["id"] == null) Response.Redirect("PageUserPanel.aspx");
        SetDataAnimalRandom();
    }

    protected void SetDataAnimalRandom()
    {
        object[] values = BioPM.ClassObjects.NvtCatalog.GetNVTByID(Session["id"].ToString())[0];
        testdate = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[4].ToString());
        anmsex = "-";
        animaltype = values[1].ToString();
    }
    
    protected String GenerateAnimalRandomData()
    {
        string htmlelement = "";

        foreach (object[] data in BioPM.ClassObjects.NvtCatalog.GetNVTByID(Session["id"].ToString()))
        {
            htmlelement += "<tr><td align='center'>" + data[2].ToString() + "</td><td align='center'>" + data[3].ToString() + "</td><td align='center'>" + data[7].ToString() + "</td><td align='center'>" + "" + "</td></tr>";
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
            <tr><td width="15%">Test Date</td><td width="85%"> <% Response.Write(testdate); %></td></tr>
            <tr><td width="15%">Animal Type</td><td width="85%"> <% Response.Write(animaltype); %></td></tr>
        </table>
    </div>
    <div>
        <table >
            <thead>
                <tr>
                    <th>Animal Number</th>
                    <th>Injection Number</th>
                    <th>Batch</th>
                    <th>Annotation</th>
                </tr>
            </thead>
            <tbody>
            <% Response.Write(GenerateAnimalRandomData()); %>
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
