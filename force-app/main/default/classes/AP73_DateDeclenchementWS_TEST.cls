/**
*@author:Alain Ghoussoub
*@date 16/1/2019
*@description Classe de test de AP73_DateDeclenchementWS
*/
@isTest
public class AP73_DateDeclenchementWS_TEST {
    @isTest
    static void TestUpdateContratFilsDate() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        u1.BypassValidationRules__c=true;
        u1.Bypass_Workflow__c = true;
        u1.BypassProcessBuilder__c = true;
        insert u1;
        
        system.runAs(u1){
            Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            
            myaccount.BillingCity = 'test1';
            update myaccount;
            
            myaccount.idexterne__c = true;
            update myaccount;
        }
        
    }
}