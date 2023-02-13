trigger WebserviceLogAfterUpdate on WebserviceLog__c (after update) {
    AP61_WebserviceLogs.handleList(trigger.new);
}