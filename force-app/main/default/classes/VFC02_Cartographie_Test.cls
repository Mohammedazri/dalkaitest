@isTest
public class VFC02_Cartographie_Test {
    static testMethod void testController() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt28', 'user21111@testorg1.com', 'Testing', p.Id, 'user1rrr@testorg1.com');
        u1.BypassValidationRules__c = true;
        insert u1;
        
        System.runAs(u1) 
        {
            Test.startTest(); 
            account myaccount= testUtils.createAccount('testAccount1', 'quatar', 'Privé');
            myaccount.BillingCity='test';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            account myaccount2= testUtils.createAccountShipping('testAccount2', 'Lebanon', 'Privé');
            myaccount2.BillingCity='test33';
            myaccount2.BillingPostalCode='222';
            myaccount2.SIRET__c='391141';
            myaccount2.BillingStreet='test';
            myaccount2.BillingState='test';
            myaccount2.BillingCountry='test';
            myaccount2.ShippingState='bbb';
            myaccount2.ShippingCity='testcity';
            myaccount2.ShippingPostalCode='2222';
            myaccount2.ShippingStreet='aaa';
            myaccount2.ShippingState='bbb';
            myaccount2.ParentId=myaccount.Id;
            myaccount2.Lieu_immatriculation_legale__c = 'test';
            myaccount2.Type_immatriculation__c  = 'RCS';
            insert myaccount2;
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            System.currentPageReference().getParameters().put('id', myaccount2.Id);
            VFC02_Cartographie controller = new VFC02_Cartographie();
            controller.Load_Marker_Wrapper();
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            myaccount2.BillingCity=null;
            myaccount2.BillingPostalCode=null;
            myaccount2.BillingStreet=null;
            myaccount2.BillingState=null;
            myaccount2.BillingCountry=null;
            update myaccount2;
            System.currentPageReference().getParameters().put('id', myaccount2.Id);
            VFC02_Cartographie controller1 = new VFC02_Cartographie();
            controller1.Load_Marker_Wrapper();
            Test.stopTest();
        }
    }
}