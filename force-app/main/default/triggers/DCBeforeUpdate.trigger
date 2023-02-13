trigger DCBeforeUpdate on Document_Contractuel__c (before update) {
    if(PAD.CanTrigger('AP52_DocumentContractuel') ){
        AP52_DocumentContractuel.checkPreviousDcContrat(trigger.new,'update'); 
        //AP52_DocumentContractuel.checkPreviousDcContratDuree(trigger.new,'update'); 
    }
        if(PAD.CanTrigger('AP01_DocumentContractuel'))
     {
         AP01_DocumentContractuel.setStatusFalse(trigger.new);
     }
}