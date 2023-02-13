public class AP58_UOPilote {
    /**
*@author Alain Ghoussoub
*@date 17/05/2019
*@description updates the UOPiloteContrat__c field from the centre finance related record
*@param trigger.new contrat__c
*@return void
*/
    public static void updateUOPilote(List<Contrat__c> contrats){
        for(Contrat__c cont: contrats)
        {
            cont.UOPiloteContrat__c =cont.techCentreFinance__c;
        }
    }
    
    /**
*@author Alain Ghoussoub
*@date 17/05/2019
*@description updates the UOPiloteContrat__c field from the centre finance related record
*@param trigger.new contrat__c
*@return void
*/
    public static void insertUOPilote(List<Contrat__c> contrats){
        Set<Id> oppIds = new Set<Id>();
        for(Contrat__c cont: contrats)
        {
            oppIds.add(cont.OpportuniteCommerciale__c);
        }
        List<Opportunity> oppList = [SELECT id,name,Libelle_Agence__r.Region__r.CentreFinance__c,Affaire__c
                                     FROM Opportunity
                                     WHERE id in :oppIds];
        Map<Id,String> mapIDOpp = new Map<Id,String>();
        Map<Id,String> mapIDAff = new Map<Id,String>();
        for(Opportunity opp: oppList)
        {
            mapIDAff.put(opp.id,opp.Affaire__c);
            mapIDOpp.put(opp.id,opp.Libelle_Agence__r.Region__r.CentreFinance__c);
        }
        for(Contrat__c cont: contrats)
        {
            cont.AffaireContrat__c = mapIDAff.get(cont.OpportuniteCommerciale__c);
            cont.UOPiloteContrat__c = mapIDOpp.get(cont.OpportuniteCommerciale__c);
        }
    }
}