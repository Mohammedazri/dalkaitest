/*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran 
Company: EI-Technologies
Description: batch used to responsible of changing the value of the field Tech_CdtRefSelectionnee__c on the object opportunity - For records who have the value of this field = Saisie manuelle (à justifier)
--> change it to Budget Corrigé)
Test Class: Batch19_UpdateConditionRefOpp_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
11/10/2018   Hussein Farran      Creation
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch19_UpdateConditionRefOpp implements Database.Batchable<sObject>{
    Set<Id> setIds = new Set<Id>();
    global Batch19_UpdateConditionRefOpp (Set<Id> setIds){
        this.setIds = setIds;
    }
    global Batch19_UpdateConditionRefOpp (){
        
    }
    global Database.QueryLocator start(Database.BatchableContext bc){

        String query ='Select id,name,Tech_CdtRefSelectionnee__c from Opportunity where Tech_CdtRefSelectionnee__c=\'Saisie manuelle (à justifier)\'';
        if(setIds!=null && setIds.size()>0){
            query = query + ' and id in :setIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> OpportunityList)
    {
        System.debug('##OpportunityList '+ OpportunityList);
        
        for(Opportunity opp : OpportunityList){
          	opp.Tech_CdtRefSelectionnee__c = 'Budget Corrigé';
        }
        
        update OpportunityList;
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}