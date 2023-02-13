/*------------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: batch used to set the value of the checkbox Rdvralise__c on Event to true when the field Compterendu__c is not empty    
Test Class: Batch22_UpdateRDVRealise_test
History
<Date>      <Authors Name>   <Brief Description of Change>
24/10/2018   Jacques Akiki      Creation
------------------------------------------------------------------------------------------------------------------------------*/
global class Batch22_UpdateRDVRealise implements Database.Batchable<sObject>
{

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query ='Select id, Rdvralise__c, Compterendu__c From Event where Compterendu__c !=\'\' AND Rdvralise__c=false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Event> listEvents)
    {
        System.debug('##listEvents '+ listEvents.size());
        for(Event evnt : listEvents)
        {
          	evnt.Rdvralise__c = true;
        }
        update listEvents;
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}