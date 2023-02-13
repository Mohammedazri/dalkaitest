/*--------------------------------------------------------------------------------------------------------------------------	
Author: Dona Kfoury	
Company: EI-Technologies	
Description: Apex trigger OpportunityBeforeUpdate	
Test Class: AP17_BudgetOnOpp_test 81%	
History	
10/04/2018 Johny Kassis added the condition diffrent than "Évolution"	
12/04/2018 Johny Kassis  moved the class AP24 from OpportunityAfterUpdate to OpportunityBeforeUpdate	
20/04/2018 Johny Kassis  added the function  AP16_OpportunityRealisation.checkModifiedFields	
30/08/2018 Jacques Akiki Added conditions inside if to include RT.	
10/12/2018 Chadi Geara Added  AP41_Opportunity.trimName(trigger.new,null);	
--------------------------------------------------------------------------------------------------------------------------*/	
trigger OpportunityBeforeUpdate on Opportunity (before update) {	
    PAD.PAD_BypassTrigger+=';AP45_Account;';	
    List<Opportunity> OpportunityList= new List<Opportunity>();	
    List<Opportunity> OppListToAP16update= new List<Opportunity>();	
    List<Opportunity> OppListToAP16create= new List<Opportunity>();	
    List<Opportunity> OpportunityAP17 = new List<Opportunity>();	
    List<Opportunity> AP24_OpportunityList = new List<Opportunity>();	
    List<Opportunity> AP30_OppList =new List<Opportunity>();	
    List<Opportunity> AP93_OppList =new List<Opportunity>();	
    List<Opportunity> AP103_OppList =new List<Opportunity>();	
    	
    Set<id> setOppId = new set<Id>();	
    Set<Id> setAgenceIds = new Set<Id>();	
    Map<Opportunity,id> mapOppIdAgencyId = new Map<Opportunity ,id>();	
    for (Opportunity thisOpportunity : trigger.new)	
    {	
        if(thisOpportunity.closedate != trigger.oldMap.get(thisOpportunity.Id).closedate)	
        {	
            AP93_OppList.add(thisOpportunity);	
        }	
        if((thisOpportunity.name != trigger.oldMap.get(thisOpportunity.Id).name )	
           && thisOpportunity.FicheSynthese__r!= null)	
        {	
            AP24_OpportunityList.add(thisOpportunity);	
        }	
        	
        if(((thisOpportunity.Annee_de_signature__c != trigger.oldMap.get(thisOpportunity.Id).Annee_de_signature__c) 	
            || (thisOpportunity.ContratOrigine__c != trigger.oldMap.get(thisOpportunity.Id).ContratOrigine__c))	
           && thisOpportunity.ContratOrigine__c != null && thisOpportunity.Statut__c == Label.Opp_StatutEnCours	
           && (thisOpportunity.Type_pers__c == Label.PV_Renouvellement||thisOpportunity.Type_pers__c == Label.PV_Evolution))	
            	
        {	
            OpportunityAP17.add(thisOpportunity);	
        }	
        if( thisOpportunity.Tech_CdtRefSelectionnee__c != trigger.oldMap.get(thisOpportunity.Id).Tech_CdtRefSelectionnee__c )	
        {	
            AP30_OppList.add(thisOpportunity);	
        }	
        	
        	
        if((thisOpportunity.stagename != trigger.oldMap.get(thisOpportunity.Id).stagename)&& thisOpportunity.stagename ==Label.LC28_Realise && thisOpportunity.Statut__c ==Label.OppBeforeUp_gagne 	
           && ((thisOpportunity.type_pers__c !=Label.AP16_evolution ) || (thisOpportunity.type_pers__c == Label.PV_Opp_Type_Nouveau /*Label.AP16_evolution*/ && thisOpportunity.OpportuniteMere__c !=NULL)))//10/04/2018 Johny Kassis	
        {	
            if(thisOpportunity.Contrat_Genere_lookup__c!= null )	
            {	
                OppListToAP16update.add(thisOpportunity); 	
            }	
            	
            else	
            {	
                OppListToAP16create.add(thisOpportunity);	
            }	
        }	
        //add to this condition other conditions of other RTs	
        if((thisOpportunity.OwnerId != trigger.oldMap.get(thisOpportunity.Id).OwnerId) 	
           || (thisOpportunity.Annee_de_signature__c != trigger.oldMap.get(thisOpportunity.Id).Annee_de_signature__c))	
        {	
            OpportunityList.add(thisOpportunity);	
            system.debug('##OpportunityList' + OpportunityList);	
        }	
        	
        //check if agence changed => region changed or Annee de signature	
        if((thisOpportunity.Libelle_Agence__c != trigger.oldMap.get(thisOpportunity.Id).Libelle_Agence__c) 	
           || (thisOpportunity.Annee_de_signature__c != trigger.oldMap.get(thisOpportunity.Id).Annee_de_signature__c))	
        {	
            AP103_OppList.add(thisOpportunity);	
        }	
        	
        	
         	
    }	
    if(PAD.CanTrigger('AP07_Opportunity')&&(OpportunityList.size()>0))	
    {	
        AP07_Opportunity.UpdateOpportunityBeforeUpdate(OpportunityList);	
    } 	
    	
    //update ZZZ TECH_Objectif_Regional	
    if(PAD.CanTrigger('AP103_Opportunity')&&(AP103_OppList.size()>0))	
    {	
        AP103_Opportunity.updateTechObjectifRegional(AP103_OppList);	
    } 	
    	
    //on modifie les contrats des opportunités s'ils sont déjà crée	
    if(PAD.CanTrigger('AP16_OpportunityRealisation')&&(OppListToAP16update.size()>0)) 	
    {	
        AP16_OpportunityRealisation.UpdateContrat(OppListToAP16update, trigger.oldmap);	
    }	
    	
    if(PAD.CanTrigger('AP16_OpportunityRealisation'))   	
    {	
        AP16_OpportunityRealisation.checkModifiedFields(trigger.new, trigger.oldmap);	
    }	
    if(PAD.CanTrigger('AP16_OpportunityRealisation')&&(OppListToAP16create.size()>0))	
    {	
        AP16_OpportunityRealisation.CreateContrat(OppListToAP16create);	
    }	
    if(PAD.CanTrigger('AP17_BudgetOnOpp') && OpportunityAP17!= null && OpportunityAP17.size()>0 )	
    {	
        AP17_BudgetOnOpp.UpdateBudgetOnOpportunityFromOpportunity(OpportunityAP17);	
    }	
    if(PAD.CanTrigger('AP09_Opportunity') )	
    {	
        if(!Validation_Opportunity.hasAlreadyDone8())	
        {	
            AP09_Opportunity.checkContractResilieUpd(trigger.new,trigger.oldMap); 	
            AP09_Opportunity.checkExistanceRenewalOppUpd(trigger.new,trigger.oldMap); 	
        }	
        Validation_Opportunity.setAlreadyDone8();	
    }	
    	
    if(PAD.CanTrigger('AP24_OpportunityFDS')&& AP24_OpportunityList!= null && AP24_OpportunityList.size()>0)	
    {	
        AP24_OpportunityFDS.changeOppName(AP24_OpportunityList);	
    }	
    	
    if(PAD.CanTrigger('AP25_OpportunityAvntRealise'))	
    {	
        AP25_OpportunityAvntRealise.ModifyOppTechNumAvnt(Trigger.new, trigger.oldmap);	
    }	
    	
    if(PAD.CanTrigger('AP30_UpdateCAEcartMBrute') && AP30_OppList!= null && AP30_OppList.size()>0)  	
    {	
        AP30_UpdateCAEcartMBrute.UpdateCAEcart(AP30_OppList);	
    }	
    	
    if(PAD.CanTrigger('AP53_Opportunity'))  	
    {	
        AP53_Opportunity.UpdateVisionResiliation(trigger.new, trigger.OldMap);	
    }	
    	
    //We do NOT want to by pass this class/function under any circumstances	
    AP41_Opportunity.trimNameOpp(trigger.new, trigger.oldMap);	
    	
    if(PAD.CanTrigger('AP57_Affaire'))	
    {	
        AP57_Affaire.updateOpportunityAffaire(trigger.new);	
    } 	
    if(PAD.CanTrigger('AP65_OppProbability'))	
    {	
        AP65_OppProbability.setOppProbability(trigger.new);	
    }	
    if(PAD.CanTrigger('AP80_Opportunity'))	
    {	
        AP80_Opportunity.setPiloteLorsRealisation(trigger.new , trigger.oldMap);	
    }	
    if(PAD.CanTrigger('AP81_OpportunityRenouv'))	
    {	
        AP81_OpportunityRenouv.addErrorOnRenouvellement(trigger.new,trigger.oldMap);	
    }	
    if(PAD.CanTrigger('AP89_BlockOppEvolChanges'))	
    {	
        AP89_BlockOppEvolChanges.addErrorOppEvol(trigger.oldMap,trigger.newmap);	
    }	
    if(PAD.CanTrigger('AP93_DocumentDateEffet') && AP93_OppList != null && AP93_OppList.size()>0)	
    {	
        AP93_DocumentDateEffet.MAJTechField(AP93_OppList);        	
    }
    if(PAD.canTrigger('AP108_Opportunity')){
        AP108_Opportunity.contactObligatoire(trigger.new, trigger.oldMap);
    }	
}