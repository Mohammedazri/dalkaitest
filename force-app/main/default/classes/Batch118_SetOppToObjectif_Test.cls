/**
* @author Jimmy Khalil -EI Technologies
* @date 18/08/2020
* @description Test Class for Batch118_SetOppToObjectif
*/ 
@isTest
public class Batch118_SetOppToObjectif_Test {
    @isTest
    static void testObjectif() 
    {
        Profile p = [SELECT Id FROM Profile WHERE name='Commercial'];
        User u1 = testUtils.CreateUser('testUsr', 'userTest@testorg-dalkia.com', 'Testing2', p.Id, 'userTest@testorg-dalkia.com');
        insert u1;
        
        
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.Annee_de_signature__c='2021';
        myOpp.OwnerId = u1.id;
        insert myOpp;
        
        Objectif__c myObj = testUtils.createObjectif('Test',Schema.SObjectType.Objectif__c.getRecordTypeInfosByDeveloperName().get('Objectif_Commercial').getRecordTypeId(),'2021');
        myObj.Commercial__c = u1.id;
        insert myObj;
        
        Test.startTest();
        Database.executeBatch(new Batch118_SetOppToObjectif());
        Test.stopTest();
        
    }
}