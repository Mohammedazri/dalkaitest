/**
* @author: Jacques Akiki -EI Technologies
* @date: 23/05/2019
* @description: Controller of LC54_ApprovalFDS.cmp that displays pending approvals for a user 
* @Test Class:LC54_ApprouverFDSCont_test  
* @Coverage: 100% 
*/
public without sharing class LC54_ApprouverFDSCont {
    @AuraEnabled
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 23/05/2019
* @description:  The method returns approbation assigned to the logged in user that have not been approved. 
* @inputs: -
* @returns: List<Approbation__c>
*/   
    public static List <Approbation__c> getAppData() {
        List<Approbation__c> listApp = [SELECT Id, tech_FicheDeSynthese__c, tech_FicheDeSynthese__r.name , Approbateur_actuel__c , Approbateur_actuel__r.name , Date_de_soumission__c,
                                        tech_FicheDeSynthese__r.Opportunit_commerciale__r.Owner.Name 
                                        FROM Approbation__c 
                                        WHERE tech_Attribue__c = :UserInfo.getUserId() AND statut__c =:Label.LC54_sansRep order by Date_de_soumission__c desc];
        
        return listApp;
    }
}