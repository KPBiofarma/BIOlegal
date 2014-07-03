using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BioPM.ClassEngines
{
    //Last April 2014,
    //Menu Control to limit user otority
    //Not Implement Yet

    public class MenuControl
    {
        private bool insert;
        public bool InsertMenu 
        { 
            set{ insert = value; }
            get{ return insert; } 
        }
        private bool update;
        public bool UpdateMenu
        {
            set { update = value; }
            get { return update; } 
        }
        private bool delete;
        public bool DeleteMenu
        {
            set { delete = value; }
            get { return delete; }
        }
        private bool view;
        public bool ViewMenu
        {
            set { view = value; }
            get { return view; }
        }
        private bool print;
        public bool PrintMenu
        {
            set { print = value; }
            get { return print; }
        }
        private bool export;
        public bool ExportMenu
        {
            set { export = value; }
            get { return export; }
        }

        public string binary;
        
        public MenuControl() 
        { 
            setMenuConfig(RoleMenu());
            binary = getBinaryRole();
        }

        public void setMenuConfig(List<Boolean> menu)
        {
            insert = menu[0];
            update = menu[1];
            delete = menu[2];
            view = menu[3];
            print = menu[4];
            export = menu[5];
        }

        protected List<Boolean> RoleMenu()
        {
            List<Boolean> lstConfig = new List<Boolean>();
            for (int i = 0; i < getBinaryRole().Length; i++)
            {
                lstConfig.Add(menuConfiguration(i));
            }
            return lstConfig;
        }

        protected Boolean menuConfiguration(int index)
        {
            switch (index)
            {
                case 0 :
                    {
                        if (getBitValidation(0))
                        {
                            //insert enable
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                        
                    }
                case 1:
                    {
                        if (getBitValidation(1))
                        {
                            //update enable
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                case 2:
                    {
                        if (getBitValidation(2))
                        {
                            //delete enable
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                case 3:
                    {
                        if (getBitValidation(3))
                        {
                            //view enable
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                case 4:
                    {
                        if (getBitValidation(4))
                        {
                            //cetak enable
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                case 5:
                    {
                        if (getBitValidation(5))
                        {
                            //export enable
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                default: { return false; }
            }
        }

        protected bool getBitValidation(int index)
        {
            if (getBinaryRole()[index] == '1') return true;
            else return false;
        }
        
        protected String getBinaryRole()
        {
            return BioPM.ClassEngines.BinaryConverter.Converter.DecimalToBinary(System.Web.Configuration.WebConfigurationManager.AppSettings["UserRole"].ToString());
        }

    }
}