/*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: 
Test Class: AP95_OpportunityTeamMember_Test(100%)
History
28/01/2021 Jimmy Khalil  Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP95_OpportunityTeamMember { 
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: Prevent User from deleting the owner from the opp team members
Inputs: list of Opportunities on Insert/after update and list of Opportunities before update
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static void checkIfOwnerIsDeleted(Map<Id,OpportunityTeamMember> mapOldOpp)
    {
        List<Opportunity> listOpportunties = new List<Opportunity>();
        Set<String> setOwnerIds = new Set<String>();
        Set<String> setOppIdsToCheck = new Set<String>();
        Map<String,Set<String>> mapUserIdOppIdinTeams = new Map<String,Set<String>>();
        
        //check if it's an insert or update
        
        //get the owner Ids for opps to delete
        for(OpportunityTeamMember oppTM:mapOldOpp.values()){
            setOwnerIds.add(oppTM.UserId);
            setOppIdsToCheck.add(oppTM.OpportunityId); 
        }
        
        if(setOwnerIds != null && setOwnerIds.size()>0){
            //get current team member for the new owners and opps
            listOpportunties = [SELECT id,OwnerId 
                                       FROM Opportunity 
                                       WHERE id in :setOppIdsToCheck
                                       AND OwnerId in :setOwnerIds];
            if(listOpportunties != null && listOpportunties.size()>0){
                for(Opportunity Opp:listOpportunties){
                    if(!mapUserIdOppIdinTeams.containsKey(Opp.OwnerId)){
                        mapUserIdOppIdinTeams.put(Opp.OwnerId, new Set<String>());
                    }
                    mapUserIdOppIdinTeams.get(Opp.OwnerId).add(Opp.Id);
                }
            }
            for(OpportunityTeamMember oppTM:mapOldOpp.values()){
                
                //if the owner is a team member, add an error
                if(mapUserIdOppIdinTeams.containsKey(oppTM.UserId) && mapUserIdOppIdinTeams.get(oppTM.UserId).contains(oppTM.OpportunityId )){
                    
                    oppTM.addError(Label.AP95_CannotDeleteOwner);
                }
            } 
        }
    }
}