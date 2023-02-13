/** 
* @author Charbel Khoury Hanna
* @date 15/02/2021 
* @description test Class AP94_Contrat
*/
@isTest
public class AP94_Contrat_Test {
    
    @isTest
    static void TestUpdateContratActif() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c=true;
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassFilters__c = true;
        insert u2;
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        
        
        System.runAs(u2) {
            Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.Amount=3;
            //myOpp1.Type_pers__c='Renouvellement';
            insert myOpp1;
            Contrat__c cont = new Contrat__c(name='Contrat');
            cont.NomPartenaire__c = myaccount.Id; 
            cont.OpportuniteCommerciale__c = myOpp1.id;
            cont.EstContratcadre__c = true;
            Test.startTest();
            insert cont;
            cont.Statut__c=label.ContratFerme;
            update cont;
            delete cont;
            Test.stopTest();
        }
    }
}