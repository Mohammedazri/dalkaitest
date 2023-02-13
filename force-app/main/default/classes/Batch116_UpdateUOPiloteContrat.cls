/**
* @author Charbel Khoury Hanna
* @date  06/24/2021
* @description MAJ du UOPiloteContrat__c avec la valeur du centre finance relié à la région du contrat
*/

global class Batch116_UpdateUOPiloteContrat implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    String query;
    Set<Id> contratIds = new Set<Id>();
    
    public Batch116_UpdateUOPiloteContrat(List<Contrat__c> listContrats){
        
        for(Contrat__c cont : listContrats)
        {
            contratIds.add(cont.Id);
        }
        
        system.debug('contratIds = '+contratIds);
        
        query = 'SELECT Id, UOPiloteContrat__c, techCentreFinance__c '
               +' FROM Contrat__c '
               +' WHERE id IN :contratIds ';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        System.debug('Batch116_UpdateUOPiloteContrat Starting...');
        System.debug('query == '+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Contrat__c> scope) 
    {
        System.debug('Batch116_UpdateUOPiloteContrat started executing');
        
        if (scope.size()>0)
        {
            AP99_ContratUOPilote.updateUOPilote(scope);
        }
        update scope;
        
        System.debug('Batch116_UpdateUOPiloteContrat Ended Executing');
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch116_UpdateUOPiloteContrat Finishing...');
    }
}