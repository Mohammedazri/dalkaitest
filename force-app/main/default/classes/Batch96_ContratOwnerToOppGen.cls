/** 
* @author Jacques Akiki 
* @date 30/09/2020 
* @description Add contrat owner to Opp team members
* @Test Class Batch96_ContratOwnerToOppGen_test 100%
*/
global class Batch96_ContratOwnerToOppGen implements Database.Batchable<SObject> {
    /** 
* @author Jacques Akiki
* @date 30/09/2020   
* @ query OpportunityTeamMembers related to Opportunity of evolution or renouvellement with Active owner on contrat
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='SELECT id,OwnerId,ContratOrigine__r.OwnerId FROM Opportunity WHERE ContratOrigine__c!=NULL AND ContratOrigine__r.ZZZtechActiveOwner__c =true ';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Jacques Akiki
* @date 30/09/2020  
* @Add Owner to opportunityTeam Member or change Access if owner already exists
* @param Database.BatchableContext and list of OpportunityTeamMember
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        map<id,id> mapOppIdContOwner = new map<id,id>();
        map<id,id> mapOppIdOppOwner = new map<id,id>();
        for(Opportunity opp:listOpp)
        {
            mapOppIdContOwner.put(opp.id,opp.ContratOrigine__r.OwnerId);
            mapOppIdOppOwner.put(opp.id,opp.OwnerId);
        }
        List<OpportunityTeamMember> listOTM = [SELECT id,userId,OpportunityAccessLevel,TeamMemberRole,OpportunityId
                                               FROM OpportunityTeamMember
                                               WHERE OpportunityId in:mapOppIdContOwner.keyset()];
        map<id,List<OpportunityTeamMember>> mapOppOTM = new map<id,List<OpportunityTeamMember>>();
        for(OpportunityTeamMember otm:listOTM)
        {
            if(!mapOppOTM.containskey(otm.OpportunityId))
            {
                mapOppOTM.put(otm.OpportunityId,new List<OpportunityTeamMember>());
            }
            mapOppOTM.get(otm.OpportunityId).add(otm);
        }
        List<OpportunityTeamMember> lisOtmUpdate = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> lisOtmInsert = new List<OpportunityTeamMember>();
        
        for (id oppId :mapOppOTM.keyset())
        {
            if(mapOppIdOppOwner.get(oppId)!=mapOppIdContOwner.get(oppId))
            {
                Boolean ownerExists = false;
                for(OpportunityTeamMember otm : mapOppOTM.get(oppId))
                {
                    if(otm.UserId == mapOppIdContOwner.get(otm.opportunityId))
                    {
                        ownerExists = true;
                        if(otm.OpportunityAccessLevel !='ALL' && otm.TeamMemberRole !='Opportunity Owner')
                        {
                            if(otm.OpportunityAccessLevel!=Label.Label_Edit && otm.TeamMemberRole==NULL)
                            {   
                                otm.OpportunityAccessLevel=Label.Label_Edit;
                                otm.TeamMemberRole=Label.PV_OTM_Comm;
                                lisOtmUpdate.add(otm);
                            }
                            else if(otm.OpportunityAccessLevel==Label.Label_Edit && otm.TeamMemberRole==NULL)
                            {
                                otm.TeamMemberRole=Label.PV_OTM_Comm;
                                lisOtmUpdate.add(otm);
                            }
                            else if(otm.OpportunityAccessLevel!=Label.Label_Edit && otm.TeamMemberRole!=NULL)
                            {
                                otm.OpportunityAccessLevel=Label.Label_Edit;
                                lisOtmUpdate.add(otm);
                            }
                        }
                    }
                }
                if(!ownerExists)
                {
                    OpportunityTeamMember otmins = new OpportunityTeamMember();
                    otmins.OpportunityId = oppId; 
                    otmins.UserId = mapOppIdContOwner.get(oppId); 
                    otmins.OpportunityAccessLevel = Label.Label_Edit; 
                    otmins.TeamMemberRole = Label.PV_OTM_Comm;
                    lisOtmInsert.add(otmins);
                }
            }
        }
        if(lisOtmUpdate!=NULL &&lisOtmUpdate.size()>0)
        {
            update lisOtmUpdate;
        }
        if(lisOtmInsert!=NULL &&lisOtmInsert.size()>0)
        {
            system.debug('....................'+lisOtmInsert);
            insert lisOtmInsert;
        }
        
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}