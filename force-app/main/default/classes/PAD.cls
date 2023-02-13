/**
*Cette classe est utilisée pour:
*  - bypass les triggers lancés durant les operations create/modify
*@date: 05/20/2016
*@ticket:
**/
public class PAD{

    private static final Set<String> requiredOnce=new Set<String>{};//List of Apex codes that should run only once. Add any code to the list
    private static Set<String>hasRun=new Set<String>();//List of Apex code that has already been run. Keep this list empty.
    public static String PAD_BypassTrigger;//List of triggers that can be bypassed
    public static final Boolean PAD_DebugMode {get;set;}
    public static final String userRoleName;  //User Role Name
    public static final String userProfileName;//User Profile Name
    public static final String userLocalKey;
    public static final String userName;
    public static boolean isFirstCall = true;
    public static boolean isIntegrationUser = false;
    
    static{
        System.Debug('## >>> PAD constructor :BEGIN <<< run by ' + UserInfo.getName());
        User user=[SELECT Name, UserRole.Name,Profile.Name, UserPreferencesApexPagesDeveloperMode, Bypass_Triggers__c,LanguageLocaleKey FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
        PAD_BypassTrigger=';'+user.Bypass_Triggers__c+';'; 
        System.debug('########-------->>>>>>>>'+user);
        PAD_DebugMode=user.UserPreferencesApexPagesDeveloperMode;
        userRoleName= user.UserRole.Name;
        userProfileName = user.Profile.Name;
        userLocalKey = user.LanguageLocaleKey; 
        userName = user.Name;
        //isIntegrationUser = user.IsIntegrator__c;
        System.Debug('## >>> PAD constructor : END <<<');
    }
    
    public static boolean canTrigger(String ApexName){//If no bypass
        if(requiredOnce.contains(ApexName)){//If it should run Once
            if(hasRun.contains(ApexName))return false;//Already run, should not run
            hasRun.add(ApexName);//Never run, can run only if not bypassed
        }
        //system.debug(PAD_BypassTrigger);
        return(PAD_BypassTrigger.indexOf(';'+ApexName+';')==-1);
    }
        
}