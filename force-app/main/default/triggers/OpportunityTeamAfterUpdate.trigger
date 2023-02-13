/*
Author: Johny Kassis
Company: EI-technologies
Description: Trigger used to prevent User to add an OpportunityTeamMember with the role'Opportunity Owner' and with a user that isn't the Opportunity's owner
Date: 26/03/2018
Test Class: AP22_OpportunityTeamMember_test
*/
trigger OpportunityTeamAfterUpdate on OpportunityTeamMember (After Update) 
{
    List<OpportunityTeamMember> AP22List= new List<OpportunityTeamMember>();
    for(OpportunityTeamMember opp: Trigger.new)
    {
        if(opp.TeamMemberRole!= Trigger.oldmap.get(opp.id).TeamMemberRole)
        {
            AP22List.add(opp) ;
        }
    }
    if(PAD.CanTrigger('AP22_OpportunityTeamMember') && AP22List.size()>0 )
        AP22_OpportunityTeamMember.CheckOpportunityOwner(AP22List);
    
    if(PAD.CanTrigger('AP60_ContactShare'))
    {
        AP60_ContactShare.ShareContract(Trigger.new,null);
    }
}