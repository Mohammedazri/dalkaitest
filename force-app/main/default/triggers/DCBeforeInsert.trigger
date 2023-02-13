trigger DCBeforeInsert on Document_Contractuel__c (before insert) {
    if(PAD.CanTrigger('AP52_DocumentContractuel') ){
        AP52_DocumentContractuel.checkPreviousDcContrat(trigger.new,'insert');
        //AP52_DocumentContractuel.checkPreviousDcContratDuree(trigger.new,'insert'); 
        AP52_DocumentContractuel.checkDcContratDuree(trigger.new);
    }
        if(PAD.CanTrigger('AP01_DocumentContractuel'))
     {
         AP01_DocumentContractuel.setStatusFalse(trigger.new);
     }
}