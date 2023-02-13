/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: Test class of LC40_OppContratAccount.
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class LC40_OppContratAccount_test {
    static testMethod void testCreationOpp() {
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.StatutPartenaire__c=Label.WS11_OUV;
        insert myaccount;
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.OpportunityStagePiste);
        insert myOpp;
        Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=myaccount.id,OpportuniteCommerciale__c=myOpp.id);
        insert(mycontrat);
        test.startTest();
        LC40_OppContratAccount.getOppCont(myaccount.id);
        test.stopTest();
    }
}