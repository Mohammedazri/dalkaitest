/**
* @author Rita Bejjani -EI Technologies
* @date 19/09/2019
* @description Test Class for Batch Batch58_UpdateContCadre
*/

@isTest
public class Batch58_UpdateContCadre_test {

     @isTest
    static void testUpdateContCadre()
    {
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create user and add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        //run test as user 
        System.runAs(u2) 
        {
            account a1 = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.Segment_client__c = 'Collectivités';
            insert a1;
            
            //create and insert Contrat
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            c1.EstContratcadre__c = true;
            c1.NatureContratCadre__c = '';
            
            Test.startTest();
            insert c1;
            
            Id BatchId = Database.executeBatch(new Batch58_UpdateContCadre('limit 1'));
            Test.stopTest();
        }
    }
}