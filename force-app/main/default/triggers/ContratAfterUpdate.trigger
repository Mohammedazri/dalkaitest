trigger ContratAfterUpdate on Contrat__c (After update) {
    List<Contrat__c> listContratAP19 = new List<Contrat__c>();
    List<Contrat__c> listAP18Task = new List<Contrat__c>();
    List<Contrat__c> listAP18Event = new List<Contrat__c>();
    List<Contrat__c> listAP31Rollup = new List<Contrat__c>();
    List<Contrat__c> listAP67OppTM = new List<Contrat__c>(); // added by Jacques Akiki
    Set<Id> listAP67OwnerOld = New Set<Id>();
    List<Contrat__c> listContratFilsDate = new List<Contrat__c>();
    
    for(Contrat__c cont: Trigger.new)
    {
        if(
            (
                (cont.DateProchaineEcheance__c != null && cont.DateProchaineEcheance__c.year()>2016) 
                || ( cont.AvenantDateProchaineEcheance__c != null && cont.AvenantDateProchaineEcheance__c.year()>2016)
            )
            &&
            (
                (cont.AvenantDateProchaineEcheance__c != trigger.oldMap.get(cont.Id).AvenantDateProchaineEcheance__c)
                || (cont.DateProchaineEcheance__c != trigger.oldMap.get(cont.Id).DateProchaineEcheance__c)
                || (cont.OwnerID != trigger.oldMap.get(cont.Id).OwnerID)
                || (cont.NomPartenaire__c != trigger.oldMap.get(cont.Id).NomPartenaire__c)
                || (cont.alert6mois__c != trigger.oldMap.get(cont.Id).alert6mois__c)
            )
        )
        {
            listAP18Task.add(cont);
        }
        
        if(
            (
                (cont.DateProchaineEcheance__c > DATE.newInstance(2017,01,01) && cont.DateProchaineEcheance__c != null) 
                || (cont.AvenantDateProchaineEcheance__c > DATE.newInstance(2017,01,01) && cont.AvenantDateProchaineEcheance__c != null)
            )
            &&
            (
                (cont.AvenantDateProchaineEcheance__c != trigger.oldMap.get(cont.Id).AvenantDateProchaineEcheance__c)
                || (cont.DateProchaineEcheance__c != trigger.oldMap.get(cont.Id).DateProchaineEcheance__c)
                || (cont.OwnerID != trigger.oldMap.get(cont.Id).OwnerID)
                || (cont.NomPartenaire__c != trigger.oldMap.get(cont.Id).NomPartenaire__c)
                || (cont.alert6mois__c != trigger.oldMap.get(cont.Id).alert6mois__c)
            )
        )
        {
            listAP18Event.add(cont);
        }
        
        if(cont.WFRelaiCAOffre__c != trigger.oldMap.get(cont.Id).WFRelaiCAOffre__c
           ||cont.WFRelaiCAEcart__c  != trigger.oldMap.get(cont.Id).WFRelaiCAEcart__c
           ||cont.CA_EcartAnnuelContratsActifsRelai__c != trigger.oldMap.get(cont.Id).CA_EcartAnnuelContratsActifsRelai__c
           ||cont.Statut__c         != trigger.oldMap.get(cont.Id).Statut__c
           ||cont.NomPartenaire__c         != trigger.oldMap.get(cont.Id).NomPartenaire__c)
        {
            listContratAP19.add(cont);
        }
        if (cont.statut__c !=trigger.oldMap.get(cont.Id).statut__c || cont.ContratCadre__c != trigger.oldMap.get(cont.Id).ContratCadre__c )
        {  
            if (cont.statut__c== Label.ContratFerme 
                ||trigger.oldMap.get(cont.Id).statut__c== Label.ContratFerme 
                || cont.ContratCadre__c != trigger.oldMap.get(cont.Id).ContratCadre__c)
            {
                listAP31Rollup.add(cont);            
            }
        }
        
        if(cont.OwnerID != trigger.oldMap.get(cont.Id).OwnerID)
        {
            listAP67OppTM.add(cont);
            listAP67OwnerOld.add(trigger.oldMap.get(cont.Id).OwnerID);
        }
        
        if ( (cont.SocieteVenteLookup__c!=trigger.oldMap.get(cont.Id).SocieteVenteLookup__c)) //(cont.Date_de_fermeture__c!=trigger.oldMap.get(cont.Id).Date_de_fermeture__c) ||
        {
            listContratFilsDate.add(cont);
        }
    }
    
    if(PAD.CanTrigger('AP40_Contrat') &&listContratFilsDate.size()>0)
    {
        AP40_Contrat.UpdateContratFils(listContratFilsDate);
    }
    
    if(PAD.CanTrigger('AP18_Contrat') &&listAP18Task.size()>0)
    {
        AP18_Contrat.TaskOnEcheanceChange(listAP18Task);
    }
    if(PAD.CanTrigger('AP18_Contrat') &&listAP18Event.size()>0)
    {
        AP18_Contrat.EventOnEcheanceChange(listAP18Event);
    }
    
    //07/12/2022 Commented PAD.CanTrigger by jimmy since the classes are no longer called
    //In case the classes were reused, make sure to readd them to the bypass trigger field
    /* 
    if(PAD.CanTrigger('AP19_LookUpContratAccount') && listContratAP19.size()>0)
    {
       //AP19_LookUpContratAccount.UpdateRollupFields(listContratAP19, false);
    } 
	*/
    
    if(PAD.CanTrigger('AP67_OpportunityTeamMember') && listAP67OppTM.size()>0)
    {
       AP67_OpportunityTeamMember.checkTeamMemberContratShare(listAP67OppTM,listAP67OwnerOld);
       AP67_OpportunityTeamMember.addOppTeamMember(listAP67OppTM);
    } 
    
    if(PAD.CanTrigger('AP48_ContractCallouts'))
    {
       AP48_ContractCallouts.handleList(trigger.oldmap,trigger.new,'update');
    }
    
    //mettre à jour le champ ContratsActifsRattaches__c du partenaire parent en cas ou ce partenaire possède 
    //au minima un contrat actif
    if(PAD.CanTrigger('AP82_Contrat'))
    {
       AP82_Contrat.ContratUpdate(trigger.new, trigger.oldmap);
    }
    
    //mettre à jour le champ ContratsActifsEnCours__c de l'objectif du propriértaire du contrat 
    if(PAD.CanTrigger('AP85_Objectif'))
    {
       AP85_Objectif.ContratsEditAuCoursAnnee(trigger.new, trigger.oldmap);
    }
    //mettre à jour le champ ContratsActifsDebutAanneeDeLAgence__c de l'objectif de l'agence du contrat 
    if(PAD.CanTrigger('AP92_Objectif'))
    {
       AP92_Objectif.ContratsEditAuCoursAnnee(trigger.new, trigger.oldmap);
    }
     if(PAD.CanTrigger('AP96_Objectif'))
    {
       AP96_Objectif.ContratsEditAuCoursAnnee(trigger.new, trigger.oldmap);
    }
    
    List<Contrat__c> listAP94Contrat = new List<Contrat__c>();
    
    for(Contrat__c cont: Trigger.new)
    {
        if(cont.Statut__c != trigger.oldMap.get(cont.Id).Statut__c
           || cont.TechTotalCABudgetP1P2P3P4__c != trigger.oldMap.get(cont.Id).TechTotalCABudgetP1P2P3P4__c
           || cont.NomPartenaire__c != trigger.oldMap.get(cont.Id).NomPartenaire__c)
        {
            listAP94Contrat.add(cont);
        }
    }
    
    if(PAD.CanTrigger('AP94_Contrat') && listAP94Contrat.size()>0)
    {
        AP94_Contrat.majCAPartenaire(trigger.old,listAP94Contrat);
    }
}