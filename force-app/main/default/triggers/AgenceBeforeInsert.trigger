trigger AgenceBeforeInsert on Agence__c (before insert) {
    if(PAD.CanTrigger('AP64_CodeAgenceRegion')){
        AP64_CodeAgenceRegion.checkCode(Trigger.new);
    }
}