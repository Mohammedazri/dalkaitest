/*--------------------------------------------------------------------------------------------------------------------------
Author:  Dona Kfoury
Company: EI-Technologies
Description: Apex trigger ContactAfterDelete
Test Class:  AP12_Contact_Test
History
<Date>      <Authors Name>      <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger ContactAfterDelete on Contact (after delete) {
    // use the field Indicateur_satisfaction__c to update the value of the field Satisfaction_client__c on the account
    //if(PAD.CanTrigger('AP12_Contact'))
        //AP12_Contact.UpdateSatisfactionDuClient(trigger.Old);
}