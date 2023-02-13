trigger CaseAfterInsert on Case (after insert) {
if(PAD.CanTrigger('AP101_Case'))
    {
        AP101_Case.notifyUser(trigger.newMap); 
    }
}