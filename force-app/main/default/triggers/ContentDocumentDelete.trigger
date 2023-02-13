/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: Apex trigger ContentDocumentDelete
Test Class:  AP01_ContentDocumentLink_test
History
<Date> 		<Authors Name> 		<Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger ContentDocumentDelete on ContentDocument (before delete) {

    if(PAD.CanTrigger('AP01_ContentDocumentLink') ){
        //modify the value of revueOffre__c on opprtunity
        AP01_ContentDocumentLink.verificationRevueOffreDelete(trigger.old);
        //modify the value of compterendu__c on event 
        //AP01_ContentDocumentLink.modificationCompteRenduDelete(trigger.old);
        }
    
    /*Avoid deleting content document if it is related to a contrat that has statut fermé*/
    if(PAD.CanTrigger('AP77_ContratFerme') )
    {
        AP77_ContratFerme.checkIfCanDeleteFile(Trigger.oldMap);
    }
    
    if(PAD.CanTrigger('AP100_IdScan'))
    {
		AP100_IdScan.deleteContentDocument(Trigger.oldMap);        
    }
    
}