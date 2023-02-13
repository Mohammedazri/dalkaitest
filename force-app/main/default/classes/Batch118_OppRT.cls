/** 
* @author Jacques Akiki - Ei technologies
* @date 05/08/2021 
* @description Batch qui met a jour les RT des Opportunités
* @Test Class Batch118_OppRT_test 100%
*/

global class Batch118_OppRT implements Database.Batchable<sObject> {
    
    /** 
* @author Jacques Akiki
* @date 05/08/2021 
* @chercher les Opportunités
*/    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'SELECT id, Type_pers__c,RecordTypeId,EstOpportuniteMere__c FROM Opportunity';
        
        return Database.getQueryLocator(query);
    }
    
    /** 
* @author Jacques Akiki
* @date 05/08/2021
* @attribuer le bon RT aux opportunités
*/
    global void execute(Database.BatchableContext BC, List<Opportunity> listOpp)
    {
        Id rTCreation_Id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        Id rTEvolution_Id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        Id rTMere_Id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        for(Opportunity opp : listOpp)
        {
            if(opp.Type_pers__c==Label.PV_Evolution)
            {
                opp.RecordTypeId = rTEvolution_Id; 
            }
            else if(opp.EstOpportuniteMere__c)
            {
                opp.RecordTypeId = rTMere_Id; 
            }
            else 
            {
                opp.RecordTypeId = rTCreation_Id; 
            }
        }
        update listOpp;
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}