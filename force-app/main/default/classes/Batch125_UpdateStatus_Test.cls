/**
 * @author Jimmy Khalil - Ei technologies
 * @date 21/03/2022
 * @description test class of Batch125_UpdateStatusPersonAccount
 */
@istest
public class Batch125_UpdateStatus_Test {
    @istest
    static void testUpdateStatusPersonAccountOuv() {
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId];

        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;
        insert u2;

        //  system.runAs(u2){
        account acc = testUtils.createAccountParticulier('testAccount', 'Lebanon', 'Privé');
        acc.StatutPartenaire__c = Label.WS11_OUV;

        insert new List<Account> {acc};

        //}
        Test.startTest();
        id BatchId = Database.executeBatch(new Batch125_UpdateStatusPersonAccount());
        Test.stopTest();

    }
    @istest
    static void testUpdateStatusPersonAccountNull() {
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId];

        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;
        insert u2;

        //  system.runAs(u2){
        Account acc1 = testUtils.createAccountParticulier('testAccount1', 'Lebanon1', 'Privé');
        acc1.StatutPartenaire__c = null;
        insert new List<Account> {acc1};

        //}
        Test.startTest();
        id BatchId = Database.executeBatch(new Batch125_UpdateStatusPersonAccount());
        Test.stopTest();

    }
    @istest
    static void testUpdateStatusPersonAccountFer() {
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId];

        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;
        insert u2;

        //  system.runAs(u2){

        account acc2 = testUtils.createAccountParticulier('testAccount2', 'Lebanon2', 'Privé');
        acc2.StatutPartenaire__c = 'FER';
        insert new List<Account> {acc2};

        //}
        Test.startTest();
        id BatchId = Database.executeBatch(new Batch125_UpdateStatusPersonAccount());
        Test.stopTest();

    }
}