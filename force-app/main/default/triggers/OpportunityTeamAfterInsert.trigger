/*
Author: Johny Kassis
Company: EI-technologies
Description: Trigger used to prevent User to add an OpportunityTeamMember with the role'Opportunity Owner' and with a user that isn't the Opportunity's owner
Date: 26/03/2018
Test Class: AP22_OpportunityTeamMember_test
*/
trigger OpportunityTeamAfterInsert on OpportunityTeamMember (after insert) {
    
    if(PAD.CanTrigger('AP22_OpportunityTeamMember'))
        AP22_OpportunityTeamMember.CheckOpportunityOwner(trigger.new);
    
     if(PAD.CanTrigger('AP60_ContactShare'))
    {
        AP60_ContactShare.ShareContract(Trigger.new,null);
    }
}