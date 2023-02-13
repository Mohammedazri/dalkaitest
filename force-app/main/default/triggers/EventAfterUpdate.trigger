/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: Apex trigger EventAfterUpdate
Test Class: AP01_Event_test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger EventAfterUpdate on Event (after update) {
    
     //send a chatter notification to the partner's followers when adding the compte Rendu
    if(PAD.CanTrigger('AP01_Event') ){
        AP01_Event.partnerFollowersMembersNotification(trigger.new, trigger.OldMap);}
}