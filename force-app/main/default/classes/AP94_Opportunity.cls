/*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: 
Test Class: AP94_Opportunity_Test(100%)
History
28/01/2021 Jimmy Khalil  Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP94_Opportunity {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: Add opportunity owner to team member on insert or on update if he isn't in the team
Inputs: list of Opportunities on Insert/after update and list of Opportunities before update
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static void addOwnerToTeamsOnUpdate(List<Opportunity> listOpps)
    {
        List<OpportunityTeamMember> listExistingTeamMembers = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> listTeamMembersToInsert = new List<OpportunityTeamMember>();
        Set<String> setOwnerIds = new Set<String>();
        Set<String> setOppIdsToCheck = new Set<String>();
        Map<String,Set<String>> mapUserIdOppIdinTeams = new Map<String,Set<String>>();
        
        
        //get the owner Ids for opps with changed owners
        for(Opportunity opp:listOpps){
            setOwnerIds.add(opp.OwnerId);
            setOppIdsToCheck.add(opp.Id);
        }
        
        if(setOwnerIds != null && setOwnerIds.size()>0){
            //get current team member for the new owners and opps
            listExistingTeamMembers = [SELECT id,OpportunityId, UserId 
                                       FROM OpportunityTeamMember 
                                       WHERE OpportunityId in :setOppIdsToCheck
                                       AND UserId in :setOwnerIds];
            if(listExistingTeamMembers != null && listExistingTeamMembers.size()>0){
                for(OpportunityTeamMember OppTeamMember:listExistingTeamMembers){
                    if(!mapUserIdOppIdinTeams.containsKey(OppTeamMember.UserId)){
                        mapUserIdOppIdinTeams.put(OppTeamMember.UserId, new Set<String>());
                    }
                    mapUserIdOppIdinTeams.get(OppTeamMember.UserId).add(OppTeamMember.OpportunityId);
                }
            }
            OpportunityTeamMember oppTeamMemberToInsertonUpdate = new OpportunityTeamMember();
            for(Opportunity opp:listOpps){
                
                //if the owner is not already a team member, we add him
                if(!mapUserIdOppIdinTeams.containsKey(opp.OwnerId) || !mapUserIdOppIdinTeams.get(opp.OwnerId).contains(opp.id)){
                    
                    oppTeamMemberToInsertonUpdate = new OpportunityTeamMember();
                    oppTeamMemberToInsertonUpdate.OpportunityId =opp.Id;
                    oppTeamMemberToInsertonUpdate.UserId = opp.OwnerId;
                    oppTeamMemberToInsertonUpdate.TeamMemberRole=Label.AP94_TeamMemberRole;//'Pilote de l\'opportunité';
                    oppTeamMemberToInsertonUpdate.OpportunityAccessLevel=Label.AP94_OpportunityAccessLevel;  
                    
                    listTeamMembersToInsert.add(oppTeamMemberToInsertonUpdate);
                }
            } 
        }
        
        
        
        if(listTeamMembersToInsert.size()>0){
            insert listTeamMembersToInsert;
        }
    }
    
    public static void addOwnerToTeamsOnInsert(List<Opportunity> listOpps)
    {
        List<OpportunityTeamMember> listTeamMembersToInsert = new List<OpportunityTeamMember>();
        
        //for new opportunnities, create a team member for the owner
        OpportunityTeamMember oppTeamMemberToInsert = new OpportunityTeamMember();
        for(Opportunity opp:listOpps){
            oppTeamMemberToInsert = new OpportunityTeamMember();
            oppTeamMemberToInsert.OpportunityId =opp.Id;
            oppTeamMemberToInsert.UserId = opp.OwnerId;
            oppTeamMemberToInsert.TeamMemberRole=Label.AP22_TeamMemberRole;//'Pilote de l\'opportunité';
            oppTeamMemberToInsert.OpportunityAccessLevel='All';  
            
            listTeamMembersToInsert.add(oppTeamMemberToInsert);
        }
        
        
        if(listTeamMembersToInsert.size()>0){
            insert listTeamMembersToInsert;
        }
    }
}