using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace BioPM.ClassScripts
{
    public class JS
    {
        private static String SetCoreScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<script src='Scripts/UserPanel/js/lib/jquery.js'></script>                                                         ");
            sb.Append("<script src='Scripts/UserPanel/js/lib/jquery-1.8.3.min.js'></script>                                                            ");
            sb.Append("<script src='Scripts/UserPanel/bs3/js/bootstrap.min.js'></script>                                                               ");
            sb.Append("<script class='include' type='text/javascript' src='Scripts/UserPanel/js/accordion-menu/jquery.dcjqaccordion.2.7.js'></script>  ");
            sb.Append("<script src='Scripts/UserPanel/js/lib/jquery-ui-1.9.2.custom.min.js'></script>");
            sb.Append("<script src='Scripts/UserPanel/js/scrollTo/jquery.scrollTo.min.js'></script>                                                    ");
            sb.Append("<script src='Scripts/UserPanel/js/nicescroll/jquery.nicescroll.js' type='text/javascript'></script>							   ");
            return sb.ToString();
        }

        public static String GetCoreScript()
        {
            return SetCoreScript();
        }

        private static String SetDynamicTableScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<!--dynamic table-->																			                                       ");
            sb.Append("<script type='text/javascript' language='javascript' src='Scripts/UserPanel/assets/advanced-datatable/media/js/jquery.dataTables.js'></script>   ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/data-tables/DT_bootstrap.js'></script>                                              ");
            sb.Append("<!--dynamic table initialization -->                                                                                                             ");
            sb.Append("<script src='Scripts/UserPanel/js/dynamic_table/dynamic_table_init.js'></script>                                                                 ");
            return sb.ToString();
        }
        
        public static String GetDynamicTableScript()
        {
            return SetDynamicTableScript();
        }

        private static String SetInitialisationScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<script src='Scripts/UserPanel/js/scripts.js'></script>");
            return sb.ToString();
        }

        public static String GetInitialisationScript()
        {
            return SetInitialisationScript();
        }

        private static String SetCustomFormScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<script src='Scripts/UserPanel/assets/bootstrap-switch-master/build/js/bootstrap-switch.js'></script>                            ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/fuelux/js/spinner.min.js'></script>                                 ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-fileupload/bootstrap-fileupload.js'></script>             ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-wysihtml5/wysihtml5-0.3.0.js'></script>                   ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-wysihtml5/bootstrap-wysihtml5.js'></script>               ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-datepicker/js/bootstrap-datepicker.js'></script>          ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js'></script>  ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-daterangepicker/moment.min.js'></script>                  ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-daterangepicker/daterangepicker.js'></script>             ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-colorpicker/js/bootstrap-colorpicker.js'></script>        ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-timepicker/js/bootstrap-timepicker.js'></script>          ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/jquery-multi-select/js/jquery.multi-select.js'></script>            ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/jquery-multi-select/js/jquery.quicksearch.js'></script>             ");
            sb.Append("<script src='Scripts/UserPanel/js/toggle-button/toggle-init.js'></script>                                                        ");
            sb.Append("<script src='Scripts/UserPanel/js/advanced-form/advanced-form.js'></script>                                                      ");
            sb.Append("<script type='text/javascript' src='Scripts/UserPanel/assets/bootstrap-inputmask/bootstrap-inputmask.min.js'></script>           ");
            sb.Append("<script src='Scripts/UserPanel/assets/jquery-tags-input/jquery.tagsinput.js'></script>											");
            return sb.ToString();
        }

        public static String GetCustomFormScript()
        {
            return SetCustomFormScript();
        }

        private static String SetPieChartScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<!--Easy Pie Chart-->                                                                    ");
            sb.Append("<script src='Scripts/UserPanel/assets/easypiechart/jquery.easypiechart.js'></script>     ");
            return sb.ToString();
        }

        public static String GetPieChartScript()
        {
            return SetSparklineChartScript();
        }

        private static String SetSparklineChartScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<!--Sparkline Chart-->                                                                   ");
            sb.Append("<script src='Scripts/UserPanel/assets/sparkline/jquery.sparkline.js'></script>           ");
            return sb.ToString();
        }

        public static String GetSparklineChartScript()
        {
            return SetSparklineChartScript();
        }

        private static String SetFlotChartScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<!--jQuery Flot Chart-->                                                                 ");
            sb.Append("<script src='Scripts/UserPanel/assets/flot-chart/jquery.flot.js'></script>               ");
            sb.Append("<script src='Scripts/UserPanel/assets/flot-chart/jquery.flot.tooltip.min.js'></script>   ");
            sb.Append("<script src='Scripts/UserPanel/assets/flot-chart/jquery.flot.resize.js'></script>        ");
            sb.Append("<script src='Scripts/UserPanel/assets/flot-chart/jquery.flot.pie.resize.js'></script>	");
            return sb.ToString();
        }

        public static String GetFlotChartScript()
        {
            return SetFlotChartScript();
        }

        private static String SetGritterScript()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<script src='Scripts/UserPanel/js/gritter/gritter.js' type='text/javascript'></script>   ");
            return sb.ToString();
        }

        public static String GetGritterScript()
        {
            return SetGritterScript();
        }
    }
}