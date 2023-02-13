/**
* @author: Jacques Akiki -EI Technologies
* @date: 24/04/2019 
* @description: This Batch is used to make sure that the 2 fields : OwnerId, PiloteDuContrat__c have the same values. 
* @Test Class: Batch44_UpdateOwner_test  
* @Coverage: 100%
*/
global class Batch44_UpdateOwner implements Database.Batchable<SObject>
{
    public String condition='';
    public Batch44_UpdateOwner (string cond) // if we want to pass condition to narrow down the where criteria 
    {
        if (cond<> null && cond<>'' && (cond.contains('where') ||cond.contains('Where')||cond.contains('WHERE')) )
        {
            condition = cond; // set the varaible condition to the where condition passed in parameter
        }
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id,OwnerId,PiloteDuContrat__c FROM Contrat__c '; // select contracts
        if (condition<>'')
        {
            query = query+condition; // concatenate the new condition with the query.
        }
        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext bc , List<contrat__c> listCont)
    {
        List<Contrat__c> listContrat = new List<Contrat__c>(); // contracts to update
        
        for(Contrat__c cont : listCont)
        {
            if(cont.OwnerId<>cont.PiloteDuContrat__c) 
            {
               cont.PiloteDuContrat__c = cont.OwnerId; // set the value of PiloteDuContrat__c with the same value of OwnerId 
                listContrat.add(cont); // add contrat to list of contrat__c to be updated
            }
            
        }


        if(listContrat<>null && listContrat.size()>0)
        {
            update listContrat;
        }
        
    }
    global void finish(Database.BatchableContext bc)
    {}
}