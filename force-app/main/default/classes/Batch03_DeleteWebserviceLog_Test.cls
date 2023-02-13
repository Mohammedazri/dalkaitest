@isTest
public class Batch03_DeleteWebserviceLog_Test {
    
    static testMethod void testBatch_DeleteLog(){
        WebserviceLog__c WebLogOld = new WebserviceLog__c();
        insert WebLogOld;
        Test.setCreatedDate(WebLogOld.Id, DateTime.newInstance(2017,2,15));
        system.debug('old before test'+[select id from WebserviceLog__c where createddate< LAST_N_DAYS:31]);
        Test.startTest();
       Batch03_DeleteWebserviceLog testBatch=new Batch03_DeleteWebserviceLog();
        SCHD04_Batch03_DeleteWebserviceLog sh1 = new SCHD04_Batch03_DeleteWebserviceLog();
        String sch = '0 0 1 1 * ?'; 
        DataBase.executeBatch(testBatch);
        system.schedule('Delete Logs', sch, sh1);
        Batch03_DeleteWebserviceLog myBatch= new Batch03_DeleteWebserviceLog();
        ID batchprocessid = Database.executeBatch(myBatch,50);
        //SCHD04_Batch03_DeleteWebserviceLog.scheduleMe();
        Test.stopTest();
        list<WebserviceLog__c> oldlog=[select id from WebserviceLog__c where createddate< LAST_N_DAYS:31];
        system.assertEquals(oldlog.size(), 0);
    }
}