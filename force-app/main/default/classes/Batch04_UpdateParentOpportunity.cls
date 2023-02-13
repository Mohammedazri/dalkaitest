/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: batch used to Update the Fields CA_en_cours_en_K__c et CA_realis_en_K__c of the parent Projet Commercial with the sum of the
             Opportunity field CAEcartPrincipal__c by calling the function AP14_OppRollUpSummaryUtility.
             < THIS BATCH WAS USED TO UPDATE ALL THE RECORDS BEFORE ADDING THE FUNCTIONALITY OF THE CLASS AP14_OppRollUpSummaryUtility >
Test Class: Batch04_UpdateParentOpportunity_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch04_UpdateParentOpportunity implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'Select id, CAEcartPrincipal__c, IsClosed, ProjetCommercial__c, CloseDate from opportunity where ProjetCommercial__c!= null order by id';
        return Database.getQueryLocator(query);// query all the opportunities that have a projet commercial
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> OpportinityforUpdate){        
        if(OpportinityforUpdate.size()>0){
            list<AP14_OppRollUpSummaryUtility.fieldDefinition> fieldDefinitions = new list<AP14_OppRollUpSummaryUtility.fieldDefinition>();
            fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'CAEcartPrincipal__c', 'CA_en_cours_en_K__c'));
            fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'CAEcartPrincipal__c', 'CA_realis_en_K__c'));
            // update the fields of the projet commercial 
            AP14_OppRollUpSummaryUtility.rollUpTrigger(fieldDefinitions, OpportinityforUpdate,'Opportunity', 'ProjetCommercial__c', 'ProjetCommercial__c', '');         
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}