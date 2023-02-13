trigger CDLAfterInsert on ContentDocumentLink (after insert) {

    if(PAD.CanTrigger('AP51_ContentDocumentLink') )
    {
    	AP51_ContentDocumentLink.checkFileConditions(trigger.new);
    }
}