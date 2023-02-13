/**
* @author: Dona Kfoury -EI Technologies
* @date: 16/7/2020 
* @description: Controller of LC72_VentesAdditionnelles qui montre le taux de ventes additionnelles
* @Test Class:   LC72_VentesAdditionnelles_Controller_Test
* @Coverage: 
*/
public without sharing class LC72_VentesAdditionnelles_Controller {
    
    /**
* @author: Dona kfoury
* @date: 10/7/2020 
* @description:  la méthode retourne le taux de ventes additionelles de l'utilisateur actuel depuis son objectif
* @inputs: -
* @returns: Decimal
*/   @AuraEnabled
    public static Decimal getTauxVA()
    {
        string profiledToInclude = label.Profils_TauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        Decimal taux = -1;
        Id userId = UserInfo.getUserId();
        Datetime dateToday = System.today();
        String year = String.ValueOf(dateToday.year());
        List<Objectif__c> objList = new List<Objectif__c>();
        objList = [SELECT Id,Ventes_Additionnelles__c 
                  FROM Objectif__c
                  WHERE Commercial__c =:userId
                  AND Annee__c = :year AND Profil_du_responsable__c in:setProfileNames];
        if(objList != null && objList.size()>0 && objList[0].Ventes_Additionnelles__c != null){
            taux = objList[0].Ventes_Additionnelles__c;
        }
        return taux;
    }
}