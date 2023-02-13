/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 08/09/2020 
* @description: Controller of cLC76_AgenceTauxRenouvellement qui montre le taux de renouvelleemnt de l'agence
* @Test Class: 
* @Coverage: 
*/
public without sharing class LC76_AgenceTR_Controller {
    /**
* @author: Alain Ghoussoub
* @date: 08/09/2020 
* @description:  la méthode retourne le taux de renouvellement de l'agence du RAC one actuel depuis son objectif
* @inputs: -
* @returns: Decimal
*/   @AuraEnabled
    public static Decimal getTauxRenouvellementAgence()
    {
        string profiledToInclude = label.Profils_AgenceTauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        Decimal taux = -1;
        Id userId = UserInfo.getUserId();
        Datetime dateToday = System.today();
        String year = String.ValueOf(dateToday.year());
        List<Objectif__c> objList = new List<Objectif__c>();
        objList = [SELECT Id,TauxDeRenouvellementDeLAgence__c 
                   FROM Objectif__c
                   WHERE Commercial__c =:userId
                   AND Annee__c = :year AND Profil_du_responsable__c in:setProfileNames];
        if(objList != null && objList.size()>0 && objList[0].TauxDeRenouvellementDeLAgence__c != null){
            taux = objList[0].TauxDeRenouvellementDeLAgence__c;
        }
        return taux;
    }
            /**
* @author: Alain Ghoussoub -EI Technologies
* @date: 08/09/2020
* @description:  The method returns the id of the report 'Tx renouvellement - Contrats de l'agence'
* @inputs: -
* @returns: String
*/   @AuraEnabled
    public static String getRapport()
    {
        String rapport = '';
        List<report > repList = new List<report >();
        repList = [SELECT Id,Name
                  FROM Report
                  WHERE DeveloperName = :Label.LC76_NomRapport];
        if(repList != null && repList.size()>0){
            rapport = repList[0].id;
        }
        return rapport;
    }
}