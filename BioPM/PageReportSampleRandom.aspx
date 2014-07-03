<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageReportSampleRandom.aspx.cs" Inherits="BioPM.PageReportSampleRandom" %>

<!DOCTYPE html>
<script type="text/javascript">
    function printpage() {
        window.print();
    }
</script>
<script runat="server">
    string qcname, testdate, animaltype, anmsex;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null && Session["password"] == null) Response.Redirect("PageLogin.aspx");
        if (Session["id"] == null) Response.Redirect("PageUserPanel.aspx");
        SetDataAnimalTest();
    }

    protected string GetAnimalSex(string ID)
    {
        List<object> values = BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalGenderByID(ID);
        if (values.Count > 1) return "Both";
        else if (values.Count > 0 && values[0].ToString() == "F") return "Female";
        else if (values.Count > 0 && values[0].ToString() == "M") return "Male";
        else return "Both";
    }
    
    protected void SetDataAnimalTest()
    {
        object[] values = BioPM.ClassObjects.QualityControlCatalog.GetAllQCDilutionTestByID(Session["id"].ToString())[0];
        qcname = values[3].ToString();
        testdate = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[1].ToString());
        animaltype = values[4].ToString();
        anmsex = GetAnimalSex(values[2].ToString());
    }
    
    protected String GenerateAnimalTestData()
    {
        string htmlelement = "";

        foreach (object[] data in BioPM.ClassObjects.QualityControlCatalog.GetAllQCDilutionTestByID(Session["id"].ToString()))
        {
            htmlelement += "<tr class=''><td>" + data[6].ToString() + "</td><td>" + data[5].ToString() + "</td><td>" + data[8].ToString() + "</td><td>" + data[0].ToString() + "</td><td>" + (data[7].ToString() == "0.0000" ? "" : data[7].ToString()) + "</td><td>" + BioPM.ClassObjects.QualityControlCatalog.GetBatchDetailByBatch(data[0].ToString()).ToString() + "</td></tr>";
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
            <tr><td width="15%">Item Name</td><td width="85%"> <% Response.Write(animaltype); %></td></tr>
            </table>
        <table >
            <thead>
                <tr>
                    <th width="10%">Dilution Number</th>
                    <th width="10%">Cage Number</th>
                    <th width="10%">Sample Number</th>
                    <th width="20%">Batch</th>
                    <th width="15%">Concentration</th>
                    <th width="20%">Detail</th>
                </tr>
            </thead>
            <% Response.Write(GenerateAnimalTestData()); %>
        </table>
    </div>
    </form>
</body>
</html>
