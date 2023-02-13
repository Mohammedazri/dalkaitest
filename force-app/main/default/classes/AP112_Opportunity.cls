/** 
* @author: Jimmy Khalil
* @date: 21/06/2022 
* @description:  Ajouter le DAC dans l'équipe d'opportunité à la réalisation (US C360-749)
* @Test: AP112_Opportunity_test(100%)
*/
public without sharing class AP112_Opportunity {
    public static void addDACinTeams(Map<Id,Opportunity> mapOppNew,Map<Id,Opportunity>mapOldOpportunite){
        List<OpportunityTeamMember> listOppTeamMembersToInsert = new List<OpportunityTeamMember>();
        Map<String,List<Opportunity>> mapAgenceOpps = new Map<String,List<Opportunity>>();
        Set<Id> setOppIds = new Set<Id>();
        
        //map Agence and related Opps
        for(Opportunity opp:mapOppNew.values()){
            if((opp.stagename != mapOldOpportunite.get(opp.Id).stagename) &&
               opp.stagename ==Label.PV_Realisation && 
               opp.techagenceName__c != null && String.isNotEmpty(opp.techagenceName__c)){
                   String agenceNameUpperCase = opp.techagenceName__c.toUpperCase();
                   if(!mapAgenceOpps.containsKey(agenceNameUpperCase)){
                       mapAgenceOpps.put(agenceNameUpperCase,new List<Opportunity>());
                   }
                   mapAgenceOpps.get(agenceNameUpperCase).add(opp);
                   setOppIds.add(opp.Id);
               }
        }
        
        if(setOppIds.size()>0){
            //Get Existing Team Members who has owner access
            Map<Id,List<String>> mapOppIdUsers = new Map<Id,List<String>>();
            for(OpportunityTeamMember oppTM: [Select Id,OpportunityId,UserId
                                              From OpportunityTeamMember
                                              Where OpportunityId in:setOppIds
                                              And OpportunityAccessLevel=:Label.AP94_OpportunityAccessLevel]){
                                                  if(!mapOppIdUsers.containsKey(oppTM.OpportunityId)){
                                                      mapOppIdUsers.put(oppTM.OpportunityId,new List<String>());
                                                  }
                                                  mapOppIdUsers.get(oppTM.OpportunityId).add(oppTM.UserId);
                                              }               
            
            System.debug('@@@JK mapOppIdUsers ' + mapOppIdUsers);
            //get all active DAC or DAC One users of the agences of the realized Opps 
            //Owners will already be added in the teams
            for(User dacUser:[Select Id,Nom_agence__c 
                              From User 
                              Where Nom_agence__c in:mapAgenceOpps.keySet()
                              And (Profile.Name = :Label.Profile_DAC Or Profile.Name = :Label.Profile_DACFirst)
                              And isActive = True]){
                                  String agenceNameUserUpperCase = dacUser.Nom_agence__c.toUpperCase();
                                  for(Opportunity opp:mapAgenceOpps.get(agenceNameUserUpperCase)){
                                      
                                      if(!mapOppIdUsers.containsKey(opp.Id) || !mapOppIdUsers.get(opp.Id).contains(dacUser.Id)){
                                          OpportunityTeamMember newOppMember = new OpportunityTeamMember();
                                          newOppMember.OpportunityId = opp.Id;
                                          newOppMember.UserId = dacUser.Id;
                                          newOppMember.TeamMemberRole = Label.TeamMemberRoleCommercre;
                                          newOppMember.OpportunityAccessLevel = Label.OpportunityAccessLevelEdit;
                                          
                                          listOppTeamMembersToInsert.add(newOppMember); 
                                      }
                                  }
                              }
            if(listOppTeamMembersToInsert.size()>0){
                Insert listOppTeamMembersToInsert;
            }
        }
    }
}