/**
* @author: Dona Kfoury -EI Technologies
* @date: 10/7/2020 
* @description: Controller of LC68_NewTauxRenouvellement qui montre le taux Taux d'adoption à l'Espace Client
* @Test Class:   LC70_TauxEspaceClient_Controller_Test
* @Coverage: 
*/
public without sharing class LC70_TauxEspaceClient_Controller {
    
    /**
* @author: Dona kfoury
* @date: 10/7/2020 
* @description:  la méthode retourne le taux d'adoption à l'Espace Client de l'utilisateur actuel depuis son objectif
* @inputs: -
* @returns: Decimal
*/   @AuraEnabled
    public static Decimal getTauxEC()
    {
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        Decimal taux = -1;
        Id userId = UserInfo.getUserId();
        Datetime dateToday = System.today();
        String year = String.ValueOf(dateToday.year());
        List<Objectif__c> objList = new List<Objectif__c>();
        objList = [SELECT Id,TauxDAdoptionLEspaceClient__c 
                  FROM Objectif__c
                  WHERE Commercial__c =:userId
                  AND Annee__c = :year AND Profil_du_responsable__c in:setProfileNames];
        if(objList != null && objList.size()>0 && objList[0].TauxDAdoptionLEspaceClient__c != null){
            taux = objList[0].TauxDAdoptionLEspaceClient__c;
        }
        return taux;
    }

}