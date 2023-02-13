/**
* @author Rita Bejjani -EI Technologies
* @date 05/09/2019
* @description Test Class for Batch Batch52_CreateFDS
*/

@isTest

public class Batch52_CreateFDS_test {
    
	@isTest
    static void testFDSBatch()
    {
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create user and add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        //run test as user 
        System.runAs(u2) 
        {
            //create and insert Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            
            //create and insert Contract
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            
            //create and insert Budget__c
            Budget__c myBudget = testUtils.CreateBudget ('testBudget', '2017', c1.Id);
            insert myBudget;
            
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.StageName = label.LC28_Realise;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c= Label.PV_Evolution;
            myOpp.Annee_de_signature__c='2017';
            myOpp.tech_Budget__c = myBudget.Id; 
            
            Test.startTest();
            insert myOpp;
            
            Id BatchId = Database.executeBatch(new Batch52_CreateFDS('limit 1'));
            Test.stopTest();
        }
    }
}