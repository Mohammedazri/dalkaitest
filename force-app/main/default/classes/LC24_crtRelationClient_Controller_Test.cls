@isTest
public class LC24_crtRelationClient_Controller_Test {
    static testMethod void LC24Test() {
        Test.startTest(); 
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        insert myaccount;
        contact mycontact = testUtils.createContact('test 1', myaccount.Id, null);
        insert mycontact;
        Contact_User__c myContactUser= new Contact_User__c();
        myContactUser.Contact_Client__c=mycontact.Id;
        insert myContactUser;
        String newRCString = JSON.serialize(myContactUser);
        LC24_crteRelationClientInt_Controller.SaveRC(newRCString);
        LC24_crteRelationClientInt_Controller.SaveRC(JSON.serialize(new Contact_User__c()));
        LC24_crteRelationClientInt_Controller.DeleteRelationInterne(myContactUser.Id);
        LC24_crteRelationClientInt_Controller.DeleteRelationInterne(myContactUser.Id+'1');
        Test.stopTest();
    }
}