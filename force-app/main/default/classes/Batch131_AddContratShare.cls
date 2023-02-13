/**
 * @author Jimmy Khalil - EIT Mena
 * @date 04/10/2022
 * @description Créer des enregistrements de contrat__Share en se basant sur la concaténations des équipes d'opportunités d'origine et générées avec l'accès le moins restrictif. (RDD US C360-815)
 * @Test Class Batch131_AddContratShare_Test 100%
 */

global class Batch131_AddContratShare implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){

        //Get All Opps at Proposition or Réalisation wihtout FDS
        String query = 'select id,UserOrGroupId, ParentId From Contrat__Share';

        return Database.getQueryLocator(query);
    }

    global void execute (Database.BatchableContext bc, List<Contrat__Share> listContShare){
        List<Contrat__Share> listCS = new List<Contrat__Share>();
        Map<String, Set<String>> mapIdContratUsers = new Map<String, Set<String>>();
        for(Contrat__Share cs : listContShare) {
            if(!mapIdContratUsers.containsKey(cs.ParentId)) {
                mapIdContratUsers.put(cs.ParentId, new Set<String>());
            }
            mapIdContratUsers.get(cs.ParentId).add(cs.ParentId + '_' + cs.UserOrGroupId);
        }
        List<OpportunityTeamMember> ListOppTM = [SELECT id, UserId, OpportunityAccessLevel, OpportunityId, Opportunity.Contrat_Genere_lookup__c, Opportunity.Contrat_Genere_lookup__r.OwnerId,
                                                 opportunity.ContratOrigine__c, Opportunity.ContratOrigine__r.OwnerId, opportunity.ContratOrigine__r.OpportuniteCommerciale__c, TeamMemberRole
                                                 FROM OpportunityTeamMember
                                                 WHERE (Opportunity.Contrat_Genere_lookup__c in :mapIdContratUsers.keySet() OR opportunity.ContratOrigine__c in :mapIdContratUsers.keySet())
                                                 AND User.isActive = true];
        if(ListOppTM != null && ListOppTM.size() > 0) {
            for(OpportunityTeamMember otm : ListOppTM) {
                if(otm.Opportunity.Contrat_Genere_lookup__c != null) {
                    if(mapIdContratUsers.containsKey(otm.Opportunity.Contrat_Genere_lookup__c)) {
                        if(!mapIdContratUsers.get(otm.Opportunity.Contrat_Genere_lookup__c).contains(otm.Opportunity.Contrat_Genere_lookup__c + '_' + otm.UserId)) {
                            if(otm.UserId != otm.Opportunity.Contrat_Genere_lookup__r.OwnerId) {
                                Contrat__share cs = new Contrat__share(); // new share
                                cs.UserOrGroupId = otm.UserId;
                                cs.ParentId = otm.Opportunity.Contrat_Genere_lookup__c;
                                if(otm.OpportunityAccessLevel == 'All') {
                                    cs.AccessLevel = 'Edit';
                                } else {
                                    cs.AccessLevel = otm.OpportunityAccessLevel; // same access level
                                }
                                listCS.add(cs);
                            }
                        }
                    }

                }
                //if ContratOrigine__c == Contrat_Genere_lookup__c -> the share is already created before
                if(otm.Opportunity.ContratOrigine__c != null && otm.Opportunity.ContratOrigine__c != otm.Opportunity.Contrat_Genere_lookup__c) {
                    if(mapIdContratUsers.containsKey(otm.Opportunity.ContratOrigine__c)) {
                        if(!mapIdContratUsers.get(otm.Opportunity.ContratOrigine__c).contains(otm.Opportunity.ContratOrigine__c + '_' + otm.UserId)) {
                            if(otm.UserId != otm.Opportunity.ContratOrigine__r.OwnerId) {
                                Contrat__share cs = new Contrat__share(); // new share
                                cs.UserOrGroupId = otm.UserId;
                                cs.ParentId = otm.Opportunity.ContratOrigine__c;
                                if(otm.OpportunityAccessLevel == 'All') {
                                    cs.AccessLevel = 'Edit';
                                } else {
                                    cs.AccessLevel = otm.OpportunityAccessLevel; // same access level
                                }
                                listCS.add(cs);
                            }
                        }
                    }
                }
            }
            insert listCS;
        }

    }

    global void finish(Database.BatchableContext bc){}
}