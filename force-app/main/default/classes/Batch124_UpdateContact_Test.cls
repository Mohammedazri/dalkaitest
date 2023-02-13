/**
 * @author Jimmy Khalil - Ei technologies
 * @date 21/03/2022
 * @description test class of Batch124_UpdateContactNoPersonAccount
 */
@istest
public class Batch124_UpdateContact_Test {
    @istest
    static void testUpdateContactNoPersonAccount() {
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId];

        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;
        insert u2;

        system.runAs(u2){
            account acc = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            acc.StatutPartenaire__c = Label.WS11_OUV;
            insert acc;

            contact con = testUtils.CreateContact('test Contact 1', acc.id, null);
            con.Phone = '45245';
            con.Statut__c = null;
            insert con;

        }
        Test.startTest();
        id BatchId = Database.executeBatch(new Batch124_UpdateContactNoPersonAccount());
        Test.stopTest();

    }
}