/**
* @author: Rita Bejjani -EI Technologies
* @date: 28/08/2019
* @Description: after update DC checks the type and updates the contrat associated when necessary
* @test Class: AP52_DocumentContractuel_Test
* @coverage: 100%
*/
trigger DCAfterUpdate on Document_Contractuel__c (after update) {
    if(PAD.CanTrigger('AP52_DocumentContractuel') ){ 
        AP52_DocumentContractuel.checkContratAvenant(trigger.new,trigger.oldMap,'update');
    }
    
    if(PAD.CanTrigger('AP102_UpdateCommentaireDocCont'))
    {
        List<Document_Contractuel__c> AP102Docs = new List<Document_Contractuel__c>();
        
        for(Document_Contractuel__c doc : trigger.new){
            if((doc.commentaire__c != trigger.oldMap.get(doc.Id).commentaire__c || doc.NiveauDeConfidentialite__c != trigger.oldMap.get(doc.Id).NiveauDeConfidentialite__c)
                && doc.NumeroPiece__c != null){
                AP102Docs.add(doc);
            }
        }
        
        if(System.IsBatch() == false && System.isFuture() == false && AP102Docs.size() > 0)
        { 
        	AP102_UpdateCommentaireDocCont.updateCommentaire(JSON.serialize(AP102Docs));
        }
    }
}