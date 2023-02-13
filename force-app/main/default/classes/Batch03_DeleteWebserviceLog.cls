global class Batch03_DeleteWebserviceLog implements Database.Batchable<sObject> {

    	public string query = 'select Id from WebServiceLog__c where createddate < LAST_N_DAYS:180';
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        system.debug('##query' + query);
        system.debug('##queryResult' + Database.getQueryLocator(query));
         return Database.getQueryLocator(query);
    }
                          
    global void execute(Database.BatchableContext BC, List<WebserviceLog__c> LogsForDelete)
    
    {	system.debug('##LogsForDelete' + LogsForDelete);
		delete LogsForDelete;
    }
    global void finish(Database.BatchableContext BC) {
        
    }
}