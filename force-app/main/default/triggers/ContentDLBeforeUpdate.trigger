trigger ContentDLBeforeUpdate on ContentDocumentLink (before Update) 
{
    if(PAD.CanTrigger('AP77_ContratFerme') )
    {
        AP77_ContratFerme.checkIfCanEditFileNoteLink(trigger.newMap,trigger.OldMap);
    }

}