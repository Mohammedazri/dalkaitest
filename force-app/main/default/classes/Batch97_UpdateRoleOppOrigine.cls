/** 
* @author Jacques Akiki 
* @date 01/10/2020 
* @description Batch that fills the role of opportunity Team member with commercial if the user is the owner of contrat généré  
* @Test Class Batch97_UpdateRoleOppOrigine_test 100%
*/
global class Batch97_UpdateRoleOppOrigine implements Database.Batchable<SObject> {
    /** 
* @author Jacques Akiki
* @date 01/10/2020   
* @ query OpportunityTeamMembers related to Opportunity of evolution or renouvellement with Active owner on contrat
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='SELECT id,userId,TeamMemberRole,OpportunityId ,Opportunity.Contrat_Genere_lookup__c , Opportunity.Contrat_Genere_lookup__r.ownerId'+
            ' FROM OpportunityTeamMember WHERE Opportunity.Contrat_Genere_lookup__c!=NULL AND TeamMemberRole = NULL AND OpportunityAccessLevel!=\'ALL\'';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Jacques Akiki
* @date 01/10/2020  
* @ set role to commercial on opportunity Team member if same owner as contrat généré owner
* @param Database.BatchableContext and list of OpportunityTeamMember
* @return void
*/
    global void execute (Database.BatchableContext bc , List<OpportunityTeamMember> listOTM)
    {
        List<opportunityTeamMember> listOtmUpdate = new List<OpportunityTeamMember>();
        for (OpportunityTeamMember otm :listOTM)
        {
            if(otm.userId == otm.Opportunity.Contrat_Genere_lookup__r.ownerId)
            {
                otm.TeamMemberRole = Label.PV_OTM_Comm;
                listOtmUpdate.add(otm);
            }
        }
        if (listOtmUpdate!=NULL && listOtmUpdate.size()>0)
        {
            update listOtmUpdate;
        }
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}