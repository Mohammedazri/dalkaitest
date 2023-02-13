/**
* @author: Dona Kfoury -EI Technologies
* @date: 15/09/2020 
* @description: Controller of LC77_AgenceTauxEspaceClient qui montre le taux de l'agence d'adoption à l'Espace Client
* @Test Class:   LC77_AgenceTauxEspaceClient_Controller_Test
* @Coverage: 
*/
public without sharing class LC77_AgenceTauxEspaceClient_Controller {
/**
* @author: Dona kfoury
* @date: 15/09/2020  
* @description:  la méthode retourne le taux d'adoption à l'Espace Client de l'agence de  l'utilisateur actuel depuis son objectif
* @inputs: -
* @returns: Decimal
*/   @AuraEnabled
    public static Decimal getAgenceTauxEC()
    {
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        Decimal taux = -1;
        Id userId = UserInfo.getUserId();
        Datetime dateToday = System.today();
        String year = String.ValueOf(dateToday.year());
        List<Objectif__c> objList = new List<Objectif__c>();
        objList = [SELECT Id,TauxDAdoptionALECDeLAgence__c 
                  FROM Objectif__c
                  WHERE Commercial__c =:userId
                  AND Annee__c = :year AND Profil_du_responsable__c in:setProfileNames];
        if(objList != null && objList.size()>0 && objList[0].TauxDAdoptionALECDeLAgence__c != null){
            taux = objList[0].TauxDAdoptionALECDeLAgence__c;
        }
        return taux;
    }

}