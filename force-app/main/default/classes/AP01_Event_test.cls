/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: The aim of this class is to test the functionality of the class AP01 Event
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP01_Event_test {
    
    @isTest
    static void testVerificationRevueOffre()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2){
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.Created_From_Lead__c=true;        
            insert myaccount;
            event testEvent = new event(subject ='test',compteRendu__c = '',DurationInMinutes =360,ActivityDateTime=date.Today(),WhatId = myaccount.Id);
            insert testEvent;
            EntitySubscription EntitySubscription = new EntitySubscription(SubscriberId = u2.id, ParentId = myaccount.Id );
            insert EntitySubscription;
            test.startTest();
            testEvent.compteRendu__c = 'test chatter post to partners and team members';
            update testEvent;
            test.stopTest(); }
    }
}