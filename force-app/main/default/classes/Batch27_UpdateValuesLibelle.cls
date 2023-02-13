/*------------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: 
Test Class: Batch27_UpdateValuesLibelle_test
History
<Date>      <Authors Name>   <Brief Description of Change>
24/10/2018   Jacques Akiki      Creation
------------------------------------------------------------------------------------------------------------------------------*/
global class Batch27_UpdateValuesLibelle implements Database.Batchable<sObject>
{

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query ='Select id, name, Libelle_Agence__c ,Libelle_Region__c, Tech_Libelle_agence__c, Tech_Libelle_region__c From Opportunity';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> listOpp)
    {
        for(Opportunity opp : listOpp)
        {
          	opp.Libelle_Agence__c = opp.Tech_Libelle_agence__c;
            //opp.Libelle_Region__c = opp.Tech_Libelle_region__c;
        }
        update listOpp;
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}