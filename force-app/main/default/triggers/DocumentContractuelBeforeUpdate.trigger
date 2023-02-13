trigger DocumentContractuelBeforeUpdate on Document_Contractuel__c (before update) {
    if(PAD.CanTrigger('AP88_DocUniqueEvolution')){
        List<Document_Contractuel__c> AP88Docs = new List<Document_Contractuel__c>();
        for(Document_Contractuel__c doc : trigger.new){
            if(doc.OpportuniteRattachee__c != trigger.oldMap.get(doc.Id).OpportuniteRattachee__c && doc.NatureDocument__c == 'DOC05'){
                AP88Docs.add(doc);
            }
        }
        AP88_DocUniqueEvolution.docOppExitant(AP88Docs);
    }
    
    
    if(PAD.CanTrigger('AP98_DocumentContractuel')){
        List<Document_Contractuel__c> AP98Docs = new List<Document_Contractuel__c>();
        for(Document_Contractuel__c doc : trigger.new){
            if(doc.NatureDocument__c != trigger.oldMap.get(doc.Id).NatureDocument__c && doc.NatureDocument__c == Label.LC51_LettreResiliation){
                AP98Docs.add(doc);
            }
        }
        if(AP98Docs.size() > 0)
        {
            AP98_DocumentContractuel.interdireLettreResiliation(AP98Docs);   
        }
        
        List<Document_Contractuel__c> AP98InterdireDocs = new List<Document_Contractuel__c>();
        for(Document_Contractuel__c doc : trigger.new){
            if(doc.NatureDocument__c != trigger.oldMap.get(doc.Id).NatureDocument__c){
                AP98InterdireDocs.add(doc);
            }
        }
        if(AP98InterdireDocs.size() > 0)
        {
            AP98_DocumentContractuel.interdireCreationDoc(AP98InterdireDocs);
        }
    }
    
    if(PAD.CanTrigger('AP111_DocumentContractuelUnicity')){
        List<Document_Contractuel__c> AP111Docs = new List<Document_Contractuel__c>();
        for(Document_Contractuel__c doc : trigger.new){
            if(doc.NatureDocument__c != trigger.oldMap.get(doc.Id).NatureDocument__c || doc.OpportuniteRattachee__c != trigger.oldMap.get(doc.Id).OpportuniteRattachee__c){
                AP111Docs.add(doc);
            }
        }
        if(AP111Docs.size() > 0)
        {
            AP111_DocumentContractuelUnicity.checkNatureOpportunityCombination(AP111Docs);
        }
    }
}