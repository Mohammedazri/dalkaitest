/**
* @author: Jacques Akiki -EI Technologies
* @date: 05/07/2019
* @Test Class:AP60_ContactShare_test 
* @Coverage: 100%
*/
trigger OppTeamMemberBeforeDelete on OpportunityTeamMember (before delete) {    
    
    if(PAD.CanTrigger('AP95_OpportunityTeamMember'))
    {
        AP95_OpportunityTeamMember.checkIfOwnerIsDeleted(Trigger.oldMap);
    }
}