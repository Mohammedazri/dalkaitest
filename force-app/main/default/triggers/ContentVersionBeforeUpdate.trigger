trigger ContentVersionBeforeUpdate on ContentVersion (before update) {
if(PAD.CanTrigger('AP77_ContratFerme') )
    {
        AP77_ContratFerme.checkIfCanEditFileNote(trigger.newmap);
    }
}