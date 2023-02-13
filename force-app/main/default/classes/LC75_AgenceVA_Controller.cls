/**
* @author: Dona Kfoury -EI Technologies
* @date: 03/09/2020 
* @description: Controller of LC75_AgenceVentesAdditionnelles qui montre le taux de ventes additionnelles de l'agence
* @Test Class: LC75_AgenceVA_Controller_Test
* @Coverage: 
*/
public without sharing class LC75_AgenceVA_Controller {
    /**
* @author: Dona kfoury
* @date: 03/09/2020 
* @description:  la méthode retourne le taux de ventes additionelles de l'agence du RAC one actuel depuis son objectif
* @inputs: -
* @returns: Decimal
*/   @AuraEnabled
    public static Decimal getTauxVAAgence()
    {
        string profiledToInclude = label.Profils_AgenceTauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        Decimal taux = -1;
        Id userId = UserInfo.getUserId();
        Datetime dateToday = System.today();
        String year = String.ValueOf(dateToday.year());
        List<Objectif__c> objList = new List<Objectif__c>();
        objList = [SELECT Id,VentesAdditionnellesDeLAgence__c 
                  FROM Objectif__c
                  WHERE Commercial__c =:userId
                  AND Annee__c = :year AND Profil_du_responsable__c in:setProfileNames];
        if(objList != null && objList.size()>0 && objList[0].VentesAdditionnellesDeLAgence__c != null){
            taux = objList[0].VentesAdditionnellesDeLAgence__c;
        }
        return taux;
    }
}