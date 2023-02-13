/**
* @author Dona Kfoury
* @date 30/03/2020
* @description Test Class for Batch batch59_OppPda
*/
@isTest
public class batch59_OppPda_Test {
	 @isTest
    static void testUpdatePda()
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
            //a1.Segment_client__c = 'Collectivités';
            insert a1;
            
            //create and insert Contrat
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.EstOpportuniteMere__c = true;
            myOpp.NatureOpportunitMere__c = Label.batch59_Reseau;
            
            insert myOpp;
            
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),null, 'Réalisation');
            myOpp2.accountId=a1.Id;
            myOpp2.OpportuniteMere__c=myOpp.Id;
            myOpp2.Annee_de_signature__c='2019';
            myOpp2.stagename=label.batch59_Realisation;
            myOpp2.Type_de_PdA_reseaux__c = null;
            insert myOpp2;
            
            Test.startTest();
            Id BatchId = Database.executeBatch(new batch59_OppPda(''));
            Test.stopTest();
        }
    }
}