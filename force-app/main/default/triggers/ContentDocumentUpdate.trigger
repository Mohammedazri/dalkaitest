/*--------------------------------------------------------------------------------------------------------------------------
Author:  Christine Bayssary
Company: EI-Technologies
Description: Apex trigger ContentDocumentUpdate
Test Class:  AP01_ContentDocumentLink_test
History
<Date> 		<Authors Name> 		<Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger ContentDocumentUpdate on ContentDocument (after update) 
{
    //modify the value of revueOffre__c on opprtunity
    if(PAD.CanTrigger('AP01_ContentDocumentLink') )
    {
        AP01_ContentDocumentLink.verificationRevueOffreUpdate(trigger.new,trigger.OldMap);
    }
   
}