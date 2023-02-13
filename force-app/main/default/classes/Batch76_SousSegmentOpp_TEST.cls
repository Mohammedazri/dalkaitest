@isTest
public class Batch76_SousSegmentOpp_TEST {
    @isTest
    static void  Batch76_SousSegmentOpp_TEST() 
    {
        // query the profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        // create the user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.BypassValidationRules__c =true;//add bypass
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.Bypass_Triggers__c = 'AP08_Opportunity;AP14_OppRollUpSummaryUtility;AP07_Opportunity;AP17_BudgetOnOpp;AP09_Opportunity;AP24_OpportunityFDS;';
        u2.Bypass_Triggers__c += 'AP57_Affaire;AP25_OpportunityAvntRealise;AP05_Opportunity;AP15_Budget;AP08_Opportunity;AP38_OpportunityContratCadre';
        PAD.PAD_BypassTrigger+=u2.Bypass_Triggers__c;
        u2.BypassFilters__c = true;
        insert u2;// insert the user
        
        // run test as the created user 
        System.runAs(u2) 
        {
            // Create an Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            insert a1;
            
            
            opportunity myOpp1 = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp1.accountId=a1.Id;
            myOpp1.Statut__c = 'En cours';
            myOpp1.Segment_client__c = 'Santé';
            myOpp1.SousSegmentMarche__c = 'Santé privée	';
            insert myOpp1;
            
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            c1.OpportuniteCommerciale__c=myOpp1.id;
            insert c1;
            
            
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp2.accountId=a1.Id;
            myOpp2.Statut__c = 'En cours';
            myOpp2.ContratOrigine__c = c1.id;
            insert myOpp2;
            
            Test.startTest(); 
            Id BatchId = Database.executeBatch(new Batch76_SousSegmentOpp());
            Test.stopTest();

        }
        
    }
}