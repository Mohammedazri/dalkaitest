/*--------------------------------------------------------------------------------------------------------------------------
Author: Hatem Lahmadi 
Company: EI-Technologies / Cognizant
Description: batch used to delete consignes which status is diffrent than 'Archivé' and createddate< LAST_N_DAYS:91
Test Class: Batch123_DeleteConsigne_Test
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch123_DeleteConsigne implements Database.Batchable<sObject> {
    public Id RT_DemandeInformation = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_d_information').getRecordTypeId();
    public Id RT_DemandeC360 = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_C360').getRecordTypeId();  
    public Id RT_ConsigneAuto = Schema.SObjectType.Consigne__c.getRecordTypeInfosByDeveloperName().get('Consignes_Automatique').getRecordTypeId();
    
    public string query = 'SELECT Id, Name,createddate, Reponse__c FROM Consigne__c WHERE Reponse__c =\''+Label.PV_ConsigneStatues_NonContacte +'\' and createddate< LAST_N_DAYS:7'+
						' and (RecordTypeId=:RT_ConsigneAuto and (Demande__r.RecordTypeId !=: RT_DemandeInformation and Demande__r.RecordTypeId !=: RT_DemandeC360)) ';
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);//query the consignes to delete 
    }
                          
    global void execute(Database.BatchableContext BC, List<Consigne__c> ConsignesForDelete)
    {
        delete ConsignesForDelete; //delete the consignes
    }
    global void finish(Database.BatchableContext BC) {
        
    }
}