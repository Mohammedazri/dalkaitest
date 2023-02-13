/**
* @author: Dona Kfoury
* @date: 22/04/2020
* @description: test class de AP79_Account
*/
@isTest
public class AP79_Account_Test {
    
    @isTest
    static void TestdeleteAccountAsADV() {
        
        Profile p = [SELECT Id FROM Profile WHERE name=:Label.ProfilADV];
        
        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        insert u1;
        system.runAs(u1){
            Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            Test.startTest();
            try{
                delete myaccount;
            }
            catch(Exception e){
                Boolean expectedExceptionThrown =  (e.getMessage().contains(label.AP79_Cas3)) ? true : false; 
                System.AssertEquals(expectedExceptionThrown, true);
            } 
            Test.stopTest();
        }
    }
    
    @isTest
    static void TestdeleteAccountAsAdin() {
        
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        Test.startTest();
        try{
            delete myaccount;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  (e.getMessage().contains(label.AP79_Cas3)) ? true : false; 
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        Test.stopTest();
    }
    
    @isTest
    static void TestdeleteAccountAsAC() {
        
        Profile p = [SELECT Id FROM Profile WHERE name=:Label.ProfileAC];
        
        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        insert u1;
        system.runAs(u1){
            Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            Test.startTest();
            try{
                delete myaccount;
            }
            catch(Exception e){
                Boolean expectedExceptionThrown =  (e.getMessage().contains(label.AP79_Cas4)) ? true : false; 
                System.AssertEquals(expectedExceptionThrown, true);
            } 
            Test.stopTest();
        }
    }
}