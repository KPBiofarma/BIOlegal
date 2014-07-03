<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportCloned.aspx.cs" Inherits="BioPM.ReportCloned" %>
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
        Session["id"] = "6";
        SetDataAnimalRandom();
    }

    protected string GetAnimalSex(string data)
    {
        if (data == "M") return "Male";
        else if (data == "F") return "Female";
        else return "-";
    }
    
    protected void SetDataAnimalRandom()
    {
        object[] values = BioPM.ClassObjects.AnimalRandomCatalog.GetAnimalRandomByID(Session["id"].ToString())[0];
        testdate = BioPM.ClassEngines.DateFormatFactory.GetDateFormat(values[4].ToString());
        anmsex = GetAnimalSex(values[6].ToString());
        animaltype = values[1].ToString();
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
        //
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
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "</td>";
                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[3].ToString() + "</td>";
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
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * (x - 1)) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * (x - 1)) + (init * 0) + i])[3].ToString() + "</td>";
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
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
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
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
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
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'></td><td align='center'></td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "</td>";
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
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 5) + i])[3].ToString() + "</td>";
                                    htmlelement += "</tr>";
                                }
                                else
                                {
                                    htmlelement += "<tr>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 0) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 1) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 2) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 3) + i])[3].ToString() + "</td>";
                                    htmlelement += "<td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[2].ToString() + "</td><td align='center'>" + (data[(dataperpage * x) + (init * 4) + i])[3].ToString() + "</td>";
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
