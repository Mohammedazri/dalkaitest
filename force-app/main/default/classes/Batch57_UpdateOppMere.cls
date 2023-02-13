/**
* @author Rita Bejjani -EI Technologies
* @date 19/09/2019
* @description Batch qui renseigne la Nature de l'opportunité mère si elle est vide
* @Test Class: Batch57_UpdateOppMere_test
* @Coverage: 100%
*/

global class Batch57_UpdateOppMere implements Database.Batchable<SObject>,Database.stateful{
    
    global string limt;
    
    global Batch57_UpdateOppMere(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id , Name, NatureOpportunitMere__c '+
            'FROM Opportunity '+ 
            'WHERE (EstOpportuniteMere__c = true OR OpportuniteMere__c <> NULL ) AND NatureOpportunitMere__c = null ';
        
        if(limt<>'' && limt<>null)
        {
            query = query + limt; 
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        if (listOpp <> NULL && listOpp.size()>0)
        {
            for (Opportunity opp : listOpp)
            {
               opp.NatureOpportunitMere__c = 'Réseau';
            }
        }
        
        update listOpp;
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}