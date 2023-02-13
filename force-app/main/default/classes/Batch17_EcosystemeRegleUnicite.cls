/*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran 
Company: EI-Technologies
Description: batch used to responsible of applying the functionality of the workflow "Workflow Unicité Écosystèmes".
Test Class: Batch17_EcosystemeRegleUnicite_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
4/10/2018   Hussein Farran      Creation
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch17_EcosystemeRegleUnicite implements Database.Batchable<sObject>{
    Set<Id> setIds = new Set<Id>();
    global Batch17_EcosystemeRegleUnicite (Set<Id> setIds){
        this.setIds = setIds;
    }
    global Batch17_EcosystemeRegleUnicite (){
        
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
       String query ='SELECT ZZZTechEcosystemeRegleUnicite__c ,ChampsConcateneRegleUnicite__c FROM EcosystemePartenaire__c where ChampsConcateneRegleUnicite__c !=null'
            +' and ChampsConcateneRegleUnicite__c !=\'\' ';
        if(setIds!=null && setIds.size()>0){
            query = query + ' and id in :setIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<EcosystemePartenaire__c> ecoList)
    {
        System.debug('##ecoList '+ ecoList);
        for(EcosystemePartenaire__c esp : ecoList){
            esp.ZZZTechEcosystemeRegleUnicite__c = esp.ChampsConcateneRegleUnicite__c;
        }
        update ecoList;
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}