/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: batch used to unlock all the FDS that were submitted for approval before the date  2018-05-29
Test Class: Batch08_UnlockFDS_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch08_UnlockFDS implements Database.Batchable<sObject>, Database.Stateful
{
    // create the query of the FDS
    public string query = 'SELECT id from Fiche_de_synthese__c ';
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        if(!Test.isRunningTest()) 
        {
            // add the condition 
            query +=' where id in (SELECT TargetObjectId FROM ProcessInstance where Status=\'Approved\' and CreatedDate < '+Label.batch08_Date+' ) and id not in (SELECT TargetObjectId FROM ProcessInstance where Status=\'Pending\')' ;
        }
        //execute the query and return the list
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c > fdsList)
    {
        //declare the map that will be used to store the errors
        Map<id,Approval.UnlockResult> results= new Map<id,Approval.UnlockResult>();
        // loop on the list of FDS 
        For(Fiche_de_synthese__c fds:fdsList)
        {
            // if the record is locked
            if(Approval.isLocked(fds.id) )
            {
                // unlock the record 
                Approval.UnlockResult unlockedRersult = Approval.unlock(fds.id);
                // if there's an error whil unlocking the record 
                if(!unlockedRersult.isSuccess())
                {
                    // add the error to the map
                    results.put(fds.id,unlockedRersult);
                }  
            }      
        }
        system.debug('results='+results);
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}