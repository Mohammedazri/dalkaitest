@isTest
public class AP40_Contrat_Test {
    @isTest
    static void TestUpdateContratFilsDate() {
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
            insert myOpp1;
            Contrat__c cont = new Contrat__c(name='Contrat');
            cont.NomPartenaire__c = myaccount.Id; 
            cont.OpportuniteCommerciale__c = myOpp1.id;
            cont.EstContratcadre__c = true;
            cont.DKCodeSurContrat__c = 'TST4321';
            insert cont;
            Contrat__c contFils = new Contrat__c(name='Contrat');
            contFils.NomPartenaire__c = myaccount.Id; 
            contFils.OpportuniteCommerciale__c = myOpp1.id;
            contFils.ContratCadre__c = cont.id;
            contFils.DKCodeSurContrat__c = 'TST1234';
            contFils.Statut__c = 'OUV';
            insert contFils;
            Test.startTest();
            cont.SocieteVenteLookup__c = myaccount.id;
            update cont;
            contFils = [Select id,name,SocieteVenteLookup__c
                        From Contrat__c
                        Where id=:contFils.id];
            System.assert(contFils.SocieteVenteLookup__c==cont.SocieteVenteLookup__c);
            Test.stopTest();
        }
    }
}