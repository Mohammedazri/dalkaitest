/**
* @author: Jacques Akiki -EI Technologies
* @date: 10/04/2019
* @description: Update The values on Opp after change in Budget
* @Test Class: Batch40_UpdateContratCadre_test
* @Coverage: 90%
*/
global class Batch40_UpdateContratCadre implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT id,name,EstContratCadre__c FROM Contrat__c '+
            'WHERE RecordType.DeveloperName =\'Contrat_Cadre\' AND EstContratCadre__c = false ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contrat__c> listCont){
        
        for (Contrat__c cont : listCont)
        {
            cont.EstContratCadre__c = true;   
        }
        try{
            update listCont;
        }
        catch(DmlException e)
        {
            system.debug('Exception...'+e.getMessage());
        }
        
    }
    global void finish(Database.BatchableContext BC){
    }
}