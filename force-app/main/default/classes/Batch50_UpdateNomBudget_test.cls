/**
* @author Jacques Akiki -EI Technologies
* @date 12/07/2019
* @description Test Class for Batch Batch50_UpdateNomBudget
*/

@isTest

public class Batch50_UpdateNomBudget_test {
    
    @isTest
    static void testBudgetBatch()
    {
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create user and	 add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.Bypass_Triggers__c='AP05_Opportunity;AP14_OppRollUpSummaryUtility';
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
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.Annee_de_signature__c='2017';
            insert myOpp;
            
            //create and insert Budget__c
            Budget__c myBudget = testUtils.CreateBudget ('testBudget', '2016', c1.Id);
            insert myBudget;
            
            
            //start test
            Test.startTest();
            c1.BudgetReference__c = null;
            update c1;
            
            Id BatchId = Database.executeBatch(new Batch50_UpdateNomBudget(''));
            Test.stopTest();
        }
    }
}