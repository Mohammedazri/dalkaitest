/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Apex trigger OpportunityAfterUpdate
Test Class: AP08_Opportunity_TEST 
History
<Date>      <Authors Name>     <Brief Description of Change>
12/04/2018   Johny Kassis      moved the class AP24 from OpportunityAfterUpdate to OpportunityBeforeUpdate
31/05/2018   Johny Kassis      Added the function AP25_OpportunityAvntRealise.ModifyContratOrigine 
10/07/2018	 Johny Kassis	   Commented AP23 and modified AP15
30/08/2018	 Jacques Akiki		Added conditions to if (to include new opp record type)
--------------------------------------------------------------------------------------------------------------------------*/
trigger OpportunityAfterUpdate on Opportunity (after update) {

    if(String.isBlank(PAD.PAD_BypassTrigger)){
        PAD.PAD_BypassTrigger+='AP45_Account';
    }
    else{
        PAD.PAD_BypassTrigger+=';AP45_Account';
    }
    //Lists Declaration
    List<Opportunity> ap05List = new List<Opportunity>();
    List<Opportunity> OpportunityList = new List<Opportunity>();
    List<Opportunity> OpportunityEvolOuRenouvelList = new List<Opportunity>();
    List<Opportunity> AP24_OpportunityList = new List<Opportunity>();
    List<Opportunity> listAP08_Opportunity = new list<Opportunity>();
    List<Opportunity> listAP08_OpportunityUpdateProjet = new list<Opportunity>();
    List<opportunity> OpportunityList_AP14= new list<opportunity>();
    List<opportunity> OpportunityListBefore= new list<opportunity>();
    List<opportunity> OpportunityFromContratCadre= new list<opportunity>();
    List<opportunity> OpportunityDatePriseEffet= new list<opportunity>();
    
    //  Loop filter the Opportunities and fill the lists with the proper Opportunities 
    for (Opportunity thisOpportunity : trigger.new)
    {
        if(thisOpportunity.closedate != trigger.oldMap.get(thisOpportunity.Id).closedate)
        {
            OpportunityDatePriseEffet.add(thisOpportunity);
        }
        if((thisOpportunity.name != trigger.oldMap.get(thisOpportunity.Id).name )
           && thisOpportunity.FicheSynthese__r!= null)
        {
            AP24_OpportunityList.add(thisOpportunity);
        }
        
        if(thisOpportunity.OwnerId != trigger.oldMap.get(thisOpportunity.Id).OwnerId)
        {
            ap05List.add(thisOpportunity);
        }
        
        
        if((thisOpportunity.Annee_de_signature__c != trigger.oldMap.get(thisOpportunity.Id).Annee_de_signature__c   || (thisOpportunity.ContratOrigine__c != trigger.oldMap.get(thisOpportunity.Id).ContratOrigine__c) )
           && (thisOpportunity.ContratOrigine__c != null) && thisOpportunity.Statut__c == Label.Opp_StatutEnCours 
           && (thisOpportunity.Type_pers__c == Label.PV_Renouvellement || thisOpportunity.Type_pers__c == Label.PV_Evolution))
           
        {
            OpportunityEvolOuRenouvelList.add(thisOpportunity);
        }    
        if(thisOpportunity.OwnerId != trigger.oldMap.get(thisOpportunity.Id).OwnerId)
        {
            OpportunityList.add(thisOpportunity);
        }
        
        Opportunity OldOpp = trigger.oldmap.get(thisOpportunity.Id);
        if(thisOpportunity.CreerNouveauProjetCommercial__c != OldOpp.CreerNouveauProjetCommercial__c)
        {
            listAP08_Opportunity.add(thisOpportunity);
        }
        
        if(thisOpportunity.Type_pers__c != OldOpp.Type_pers__c)
        {
            listAP08_OpportunityUpdateProjet.add(thisOpportunity);
        }
        
        if(thisOpportunity.Amount!=null && (trigger.oldMap.get(thisOpportunity.id).ProjetCommercial__c == thisOpportunity.ProjetCommercial__c || thisOpportunity.ProjetCommercial__c!=null))
        {
            OpportunityList_AP14.add(thisOpportunity);
        }
        if(thisOpportunity.Amount!=null && trigger.oldMap.get(thisOpportunity.id).ProjetCommercial__c != thisOpportunity.ProjetCommercial__c && thisOpportunity.ProjetCommercial__c==null)
        {
            OpportunityListBefore.add(trigger.oldMap.get(thisOpportunity.id));
        }
        OpportunityList_AP14.addall(OpportunityListBefore);
        
        if((thisOpportunity.stagename != trigger.oldMap.get(thisOpportunity.Id).stagename)&&
           thisOpportunity.stagename ==Label.LC28_Realise //&& thisOpportunity.Statut__c ==Label.OppBeforeUp_gagne  --->enlevé le 12/11 par JA
           && thisOpportunity.type_pers__c ==Label.Renouvellement // ajouté par Jacques Akiki le 29/10
           && thisOpportunity.EstOpportuniteMere__c == true
           //&& thisOpportunity.type_pers__c !=Label.AP16_evolution
           && thisOpportunity.ContratOrigine__c!=null){
               OpportunityFromContratCadre.add(thisOpportunity);
           }
    }
    
    //Call the functions and pass the lists as arguments 
    
    if(PAD.CanTrigger('AP38_OpportunityContratCadre') && OpportunityFromContratCadre!=null && OpportunityFromContratCadre.size()>0)
    {
        if(!Validation_Opportunity.hasAlreadyDone())
        {
            AP38_OpportunityContratCadre.CreateContratFils(OpportunityFromContratCadre);
        }
        Validation_Opportunity.setAlreadyDone();
    }
    
    
    // Send a chatter notification if the new owner of the opportunity is neither a member of the account team nor the owner of the account 
    //and it removes the old owner from the opportunity team
    if(PAD.CanTrigger('AP05_Opportunity'))
    {
        if(!Validation_Opportunity.hasAlreadyDone7())
        {
            AP05_Opportunity.SendEmail(ap05List);
        }
        Validation_Opportunity.setAlreadyDone7();
    }
    
    // 28-01-2021 Added by Jimmy Khalil 
    // Anno C360-213: Deactivating the oppotunity split,Add the new Owner to the team members if he isn't already a member 
    if(PAD.CanTrigger('AP94_Opportunity'))
    {
        AP94_Opportunity.addOwnerToTeamsOnUpdate(ap05List); 
    }
    
    // update the fields used as refrence and the lookup field Budget__c on the Fiche_de_synthese__c with the proper values
    if(PAD.CanTrigger('AP15_Budget') && OpportunityEvolOuRenouvelList != null && OpportunityEvolOuRenouvelList.size()>0)
    {
        AP15_Budget.UpdateBdgFDSAfterUpdateAnneeOpp(OpportunityEvolOuRenouvelList);        
    }
    
    if(PAD.CanTrigger('AP08_Opportunity'))
    {
        //create a "Projet commercial" and fill the lookup field ProjetCommercial__c if needed 
        if(listAP08_Opportunity.size()>0)
            AP08_Opportunity.CreateProjetCOmmercial(listAP08_Opportunity);
        
        // change the name of the related "Projet commercial" when the type_pers__c of the opportunity is modified 
        if(listAP08_OpportunityUpdateProjet.size()>0)
            AP08_Opportunity.UpdateNomProjetCOmmercial(listAP08_OpportunityUpdateProjet);
        
    }
    
    //we use the class AP14_OppRollUpSummaryUtility to recalculate the values of the fields CA_en_cours_en_K__c and CA_realis_en_K__c of the related Projet Commercial 
    if(PAD.canTrigger('AP14_OppRollUpSummaryUtility') && OpportunityList_AP14.size()>0)
    {
        list<AP14_OppRollUpSummaryUtility.fieldDefinition> fieldDefinitions = new list<AP14_OppRollUpSummaryUtility.fieldDefinition>();
        fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'Tech_CalculCApondere__c', 'CA_en_cours_en_K__c'));
        fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'Amount', 'CA_realis_en_K__c'));
        
        //this function does a roll up summary on the field mentioned above of the child object (Opportunity) 
        //and update the rollup fields of the parent record (ProjetCommercial__c)
        if(!Validation_Opportunity.hasAlreadyDone5())
        {
            AP14_OppRollUpSummaryUtility.rollUpTrigger(fieldDefinitions, OpportunityList_AP14,'Opportunity', 'ProjetCommercial__c', 'ProjetCommercial__c', ''); 
        }
        Validation_Opportunity.setAlreadyDone5();
    }
    
    //Update the projet commercial name when the name of the related opportunity is changed(if the project is only related to one opportunity)
    if(PAD.canTrigger('AP21_Opportunity'))
    {
        AP21_Opportunity.opportunityProjetCommercial(trigger.new, trigger.OldMap);
    }
    
    // reset the value of the field THO__c of the fiche de syntèse when the field Annee_de_signature__c on the related opportunity is modified
    
    
    //change the FDS name
    if(PAD.CanTrigger('AP24_OpportunityFDS') && AP24_OpportunityList.size()>0)
    {
        AP24_OpportunityFDS.changeFDSName(AP24_OpportunityList);
    }
    
    //When the Opportunity is Modified to 'Gagnée' the contract of origine is updated 
    if(PAD.CanTrigger('AP25_OpportunityAvntRealise'))
    {
        AP25_OpportunityAvntRealise.ModifyContratOrigine(Trigger.new, trigger.oldmap);
    }
    
    if (PAD.CanTrigger('AP37_Opportunity'))
    {
        AP37_Opportunity.ChangeContratRT(trigger.new, trigger.oldmap);
    }
    if(PAD.CanTrigger('AP60_ContactShare'))
    {
        AP60_ContactShare.ShareContract(null,Trigger.new);
    }  
    //mettre à jour le champ Ventes_Additionnelles__c de l'objectif du propriértaire de l'opportunité 
    if(PAD.CanTrigger('AP87_Objectif'))
    {
        AP87_Objectif.OppsEditAuCoursAnnee(trigger.new,trigger.oldmap);
    }
    //mettre à jour le champ VentesAdditionnellesDeLAgence__c de l'objectif de l'agence de l'opportunité 
    if(PAD.CanTrigger('AP90_Objectif'))
    {
        AP90_Objectif.OppsEditAuCoursAnnee(trigger.new,trigger.oldmap);
    }
    
    //10/06/2022: Commented by Jimmy, Moved to Flow Flow_01_MAJ_Doc_Date_Prise_Effet
    /*if(PAD.CanTrigger('AP93_DocumentDateEffet') && OpportunityDatePriseEffet != null && OpportunityDatePriseEffet.size()>0)
    {
        AP93_DocumentDateEffet.MAJDoc(OpportunityDatePriseEffet);        
    }*/
    
    if(PAD.CanTrigger('AP85_Objectif'))
    {
        if(!Validation_Opportunity.hasAlreadyDone2())
        {
            AP85_Objectif.OppEditAuCoursAnnee(trigger.new,trigger.oldmap);
            AP85_Objectif.OppPerdueAuCoursAnnee(trigger.new,trigger.oldmap);
        }
        Validation_Opportunity.setAlreadyDone2();
    }
    if(PAD.CanTrigger('AP92_Objectif'))
    {
        if(!Validation_Opportunity.hasAlreadyDone3())
        {
            AP92_Objectif.OppEditAuCoursAnnee(trigger.new,trigger.oldmap);
            AP92_Objectif.OppPerdueAuCoursAnnee(trigger.new,trigger.oldmap);
        }
        Validation_Opportunity.setAlreadyDone3();
    }
    if(PAD.CanTrigger('AP96_Objectif'))
    {
        if(!Validation_Opportunity.hasAlreadyDone4())
        {
            AP96_Objectif.OppEditAuCoursAnnee(trigger.new,trigger.oldmap);
            AP96_Objectif.OppPerdueAuCoursAnnee(trigger.new,trigger.oldmap);
        }
        Validation_Opportunity.setAlreadyDone4();
    }
    
    //21/06/2022: Added by Jimmy add DAC in Teams (US C360-749)
    if(PAD.CanTrigger('AP112_Opportunity'))
    {
        AP112_Opportunity.addDACinTeams(trigger.newmap,trigger.oldmap);
    }
    
    
}