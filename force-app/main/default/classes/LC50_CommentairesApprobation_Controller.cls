/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: This class is used to querry comments of the Approver and the submitter
* @Test Class: 
* @Coverage: 100%
*/
public without sharing class LC50_CommentairesApprobation_Controller {
/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description:  ***  
* @inputs: id
* @returns: Approbation__c 
*/  
@AuraEnabled
    public static Approbation__c getComment(Id recordId)
    {
      Approbation__c app = [SELECT id,CommentaireA__c, CommentaireS__c 
                            FROM Approbation__c
                            WHERE id=:recordId LIMIT 1]; 
        return app;
    }
}