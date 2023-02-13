trigger ContentDocumentLinkInsert on ContentDocumentLink (after insert) {
    //07/12/2022 Commented PAD.CanTrigger by jimmy since the classes are no longer called
    //In case the classes were reused, make sure to readd them to the bypass trigger field
    /*if(PAD.CanTrigger('AP01_ContentDocumentLink') ){
        //AP01_ContentDocumentLink.verificationRevueOffre(trigger.new);
       }*/
    /* if(PAD.CanTrigger('AP02_ContentDocumentLink') ){
         //AP02_ContentDocumentLink.LinkEvent(trigger.new);
       }*/
    /*if(PAD.CanTrigger('AP03_ContentDocumentLink') ){
        AP03_ContentDocumentLink.updateTechContrat(trigger.new);
       }*/

    if(PAD.CanTrigger('AP100_IdScan')) {

        AP100_IdScan.updateIdScan(trigger.new);
    }

    if(PAD.CanTrigger('AP101_DocumentContractuel')) {

        AP101_DocumentContractuel.updateScan(JSON.serialize(trigger.new));
    }

}