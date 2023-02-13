/** 
* @author Jacques Akiki - Ei technologies
* @date 21/01/2020 
* @description Batch to share contrts with opportunity Team Member
* @Test Class Batch63_ContratShare_Test
*/

global class Batch63_ContratShare implements Database.Batchable<SObject>,Database.stateful
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id,UserId,OpportunityAccessLevel,OpportunityId,Opportunity.Contrat_Genere_lookup__c FROM OpportunityTeamMember' +
            ' WHERE User.isActive=true AND Opportunity.Contrat_Genere_lookup__c <> null';
        return Database.getQueryLocator(query);
        
    }
    global void execute (Database.BatchableContext bc , List<OpportunityTeamMember> listOTM)
    {
        set<id> setContId = new set<id>();
        set<id> setUsrId = new set<id>();
        List<contrat__Share> listContratShare = new List<Contrat__Share>();
        for(OpportunityTeamMember otm:listOTM )
        {
            setContId.add(otm.Opportunity.Contrat_Genere_lookup__c) ;
            setUsrId.add(otm.UserId); 
        }
        List<Contrat__share> listCS = [SELECT id,UserOrGroupId,ParentId 
                                       FROM Contrat__Share 
                                       WHERE UserOrGroupId in:setUsrId AND ParentId in:setContId];
        set<string> setContShare = new set<string>();
        for(Contrat__share cs:listCS)
        {
            setContShare.add(String.valueOf(cs.UserOrGroupId)+String.valueOf(cs.ParentId));
        }
        for (OpportunityTeamMember otm:listOTM)
        {
            if(!setContShare.contains(String.valueOf(otm.UserId)+String.valueOf(otm.Opportunity.Contrat_Genere_lookup__c)))
            {
                Contrat__Share cs = new Contrat__Share();
                cs.UserOrGroupId = otm.UserId;
                cs.ParentId = otm.Opportunity.Contrat_Genere_lookup__c;
                if(otm.OpportunityAccessLevel=='All')
                {
                    cs.AccessLevel = 'Edit';
                }
                else
                {
                    cs.AccessLevel = otm.OpportunityAccessLevel; // same access level
                }
                listContratShare.add(cs);
            }
        }
        if(listContratShare<>null && listContratShare.size()>0)
        {
            insert listContratShare;
        }
        
        
    }
    global void finish(Database.BatchableContext bc)
    {
        
    }
}