/*--------------------------------------------------------------------------------------------------------------------------
   Author: Dona Kfoury
   Company: EI-Technologies
   Description: Apex trigger OpportunityBeforeInsert
   Test Class:
   History
   12/04/2018 Johny Kassis  added the class AP24
   30/08/2018 Jacques Akiki Modif des conditions
   10/12/2018 Chadi Geara Added  AP41_Opportunity.trimName(trigger.new,null);
   --------------------------------------------------------------------------------------------------------------------------*/
trigger OpportunityBeforeInsert on Opportunity (before insert) {
    PAD.PAD_BypassTrigger += ';AP45_Account;';
    List<Opportunity> OpportunityAP17 = new List<Opportunity>();
    set<id> setOwnerId = new set<Id>();
    for(Opportunity thiOpportunity : trigger.new) {
        setOwnerId.add(thiOpportunity.OwnerId);

        if(thiOpportunity.ContratOrigine__c != null && thiOpportunity.Statut__c == Label.Opp_StatutEnCours
           && (thiOpportunity.Type_pers__c == Label.PV_Renouvellement || thiOpportunity.Type_pers__c == Label.PV_Evolution) ) {
            OpportunityAP17.add(thiOpportunity);
        }
    }
    if(PAD.CanTrigger('AP32_ChangeInLabelAgence')) {
        if(!Validation_Opportunity.hasAlreadyDone6()) {
            AP32_ChangeInLabelAgence.LabelAgency(setOwnerId, trigger.new);
        }
        Validation_Opportunity.setAlreadyDone6();
    }

    if(PAD.CanTrigger('AP07_Opportunity')) {
        AP07_Opportunity.UpdateOpportunityBeforeInsert(trigger.new);
    }

    if(PAD.CanTrigger('AP103_Opportunity')) {
        AP103_Opportunity.updateTechObjectifRegional(trigger.new);
    }

    //Set the field tech_Budget__c when an opportunity is created
    if(PAD.CanTrigger('AP17_BudgetOnOpp') && OpportunityAP17 != null && OpportunityAP17.size() > 0) {
        AP17_BudgetOnOpp.UpdateBudgetOnOpportunityFromOpportunity(OpportunityAP17);
    }
    if(PAD.CanTrigger('AP09_Opportunity') ) {
        AP09_Opportunity.checkContractResilieIns(trigger.new);
        AP09_Opportunity.checkExistanceRenewalOppIns(trigger.new);
    }

    //change the Opportunity name to uppercase letters
    if(PAD.CanTrigger('AP24_OpportunityFDS')) {
        AP24_OpportunityFDS.changeOppName(trigger.new);
    }

    //We do NOT want to by pass this class/function under any circumstances
    AP41_Opportunity.trimNameOpp(trigger.new, null);

    if(PAD.CanTrigger('AP57_Affaire')) {
        AP57_Affaire.updateOpportunityAffaire(trigger.new);
    }
    if(PAD.CanTrigger('AP65_OppProbability')) {
        AP65_OppProbability.setOppProbability(trigger.new);
    }
    if(PAD.CanTrigger('AP81_OpportunityRenouv')) {
        AP81_OpportunityRenouv.addErrorOnRenouvellement(trigger.new, null);
    }
    //Added by Jimmy 08/02/2022 - CVS
    if(PAD.CanTrigger('AP104_Opportunity')) {
        AP104_Opportunity.setNatureOffre(trigger.new);
    }
}