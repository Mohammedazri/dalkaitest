/**
* This class contains unit tests for validating the behavior of Apex classes LC10_Hierarchy_Controller
*/
@isTest
public class LC10_Hierarchy_Controller_Test {
    
    @isTest
    static void HierarchyTest() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt28', 'user21111@testorg1.com', 'Testing', p.Id, 'user1rrr@testorg1.com');
        u1.BypassValidationRules__c = true;
        insert u1;
        
        System.runAs(u1) 
        {
            Test.startTest();         
            account myaccount=testUtils.createAccount('testAccount', 'quatar', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            insert myaccount;
            
            List<Account> listAcc = new List <Account>();
            account myaccount2=testUtils.createAccount('testAccount2', 'Lebanon', 'Privé');
            myaccount2.BillingCity='testcity2';
            myaccount2.SIRET__c='39435043';
            myaccount2.BillingPostalCode='22224';
            myaccount2.ParentId=myaccount.Id;
            insert myaccount2;
            
            account myaccount3=testUtils.createAccount('testAccount3', 'Egypt', 'Privé');
            myaccount3.BillingCity=null;
            myaccount3.SIRET__c='39435044';
            myaccount3.BillingPostalCode='22225';
            myaccount3.BillingStreet = null;
            myaccount3.BillingCity = 'test1';
            myaccount3.ParentId=myaccount2.Id;
            insert myaccount3;
            
            account myaccount4=testUtils.createAccount('testAccount4', 'France', 'Privé');
            myaccount4.BillingCity='testcity4';
            myaccount4.BillingPostalCode=null;
            myaccount4.BillingStreet = 'testing';
            myaccount4.BillingCity = 'test2';
            myaccount4.SIRET__c='39435045';
            myaccount4.ParentId=myaccount3.Id;
            insert myaccount4;
            
            LC10_Hierarchy_Controller.getAccounts(myaccount4.Id);
            Test.stopTest();
        }
    }
}