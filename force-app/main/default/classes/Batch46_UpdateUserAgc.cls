/**
* @author: Rita Bejjani -EI Technologies
* @date: 07/05/2019
* @description: Update users agence__c
* @Test Class: Batch46_UpdateUserAgc_Test
* @Coverage: 96%
*/
global class Batch46_UpdateUserAgc implements Database.Batchable<SObject> {
    private String queryS;
    
    public Batch46_UpdateUserAgc(String qString) {
        queryS = qString; // the string to concetanate with the query (only for test class)
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id, Name, Nom_agence__c, Nom_region__c, Nom_siege__c, Organisation__c '+
            			'FROM User '+ 
            			'WHERE Organisation__c <> null '+queryS; // select users that have a code for agency
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<User> listUsers)
    {
        set<string> setCodeAppartenance = new set<string>(); // set to add all agence code on users
        
        For(User usr : listUsers)
        {
            setCodeAppartenance.add(usr.Organisation__c);
        }
        
        List<Agence__c> listAgence = [SELECT id, name, Code_Agence__c,Region__r.Name, Region__r.Code_Region__c, Region__r.siege__r.Name, Region__r.siege__r.Code_Siege__c ,DkCode__c
                                      FROM Agence__c
                                      WHERE DkCode__c in :setCodeAppartenance];
        
        //update list of users with related fields based on Code_Agence__c
        for(Agence__c agc:listAgence)
        {
            for(User usr: listUsers)
            {       
                if(usr.Organisation__c == agc.DkCode__c)
                {
                    usr.Code_d_Appartenance__c = agc.Code_Agence__c;
                    //usr.Tech_Code_Agence__c = agc.Code_Agence__c;
                    usr.Nom_agence__c = agc.Name;
                    usr.Nom_region__c = agc.Region__r.Name;
                    //usr.Tech_Code_Region__c = agc.Region__r.Code_Region__c;
                    usr.Nom_siege__c = agc.Region__r.siege__r.Name;
                    //usr.Tech_Code_Siege__c = agc.Region__r.siege__r.Code_Siege__c;
                }
            }
        }
        
        try{
            update listUsers;
        }
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }  
    }
    
    global void finish(Database.BatchableContext bc)
    {}
    
}