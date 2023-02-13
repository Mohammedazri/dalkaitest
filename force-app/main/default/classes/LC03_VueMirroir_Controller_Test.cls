/**
* This class contains unit tests for validating the behavior of Apex classes LC03_VueMirroir_Controller
*/
@isTest
public class LC03_VueMirroir_Controller_Test {
    
    @isTest
    static void VueMirroirTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        System.runAs(u2) 
        {
            Test.startTest(); 
            List<document>mydocumentList= new list<document>();
            folder myfolder= [select id from folder where name = 'Satisfaction_Client'];
            document myDocument= testUtils.createDocument('Six sur dix','Six_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument);     
            document myDocument2= testUtils.createDocument('Dix sur dix','Dix_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument2);
            document myDocument3= testUtils.createDocument('Un sur dix','Un_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument3);
            document myDocument4= testUtils.createDocument('Deux sur dix','Deux_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument4);
            document myDocument5= testUtils.createDocument('Trois sur dix','Trois_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument5);
            document myDocument6= testUtils.createDocument('Quatre sur dix','Quatre_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument6);
            document myDocument7= testUtils.createDocument('Cinq sur dix','Cinq_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument7);
            document myDocument8= testUtils.createDocument('Sept sur dix','Sept_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument8);
            document myDocument9= testUtils.createDocument('Huit sur dix','Huit_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument9);
            document myDocument10= testUtils.createDocument('Neuf sur dix','Neuf_sur_dix2',myfolder.Id  );
            mydocumentList.add(myDocument10);
            
            insert mydocumentList;
            system.debug('#############'+ myDocument.FolderId);
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            insert myaccount;
            system.debug('BillingCountry ' + myaccount.BillingCountry );
            system.debug('BillingAddress ' + myaccount.BillingAddress );
            system.debug('myaccount'+myaccount);
            contact mycontact = testUtils.createContact('test 1', myaccount.Id, null);
            insert mycontact;
            List<contact> myContactList= new List<contact>();
            contact mycontact2 = testUtils.createContact('test 7', myaccount.Id, mycontact.Id);
            myContactList.add(mycontact2);
            contact mycontact3 = testUtils.createContact('test 2', myaccount.Id, mycontact.Id);
            myContactList.add(mycontact3);
            contact mycontact4 = testUtils.createContact('test 3', myaccount.Id, mycontact.Id);
            myContactList.add(mycontact4);
            insert myContactList ;
            Event myEvent= testUtils.createEvent(myaccount.Id,mycontact.Id, Date.today()-1,'Satisfaction client', 3);
            insert myEvent;
            system.debug('mycontact '+mycontact );
            LC03_VueMirroir_Controller.getAccountContacts(myaccount.Id, 't');
            LC03_VueMirroir_Controller.getCreateWrapperVueMirror(mycontact.Id, 't');         
            Test.stopTest();
        }
    }
}