/**
* @author: Jacques Akiki -EI Technologies
* @date: 11/03/2019
* @description: test class for Batch37_UpdateStatutContrat_test 
*/

@istest
public class Batch37_UpdateStatutContrat_test 
{
    @istest
    static void testCreationOpp() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;
        u2.Bypass_Workflow__c = true;
        insert u2;
        System.runAs(u2) {
            Contrat__c cont = new Contrat__c();
            cont.name = 'test';
            cont.Statut__c='Ouverture';
            insert cont;
            
            test.startTest();
            Id batchJobId  = Database.executeBatch(new Batch37_UpdateStatutContrat());
            test.stopTest();
        }
    }
}