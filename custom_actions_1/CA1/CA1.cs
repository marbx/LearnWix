using Microsoft.Deployment.WindowsInstaller;
using Microsoft.Tools.WindowsInstallerXml;
using Microsoft.Win32;
using System;
using System.IO;
using System.Text.RegularExpressions;

namespace CA1 {
    public class CA1 : WixExtension {

        public static string get_property_DECAC(Session session, string key) {
            session.Log("...get_property_DECAC key {0}", key);
            string val = session.CustomActionData[key];
            session.Log("...get_property_DECAC val {0}", val);
            session.Log("...get_property_DECAC len {0}", val.Length);
            return val;
        }


        public static string get_property_IMCAC(Session session, string key ) {
            // IMCAC means ou can directly access msi properties at session[*]
            // session["INSTALLFOLDER"] ends with a backslash, e.g. C:\salt\ 
            session.Log("...get_property_IMCAC key {0}", key);
            string val = session[key];
            session.Log("...get_property_IMCAC val {0}", val);
            session.Log("...get_property_IMCAC len {0}", val.Length);
            return val;
        }


        [CustomAction]
        public static ActionResult ReadConfig_IMCAC(Session session) {
            /*
              */
            session.Log("...Begin ReadConfig_IMCAC");
            session.Log("...End ReadConfig_IMCAC");
            return ActionResult.Success;
        }

    }
}
