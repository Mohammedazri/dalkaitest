trigger WebserviceLogAfterInsert on WebserviceLog__c (after insert) {
	AP61_WebserviceLogs.handleList(trigger.new);
}