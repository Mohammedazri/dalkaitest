trigger ContratBeforeInsert on Contrat__c (before insert) {
    PAD.PAD_BypassTrigger+=';AP45_Account;';
    
    //07/12/2022 Commented PAD.CanTrigger by jimmy since the classes are no longer called
    //In case the classes were reused, make sure to readd them to the bypass trigger field
    /* 
    if(PAD.CanTrigger('AP04_Contrat')){
        //AP04_Contrat.UpdateContratFields(trigger.new);
    }
    */
    
    if(PAD.CanTrigger('AP58_UOPilote')){
        AP58_UOPilote.insertUOPilote(trigger.new);
    }
    
    if(PAD.CanTrigger('AP68_UpdateTypeContrat')){
        AP68_UpdateTypeContrat.UpdateContrats(trigger.new);
    }
    
    if(PAD.CanTrigger('AP115_ContratDateProchEch')){
        AP115_ContratDateProchEch.calculDateProchaineEcheance(trigger.new, null);
    }
}