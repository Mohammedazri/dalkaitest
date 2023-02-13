trigger ContratAfterDelete on Contrat__c (after delete) {
    
   // if(PAD.CanTrigger('AP19_LookUpContratAccount'))
       // AP19_LookUpContratAccount.UpdateRollupFields(trigger.old, true);
    
    //mettre à jour le champ ContratsActifsRattaches__c du partenaire parent en cas ou ce partenaire possède 
    //au minima un contrat actif
    if(PAD.CanTrigger('AP82_Contrat'))
    {
       AP82_Contrat.ContratInsertDelete(trigger.old);
    }
    
    //mettre à jour le champ ContratsActifsEnCours__c de l'objectif du propriértaire du contrat 
    if(PAD.CanTrigger('AP85_Objectif'))
    {
       AP85_Objectif.ContratsCreeOuDeleteAuCoursAnnee(trigger.old);
    }
    //mettre à jour le champ ContratsActifsDebutAanneeDeLAgence__c de l'objectif de l'agence du contrat 
    if(PAD.CanTrigger('AP92_Objectif'))
    {
       AP92_Objectif.ContratCreeOuDeleteAuCoursAnnee(trigger.old);
    }
    
    //Calculer le volume d'activité CA Contrats / hors fils
    if(PAD.CanTrigger('AP94_Contrat'))
    {
       AP94_Contrat.majCAPartenaire(null, trigger.old);
    }
    if(PAD.CanTrigger('AP96_Contrat'))
    {
       AP96_Objectif.ContratCreeOuDeleteAuCoursAnnee(trigger.old);
    }
}