/** 
* @author Jacques AKiki
* @date 11/06/2020 
* @description trigger before delete ContratContact
* @Test class: AP84_HandleDuplicates_test
*/
trigger OpportuniteContactBeforeInsert on OpportuniteContact__c (before insert)
{
    // 12/05/2022 Added by Jimmy Khalil 
    // US C360-724: Check if the User can Insert a Opportunite Contact
    if(PAD.CanTrigger('AP94_Opportunity'))
    {
        AP110_OpportuniteContact.checkIfCanInsertOrDelete(trigger.new); 
    }
    
    // we do not want to bypass this class to handle duplicates
    AP84_HandleDuplicates.fillTechUniqueOpp(trigger.new);
}