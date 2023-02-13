/*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Mattar
Company: EI-Technologies
Description: batch used to fill the field TechPriorValueStageName__c of the already existing opportunities
Test Class: Batch09_MAJ_TechPriorStageName_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
08/01/2018   Rita Mattar      Creation        
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch09_MAJ_TechPriorStageName implements Database.Batchable<sObject>, Database.Stateful
{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        // create the query of the Opportunities
        string query = 'SELECT id, TechPriorValueStageName__c, StageName from Opportunity';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> OppList)
    {
        //Querying over the opportunities to update the field
        For(Opportunity opp :OppList)
        {
            opp.TechPriorValueStageName__c = opp.StageName;
        }
        update OppList;
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}