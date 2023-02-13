trigger AgenceBeforeUpdate on Agence__c (before update) {
    if(PAD.CanTrigger('AP64_CodeAgenceRegion')){
        AP64_CodeAgenceRegion.checkCode(Trigger.new);
    }
}