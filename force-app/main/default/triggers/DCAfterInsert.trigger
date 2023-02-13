/**
* @author: Rita Bejjani -EI Technologies
* @date: 28/08/2019
* @Description: after insert DC checks the type and updates the contrat associated when necessary
* @test Class: AP52_DocumentContractuel_Test
* @coverage: 100%
*/

trigger DCAfterInsert on Document_Contractuel__c (after insert) {
    
    if(PAD.CanTrigger('AP52_DocumentContractuel') ){ 
        AP52_DocumentContractuel.checkContratAvenant(trigger.new,null,'insert');
    }
    
}