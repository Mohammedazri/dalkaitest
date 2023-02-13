/**
 * @author Jacques AKiki
 * @date 19/04/2022
 * @description trigger before delete OpportunityContact
 * @Test class: AP108AP109_test
 */
trigger OpportuniteContactBeforeDelete on OpportuniteContact__c  (before delete) {

    if(PAD.canTrigger('AP109_OpportunityContact')) {
        AP109_OpportunityContact.contactObligatoire(trigger.old);
    }

    // 12/05/2022 Added by Jimmy Khalil
    // US C360-724: Check if the User can Insert a Opportunite Contact
    if(PAD.CanTrigger('AP110_OpportuniteContact')) {
        AP110_OpportuniteContact.checkIfCanInsertOrDelete(trigger.old);
    }
}