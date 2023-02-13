/*------------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Test Class of Batch Batch22_UpdateRDVRealise    
History
<Date>      <Authors Name>   <Brief Description of Change>
24/10/2018   Jacques Akiki      Creation
------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch22_UpdateRDVRealise_test 
{
    @isTest
    static void  Batch22_UpdateRDVRealiseTest() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Bypass_Workflow__c =true;
        insert u2;
       
        System.runAs(u2) 
        {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            insert myaccount;
            Event Evnt = testUtils.createEvent(myaccount.id,null, Date.today()-1, 'Relationnel client', 5); 
            Evnt.Compterendu__c = 'Hello';
            Evnt.Rdvralise__c = false;
            insert Evnt;
            User u1 = [SELECT id, Bypass_Workflow__c from User where id =: u2.id];
            Event Evn1 = [SELECT id, Rdvralise__c from Event where id =: Evnt.id];
            Test.startTest(); 
            Batch22_UpdateRDVRealise testBatch=new Batch22_UpdateRDVRealise();
            DataBase.executeBatch(testBatch);
            Test.stopTest();
        }
    }
}