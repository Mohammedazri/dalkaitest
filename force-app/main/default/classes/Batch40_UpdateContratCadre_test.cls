/**
* @author: Jacques Akiki -EI Technologies
* @date: 10/04/2019
* @description: test class for Batch40_UpdateContratCadre
*/

@istest
public class Batch40_UpdateContratCadre_test 
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
            cont.RecordTypeId = Schema.SObjectType.Contrat__c.getRecordTypeInfosByName().get('Contrat Cadre').getRecordTypeId();
            insert cont;
            
            test.startTest();
            Id batchJobId  = Database.executeBatch(new Batch40_UpdateContratCadre());
            test.stopTest();
        }
    }
}