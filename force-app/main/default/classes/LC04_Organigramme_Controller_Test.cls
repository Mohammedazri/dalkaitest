@isTest
public class LC04_Organigramme_Controller_Test {
      
    @isTest
    static void OrganigrammeTest() {
        
        Account acc1 = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        insert acc1;      
        
        contact mycontact1 = testUtils.createContact('test 1', acc1.Id, null);
        mycontact1.Phone ='45245';
        insert mycontact1;
        contact mycontact2 = testUtils.createContact('test 2', acc1.Id, mycontact1.Id);
        mycontact2.Phone ='45245';
        insert mycontact2;
        
        Test.startTest();  
        LC04_Organigramme_Controller.getAccountContacts(acc1.Id);
        LC04_Organigramme_Controller.getCreateWrapperOrganigramme(mycontact1.Id);         
        Test.stopTest();
    }
}