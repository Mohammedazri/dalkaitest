/**
* @author: Jacques Akiki -EI Technologies
* @date: 06/03/2019
* @description: Correction of the contract status from ouverture to Préparation 
* @Test Class: Batch37_UpdateStatutContrat_test 
* @Coverage: 100%
*/
global class Batch37_UpdateStatutContrat implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id, name, statut__c FROM Contrat__c WHERE statut__c =\'Ouverture\'  ';
        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext bc , List<contrat__c> listCont)
    {
        for(Contrat__c cont : listCont)
        {
            cont.statut__c  = Label.AP16_ContratStatus;
        }
        update listCont;
    }
    global void finish(Database.BatchableContext bc)
    {}
}