/**
* @author Rita Bejjani -EI Technologies
* @date 19/09/2019
* @description Batch qui renseigne la Nature du contrat cadre si elle est vide
* @Test Class: Batch58_UpdateContCadre_test
* @Coverage: 100%
*/

global class Batch58_UpdateContCadre implements Database.Batchable<SObject>,Database.stateful{
    
    global string limt;
    
    global Batch58_UpdateContCadre(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id , Name, NatureContratCadre__c '+
            'FROM Contrat__c '+ 
            'WHERE (EstContratcadre__c = true OR ContratCadre__c <> NULL) AND NatureContratCadre__c = null ';
        
        if(limt<>'' && limt<>null)
        {
            query = query + limt; 
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Contrat__c> listCont)
    {
        if (listCont <> NULL && listCont.size()>0)
        {
            for (Contrat__c cont : listCont)
            {
               cont.NatureContratCadre__c = 'Réseau';
            }
        }
        
        update listCont;
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}