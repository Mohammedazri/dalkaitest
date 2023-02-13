/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: Class used by the triggers OpportunityTeamAfterInsert and OpportunityTeamAfterUpdate to check the if the role of the OpportunityTeamMember is valid
Date: 26/03/2018
Test Class: AP22_OpportunityTeamMember_test
--------------------------------------------------------------------------------------------------------------------------*/
public class AP22_OpportunityTeamMember 
{
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description:  add error to the OpportunityTeamMember if the role is owner and the member isn't the owner of the opportuniy
Inputs: list of OpportunityTeamMember 
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/

    public static void CheckOpportunityOwner(List<OpportunityTeamMember> oppTeamMemberList)
    {
        Set<ID> oppIdSet =new Set<ID>();
        for(OpportunityTeamMember opp: oppTeamMemberList)
        {
            oppIdSet.add(opp.OpportunityId);
        } 
        
        MAP<id,Opportunity> opportunityMap = new Map<id, Opportunity>([SELECT id, OwnerID
                                                                       FROM Opportunity
                                                                       WHERE id in:oppIdSet]);
        
        
        for(OpportunityTeamMember opp: oppTeamMemberList)
        {
            if(( opportunityMap.get(opp.OpportunityId).OwnerID!= opp.UserID  && opp.TeamMemberRole==Label.AP22_TeamMemberRole )
               || ( opportunityMap.get(opp.OpportunityId).OwnerID== opp.UserID  && opp.TeamMemberRole!=Label.AP22_TeamMemberRole )
              )
            { 
                opp.adderror(Label.AP22_errorMsg);
            }
        }
    }
    
}