/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: batch used to delete leads which status is diffrent than 'Archivé' and createddate< LAST_N_DAYS:91
Test Class: Batch01_DeleteLead_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
04/08/2020   Jacques Akiki	 Ajouter condition pour prendre seulement les potentiels explore.
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch01_DeleteLead implements Database.Batchable<sObject> {
    public Id RTMouv = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(Label.RT_LeadMouvement).getRecordTypeId();
    public Id RTPPMP = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(Label.RT_LeadPPMP).getRecordTypeId();
    
    public string query = 'SELECT Id, Name,createddate, status FROM Lead WHERE status!=\''+Label.PV_LeadStatues_Archiv +'\' and createddate< LAST_N_DAYS:91'+
                          '  and (RecordTypeId=:RTMouv OR RecordTypeId=:RTPPMP) and Lien_Explore__c!=NULL';
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);//query the leads to delete 
    }
                          
    global void execute(Database.BatchableContext BC, List<lead> LeadsForDelete)
    {
        delete LeadsForDelete; //delete the leads
    }
    global void finish(Database.BatchableContext BC) {
        
    }
}