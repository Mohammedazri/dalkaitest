trigger DocumentContractuelBeforeInsert on Document_Contractuel__c (before insert) {
    AP01_DocumentContractuel.setStatusFalse(Trigger.new);
    if(PAD.CanTrigger('AP88_DocUniqueEvolution')){
        AP88_DocUniqueEvolution.docOppExitant(trigger.new);
    }
    if(PAD.CanTrigger('AP98_DocumentContractuel')){
        AP98_DocumentContractuel.setNumeroIncrementeDocumentGenere(trigger.new);
        AP98_DocumentContractuel.interdireLettreResiliation(trigger.new);
        AP98_DocumentContractuel.interdireCreationDoc(trigger.new);
    }
    
    if(PAD.CanTrigger('AP111_DocumentContractuelUnicity')){
        AP111_DocumentContractuelUnicity.checkNatureOpportunityCombination(trigger.new);
    }
}