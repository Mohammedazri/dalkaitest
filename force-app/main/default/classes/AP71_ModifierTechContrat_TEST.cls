@isTest
public class AP71_ModifierTechContrat_TEST {
    @isTest
    static void TestUpdateContratFilsDate() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        u1.BypassValidationRules__c=true;
        u1.Bypass_Workflow__c = true;
        u1.BypassProcessBuilder__c = true;
        insert u1;
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c=true;
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassValidationRules__c = true;
        u2.BypassFilters__c = true;
        insert u2;
        
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        system.runAs(u2){
            Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.Amount=3;
            myOpp1.statut__c ='En cours';
            insert myOpp1;
            
            Contrat__c cont = new Contrat__c(name='Contrat');
            cont.NomPartenaire__c = myaccount.Id; 
            cont.OpportuniteCommerciale__c = myOpp1.id;
            cont.EstContratcadre__c = true;
            cont.OwnerId = u1.id;
            insert cont;
            
            cont.OwnerId=u2.id;
            update cont;
        }
    }    
}