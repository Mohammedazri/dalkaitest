trigger ContratAfterInsert on Contrat__c (After insert) {
    PAD.PAD_BypassTrigger+=';AP45_Account;';
    List<Contrat__c> listAP18 = new List<Contrat__c>();
    for(Contrat__c cont: Trigger.new)
    {
        if((cont.DateProchaineEcheance__c != null && cont.DateProchaineEcheance__c.year()>2016) 
           || ( cont.AvenantDateProchaineEcheance__c != null && cont.AvenantDateProchaineEcheance__c.year()>2016))
        {
            listAP18.add(cont);
        }
        
    }
    
    if(PAD.CanTrigger('AP18_Contrat') && listAP18.size()>0)
    {
        AP18_Contrat.TaskOnEcheanceChange(listAP18); 
        AP18_Contrat.EventOnEcheanceChange(listAP18);
    }
    
    //07/12/2022 Commented PAD.CanTrigger by jimmy since the classes are no longer called
    //In case the classes were reused, make sure to readd them to the bypass trigger field
    /* 
    if(PAD.CanTrigger('AP19_LookUpContratAccount')){
        //AP19_LookUpContratAccount.UpdateRollupFields(trigger.new, false);
    }
    */
    
    //mettre à jour le champ ContratsActifsRattaches__c du partenaire parent en cas ou ce partenaire possède 
    //au minima un contrat actif
    if(PAD.CanTrigger('AP82_Contrat'))
    {
        AP82_Contrat.ContratInsertDelete(trigger.new);
    }
    
    //mettre à jour le champ ContratsActifsEnCours__c de l'objectif du propriértaire du contrat 
    if(PAD.CanTrigger('AP85_Objectif'))
    {
        AP85_Objectif.ContratsCreeOuDeleteAuCoursAnnee(trigger.new);
    }
    
    //mettre à jour le champ ContratsActifsDebutAanneeDeLAgence__c de l'objectif de l'agence du contrat 
    if(PAD.CanTrigger('AP92_Objectif'))
    {
        AP92_Objectif.ContratCreeOuDeleteAuCoursAnnee(trigger.new);
    }
    
    if(PAD.CanTrigger('AP96_Objectif'))
    {
        AP96_Objectif.ContratCreeOuDeleteAuCoursAnnee(trigger.new);
    }
    
    //Calculer le volume d'activité CA Contrats / hors fils
    if(PAD.CanTrigger('AP94_Contrat'))
    {
        AP94_Contrat.majCAPartenaire(null, trigger.new);
    }
}