/*--------------------------------------------------------------------------------------------------------------------------
Author:  Dona Kfoury
Company: EI-Technologies
Description: Apex trigger ContactAfterInsert
Test Class:  
History
<Date>      <Authors Name>      <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger ContactAfterInsert on Contact (after insert) {
    

    // creates Contact_User__c records 
    if(PAD.CanTrigger('AP13_Contact')) 
        AP13_Contact.CreationRelationContactUser(trigger.new);
}