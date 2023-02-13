/** 
* @author Jacques Akiki - Ei technologies
* @date 06/03/2020 
* @description Batch that changes Record Type of contrat that has staut ferme
* @Test Class Batch68_StatutFerme_test
*/
global class Batch68_StatutFerme implements Database.Batchable<SObject>
{
    
/** 
* @author Jacques AKiki 
* @date 06/03/2020 
* @ Query the Contrats
*/
        global String RT = Schema.SObjectType.Contrat__c.getRecordTypeInfosByName().get(Label.RTContrat_Ferme).getRecordTypeId();

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id,Statut__c from Contrat__c where statut__c =\''+Label.ContratFerme+'\' AND RecordTypeId <>\''+RT+'\'';
        return Database.getQueryLocator(query); 
    }
    /** 
* @author Jacques AKiki 
* @date 06/03/2020 
* @Change the recordType of the contrats
* @List of queried Contrats
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Contrat__c> listCont)
    {
        for(Contrat__c contrat :listCont)
        {
            contrat.recordTypeId = RT;
        }
        update listCont;
        
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}