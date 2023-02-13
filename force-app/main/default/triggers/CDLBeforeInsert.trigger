trigger CDLBeforeInsert on ContentDocumentLink (before insert) {
    if(PAD.CanTrigger('AP51_ContentDocumentLink') ){
        AP51_ContentDocumentLink.checkPreviousCDL(trigger.new); 
    }
    
}