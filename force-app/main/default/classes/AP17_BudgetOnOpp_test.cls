/**
* This class contains unit tests for validating the behavior of Apex classes AP17_BudgetOnOpp
History
<Date>      <Authors Name>   <Brief Description of Change>
30/08/2018	Jacques Akiki		Change in the test class conditions to increase coverage.
*/
@isTest 
public class AP17_BudgetOnOpp_test {
    @isTest
    static void testBudget(){
        
        //get current year (annee N)
        Integer currentYear = System.Today().year();
        string currentYearString = String.valueOf(currentYear);
        string previousYearString = String.valueOf(currentYear-1);
        string nextYearString = String.valueOf(currentYear+1);
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassFilters__c = true;
        u2.Bypass_Triggers__c ='AP09_Opportunity;AP05_Opportunity;AP14_OppRollUpSummaryUtility';
        insert u2;
        PAD.PAD_BypassTrigger += 'AP09_Opportunity;AP05_Opportunity;AP14_OppRollUpSummaryUtility';
        
        System.runAs(u2) 
        {
            
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            insert a1;
            
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            BudgetCourant__c bugetCourant = new BudgetCourant__c(name = 'BudgetCourant', annee__c=currentYearString);
            insert bugetCourant;
            Test.startTest(); 
            Budget__c myBudget = testUtils.CreateBudget ('testBudget', previousYearString, c1.Id);
            insert myBudget;
            
            
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.tech_Budget__c = null;
            myOpp.Annee_de_signature__c=previousYearString;
            
            
            insert myOpp;
            
            myBudget.AnneeBudget__c=currentYearString;
            myBudget.CABudgetP1__c=1;
            update myBudget;
            
            myOpp.Annee_de_signature__c=currentYearString;
            myOpp.Name='testOpp1';
            update myOpp;
            
            myBudget.AnneeBudget__c=nextYearString;
            update myBudget;
           
            Test.stopTest();
        }
    }
}