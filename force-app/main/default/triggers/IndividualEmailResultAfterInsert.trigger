trigger IndividualEmailResultAfterInsert on et4ae5__IndividualEmailResult__c (after insert) {
	
    if(PAD.CanTrigger('AP01_IndividualEmailResult')){
    	AP01_IndividualEmailResult.SetEmailContact(trigger.new);
    }
}