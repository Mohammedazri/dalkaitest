global with sharing class chartjsController {
    @AuraEnabled
    global static string getChartjsData(string dataProviderName, string recordId){
        iChartjsDataProvider dp;
        dp = (iChartjsDataProvider)type.forName(dataProviderName).newInstance();
        return dp.getChartjsData(recordId);
    }
}