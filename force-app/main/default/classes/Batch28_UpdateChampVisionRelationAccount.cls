/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki  
Company: EI-Technologies
Description: This Batch updates old records of account where the field QualitePartenaire__c is different than null and VisionRelationCommercialeTerrain__c is null 
Test Class: Batch28_UpdateChampVisionRelation_test 
History
<Date>      <Authors Name>   <Brief Description of Change>
14/12/2018   Jacques AKiki      Creation
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch28_UpdateChampVisionRelationAccount implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query ='SELECT id , name , VisionRelationCommercialeTerrain__c , Qualification__c  FROM Account WHERE VisionRelationCommercialeTerrain__c= NULL AND  Qualification__c <> NULL';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> ListAcc)
    {
        List <Account> listAccUpdate = new List<Account>();
        for (Account Acc:ListAcc)
        {
            //Acc.VisionRelationCommercialeTerrain__c = Acc.QualitePartenaire__c;
            Acc.VisionRelationCommercialeTerrain__c = Acc.Qualification__c;
            listAccUpdate.add(Acc);
        }
        
        Update listAccUpdate;
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
}