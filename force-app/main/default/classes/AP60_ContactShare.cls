/**
 * @author: Jacques Akiki -EI Technologies
 * @date: 06/06/2019
 * @description: Class to share the the contrat with the Opportunity Team members
 * @Test Class:AP60_ContactShare_test
 * @Coverage: 95%
 */
public class AP60_ContactShare {
    public Static Boolean isFirstRun = True;
    /**
     * @author: Jacques Akiki -EI Technologies
     * @date: 06/06/2019
     * @description: Method that shares the contrat with the members of the Opportunity team members
     * @inputs: List<OpportunityTeamMember> ,List<Opportunity>
     * @Outputs: -
     */
    public static void ShareContract(List<OpportunityTeamMember> ListOppTeamMember, list<Opportunity> ListOpp){

        set<Id> setOppId = new set<Id>();
        set<Id> setOppIdContratOrigine = new set<Id>();
        set<Id> setContratOrigineId = new set<Id>();
        set<Id> setOppCommercialeContratOrigine = new set<Id>();
        List<OpportunityTeamMember> listOTM = new List<OpportunityTeamMember>();
        if(ListOppTeamMember<> NULL && ListOpp == NULL) { // list of Opportunity Team members sent to method
            for(OpportunityTeamMember otm : ListOppTeamMember) {
                setOppId.add(otm.OpportunityId);  // add Opp id to set
            }
        } else if(ListOpp<> NULL && ListOppTeamMember == NULL) {   // list of Opportunity sent to method
            for(Opportunity opp : ListOpp) {
                if(opp.Contrat_Genere_lookup__c != NULL) {
                    setOppId.add(opp.Id); // add opp id if a contract exists
                }

            }
        }

        /*SELECT all team members related to opportunities with contracts*/
        List<OpportunityTeamMember> ListOppTM = [SELECT id, UserId, OpportunityAccessLevel, OpportunityId, Opportunity.Contrat_Genere_lookup__c,
                                                 opportunity.ContratOrigine__c, opportunity.ContratOrigine__r.OpportuniteCommerciale__c, TeamMemberRole
                                                 FROM OpportunityTeamMember
                                                 WHERE (OpportunityId IN:setOppId) AND (Opportunity.Contrat_Genere_lookup__c != NULL OR opportunity.ContratOrigine__c != NULL) AND User.isActive = true];

        for(OpportunityTeamMember otm : ListOppTM) {
            //Added by Jimmy: on opp team adding we also add to contrat origine its opp commerciale
            if(otm.opportunity.ContratOrigine__c != NULL) {
                setOppIdContratOrigine.add(otm.OpportunityId);
                setContratOrigineId.add(otm.opportunity.ContratOrigine__c);
                if(otm.opportunity.ContratOrigine__r.OpportuniteCommerciale__c != null) {
                    setOppCommercialeContratOrigine.add(otm.opportunity.ContratOrigine__r.OpportuniteCommerciale__c);
                }
            }

        }

        set<String> setUniqueShareOppTeam = new set<String>();
        if(setOppCommercialeContratOrigine.size() > 0) {
            for(OpportunityTeamMember otm : [Select id, UserId, OpportunityId
                                             from OpportunityTeamMember
                                             where OpportunityId in : setOppCommercialeContratOrigine ]) {
                setUniqueShareOppTeam.add(otm.OpportunityId + '_' + otm.UserId);
            }
        }

        if(ListOppTM<> null && ListOppTM.size() > 0) {
            set<String> setUniqueShare = new set<string>();
            set<String> setUniqueShareContratOrigine = new set<string>();
            /*SELECT previous shares on this contract*/
            //get contrat share of contrat origine (ParentId) and contrat genere (Parent.OpportuniteCommerciale__c)
            for(Contrat__Share cs : [SELECT id, UserOrGroupId, ParentId, Parent.OpportuniteCommerciale__c
                                     FROM Contrat__Share
                                     WHERE Parent.OpportuniteCommerciale__c in : setOppId]) {
                setUniqueShare.add(cs.UserOrGroupId + '' + cs.ParentId);
            }
            system.debug('@@@ JK setUniqueShare ' + setUniqueShare);
            List<Contrat__Share> listCS = new List<Contrat__Share>();
            for(OpportunityTeamMember otm : ListOppTM) {
                /*Verify that no share already exists*/
                //this part is for opp trigger and contrat genere
                if(setOppId.contains(otm.OpportunityId) && otm.Opportunity.Contrat_Genere_lookup__c != null) {
                    if(setUniqueShare == NULL || !setUniqueShare.contains(otm.UserId + '' + otm.Opportunity.Contrat_Genere_lookup__c)) {
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
                //this part is for contrat origine
                if(setOppIdContratOrigine.contains(otm.OpportunityId)) {
                    //if opp commerciale of contrat origine exist we check the team members to add new
                    if(!setUniqueShareOppTeam.contains(otm.opportunity.ContratOrigine__r.OpportuniteCommerciale__c + '_' + otm.UserId)) {
                        OpportunityTeamMember newOtm = new OpportunityTeamMember();
                        newOtm.OpportunityId = otm.opportunity.ContratOrigine__r.OpportuniteCommerciale__c;
                        //if owner not the same
                        if(otm.OpportunityAccessLevel == 'All') {
                            newOtm.OpportunityAccessLevel = 'Edit';
                        } else {
                            newOtm.OpportunityAccessLevel = otm.OpportunityAccessLevel; // same access level
                        }
                        newOtm.UserId = otm.UserId;
                        if(otm.TeamMemberRole == Label.AP22_TeamMemberRole){
                            newOtm.TeamMemberRole = Label.PV_OTM_Comm;
                        }else{
                            newOtm.TeamMemberRole = otm.TeamMemberRole;
                        }
                        
                        listOTM.add(newOtm);
                    }

                }

            }

            system.debug('@@@ JK listCS ' + listCS);
            system.debug('@@@ JK listOTM ' + listOTM);
            if(listCS != NULL && listCS.size() > 0) {
                try {
                    insert listCS;   // share the contrats with members
                }
                Catch (Exception exp){
                    System.debug('Error in sharing.........' + exp.getMessage());
                }
            }
            if(listOTM != NULL && listOTM.size() > 0) {
                try {
                    if(isFirstRun) {
                        isFirstRun = false;
                        insert listOTM;   // add opp team members
                    }
                }
                Catch (Exception exp){
                    System.debug('Error in OppTeam Creation.........' + exp.getMessage());
                }
            }
        }

    }

}