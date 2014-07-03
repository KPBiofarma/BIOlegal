<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageReportRawMaterialRandom.aspx.cs" Inherits="BioPM.PageReportRawMaterialRandom" %>

<!DOCTYPE html>
<script type="text/javascript">
    function printpage() {
        window.print();
    }
</script>
<script runat="server">
    string batch, rnddt;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["id"] == null) Response.Redirect("PageUserPanel.aspx");
        SetDataRawMaterial();
    }

    protected string GetAnimalSex(string data)
    {
        if (data == "M") return "Male";
        else if (data == "F") return "Female";
        else return "Both";
    }

    protected void SetDataRawMaterial()
    {
        object[] values = BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialRandomDateByID(Session["id"].ToString());
        batch = values[0].ToString();
        rnddt = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[2].ToString());
    }
    
    protected String GenerateAnimalRandomData()
    {
        string htmlelement = "";
        int index = 1;

        foreach (object[] data in BioPM.ClassObjects.RawMaterialCatalog.GetRawMaterialSampleByID(Session["id"].ToString(), Session["idm"].ToString()))
        {
            htmlelement += "<tr><td align='center'>" + index.ToString() + "</td><td align='center'>" + data[3].ToString() + "</td></tr>";
            index++;
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
            <tr><td width="15%">GIN</td><td width="85%"> <% Response.Write(batch); %></td></tr>
            <tr><td width="15%">Random Date</td><td width="85%"> <% Response.Write(rnddt); %></td></tr>
            </table>
        <table >
            <thead>
                <tr>
                    <th>Number</th>
                    <th>Sample Number</th>
                </tr>
            </thead>
            <% Response.Write(GenerateAnimalRandomData()); %>
        </table>
    </div>
    </form>
</body>
</html>
