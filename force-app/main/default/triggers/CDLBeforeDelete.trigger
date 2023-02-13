/** 
* @author Jacques Akiki
* @date 06/03/2020 
* @description Trigger when deleting content document Link
* @Test Class AP77_ContratFerme_Test
*/
trigger CDLBeforeDelete on ContentDocumentLink (before delete) {
    /*Avoid deleting content document Link if it related to a contrat that has statut fermé*/
    if(PAD.CanTrigger('AP77_ContratFerme') )
    {
        AP77_ContratFerme.checkIfCanCreateFile(trigger.oldMap);
    }

    if(PAD.CanTrigger('AP101_DocumentContractuel'))
    {
        AP101_DocumentContractuel.removeScanLink(trigger.old);
    }
}