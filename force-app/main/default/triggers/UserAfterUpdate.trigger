trigger UserAfterUpdate on User (After Update) {
    
    if(PAD.CanTrigger('AP56_UserAgence') )
    {
        AP56_UserAgence.CheckUserAgence(trigger.new, trigger.oldMap);
    } 
    
    //mettre à jour le champ ContratsActifsEnCours__c de l'objectif de l'utilisatuer modifié 
    if(PAD.CanTrigger('AP85_Objectif'))
    {
       AP85_Objectif.ContratsEditProfilAuCoursAnnee(trigger.new, trigger.oldmap);
    }
    //mettre à jour le champ VentesAdditionnellesDeLAgence__c de l'objectif de l'utilisatuer modifié 
    if(PAD.CanTrigger('AP90_Objectif'))
    {
       AP90_Objectif.EditAgenceOuProfil(trigger.new, trigger.oldmap);
    }
    //mettre à jour le champ ContratsActifsDebutAanneeDeLAgence__c de l'objectif de l'agence de l'utilisateur modifié 
    if(PAD.CanTrigger('AP92_Objectif'))
    {
       AP92_Objectif.EditAgenceOuProfil(trigger.new, trigger.oldmap);
    }
    if(PAD.CanTrigger('AP96_Objectif'))
    {
       AP96_Objectif.EditAgenceOuProfil(trigger.new, trigger.oldmap);
    }
   
}