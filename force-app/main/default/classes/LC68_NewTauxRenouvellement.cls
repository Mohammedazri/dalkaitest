/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 16/6/2020
* @description: Controller of LC68_NewTauxRenouvellement that displays the taux de renouvellement 
* @Test Class:   
* @Coverage: 
*/
public without sharing class LC68_NewTauxRenouvellement {
    /**
* @author: Alain Ghoussoub -EI Technologies
* @date: 16/6/2020
* @description:  The method returns the taux de renouvellement of the current year where commercial is the current user
* @inputs: -
* @returns: Decimal
*/   @AuraEnabled
    public static Decimal getTauxRenouv()
    {
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        Decimal taux = -1;
        Id userId = UserInfo.getUserId();
        Datetime dateToday = System.today();
        String year = String.ValueOf(dateToday.year());
        List<Objectif__c> objList = new List<Objectif__c>();
        objList = [SELECT Id,TauxDeRenouvellement__c 
                  FROM Objectif__c
                  WHERE Commercial__c =:userId
                  AND Annee__c = :year AND Profil_du_responsable__c in:setProfileNames];
        if(objList != null && objList.size()>0 && objList[0].TauxDeRenouvellement__c != null){
            taux = objList[0].TauxDeRenouvellement__c;
        }
        return taux;
    }
        /**
* @author: Alain Ghoussoub -EI Technologies
* @date: 16/6/2020
* @description:  The method returns the id of the report 'mes contrats actifs'
* @inputs: -
* @returns: String
*/   @AuraEnabled
    public static String getRapport()
    {
        String rapport = '';
        List<report > repList = new List<report >();
        repList = [SELECT Id,Name
                  FROM Report
                  WHERE DeveloperName = :Label.LC68_NomRapport];
        if(repList != null && repList.size()>0){
            rapport = repList[0].id;
        }
        return rapport;
    }
}