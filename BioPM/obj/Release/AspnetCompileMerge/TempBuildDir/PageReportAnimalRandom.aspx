<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageReportAnimalRandom.aspx.cs" Inherits="BioPM.PageReportAnimalRandom" %>

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
        if (Session["coctr"].ToString() != "52100" && Session["coctr"].ToString() != "52200" && Session["coctr"].ToString() != "64100") Response.Redirect("PageUserPanel.aspx");
        SetDataAnimalRandom();
    }

    protected string GetAnimalSex()
    {
        List<object> values = BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalGenderByID(Session["id"].ToString());
        if (values.Count > 1) return "Both";
        else if (values.Count > 0 && values[0].ToString() == "F") return "Female";
        else if (values.Count > 0 && values[0].ToString() == "M") return "Male";
        else return "Both";
    }

    protected void SetDataAnimalRandom()
    {
        object[] values = BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalRandomByID(Session["id"].ToString())[0];
        animaltype = values[1].ToString();
        testdate = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[4].ToString());
        anmsex = GetAnimalSex();
    }
    
    protected String GenerateAnimalRandomData()
    {
        string htmlelement = "";
        List<object[]> data = BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalRandomByID(Session["id"].ToString());
        int dataperpage = 216;
        int dataperfield = 36;
        int divideddata = data.Count / dataperpage;
        int lastdata = data.Count % dataperpage;
        int lastfield = lastdata / dataperfield;
        int lastdatafield = lastdata % dataperfield;

        if (Session["gentype"] != null) anmsex = "Male / Female";
        
        int init = 36;
        int seq = 0;
        int deret = (init * seq) + seq;

        for (int x = 0; x < divideddata + 1; x++)
        {
            if (x < divideddata)
            {
                htmlelement += "<table>";
                htmlelement += "<tr><td width='15%'>Test Date</td><td width='85%'> : "+ testdate +" </td></tr>";
                htmlelement += "<tr><td width='15%'>Animal Type</td><td width='85%'> : "+ animaltype +" </td></tr>";
                htmlelement += "<tr><td width='15%'>Animal Sex</td><td width='85%'> : "+ anmsex +"</td></tr>";
                htmlelement += "</table>";
                htmlelement += "<table border='0' >";
                htmlelement += "<thead>";
                htmlelement += "    <tr>";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";

                htmlelement += "    </tr>";
                htmlelement += "</thead>";

                for (int i = 0; i < dataperfield; i++)
                {
                    htmlelement += "<tr>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 3) + i])[6].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 4) + i])[6].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 5) + i])[6].ToString() + "</td>";
                    htmlelement += "</tr>";
                }
                htmlelement += "</table>";
            }
            else
            {
                htmlelement += "<table>";
                htmlelement += "<tr><td width='15%'>Test Date</td><td width='85%'> : " + testdate + " </td></tr>";
                htmlelement += "<tr><td width='15%'>Animal Type</td><td width='85%'> : " + animaltype + " </td></tr>";
                htmlelement += "<tr><td width='15%'>Animal Sex</td><td width='85%'> : " + anmsex + "</td></tr>";
                htmlelement += "</table>";
                htmlelement += "<table border='0' >";
                htmlelement += "<thead>";
                htmlelement += "    <tr>";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";
                htmlelement += "        <th width='9%'>Animal</th>";
                htmlelement += "        <th width='9%'>Cage</th>  ";

                htmlelement += "    </tr>";
                htmlelement += "</thead>";

                for (int i = 0; i < dataperfield; i++)
                {
                    switch (lastfield)
                    {
                        case 0 :
                            {
                                if (i < lastdatafield)
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                break;
                            }
                        case 1:
                            {
                                if (i < lastdatafield)
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) +(init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) +(init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) +(init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) +(init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                break;
                            }
                        case 2:
                            {
                                if (i < lastdatafield)
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                break;
                            }
                        case 3:
                            {
                                if (i < lastdatafield)
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 3) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                break;
                            }
                        case 4:
                            {
                                if (i < lastdatafield)
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 3) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 4) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 3) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                break;
                            }
                        case 5:
                            {
                                if (i < lastdatafield)
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 3) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 4) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 5) + i])[6].ToString() + "</td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 0) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 1) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 2) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 3) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "/" + (data[(dataperpage * x) + (init * 4) + i])[6].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                break;
                            }
                    }
                }
                htmlelement += "</table>";
            }
        }
        

        return htmlelement;
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body onload="printpage()">
    <form id="form1" runat="server">
    <div>
        
            <% Response.Write(GenerateAnimalRandomData()); %>
        
    </div>
    </form>
</body>
</html>
