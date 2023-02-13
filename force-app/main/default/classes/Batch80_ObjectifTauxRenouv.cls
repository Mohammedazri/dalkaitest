/**
* @author Alain Ghoussoub
* @date 22/06/2020
* @description Batch qui met le champ Objectif du taux de renouvellement egal a 70% sur les objectifs de l'anne courante des commercial ayant le profil commercial first
* @Test Class: 
*/
global class Batch80_ObjectifTauxRenouv implements Database.Batchable<SObject> {
        /** 
* @author Alain Ghoussoub
* @date 22/6/2020 
* @ Select all accounts
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string profiledToInclude = label.Profile_DACFirst;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        string currentYear = string.valueOf(System.Today().year());
        
        String query='Select id,ObjectifDuTauxDeRenouvellement__c FROM Objectif__c WHERE Profil_du_responsable__c  in:setProfileNames AND Annee__c= :currentYear';
        return Database.getQueryLocator(query); 
    }
    /** 
* @author Alain Ghoussoub 
* @date 22/6/2020 
* @Met le champ Objectif du taux de renouvellement egal a 70% sur les objectifs de l'anne courante des commercial ayant le profil commercial first
* @param Database.BatchableContext and list of account
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Objectif__c> listObj)
    {
        for(Objectif__c obj: listObj){
            obj.ObjectifDuTauxDeRenouvellement__c = 70;
        }
        if(listObj != null && listObj.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            update listObj;
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }

}