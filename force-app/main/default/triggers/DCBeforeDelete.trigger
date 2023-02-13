trigger DCBeforeDelete on Document_Contractuel__c (before delete) 
{
    /*call method to check if document contractuel can be deleted*/
    if(PAD.CanTrigger('AP76_DocumentContractuel'))
    {
        AP76_DocumentContractuel.preventDelete(trigger.old);
    }
    //cal method to check if parent contract is closed
    if(PAD.CanTrigger('AP77_ContratFerme')){
        AP77_ContratFerme.checkIfCanDeleteDocumentContractuel(Trigger.oldmap);
    }
}