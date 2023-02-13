@isTest
public class AP68_UpdateTypeContrat_TEST {
    @isTest
    static void TestUpdateContratFilsDate() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        u1.BypassValidationRules__c=true;
        u1.Bypass_Workflow__c = true;
        u1.BypassProcessBuilder__c = true;
        u1.BypassFilters__c = true;
        insert u1;
        
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        system.runAs(u1){
            
            Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.Amount=3;
            myOpp1.statut__c ='En cours';
            insert myOpp1;
            
            Contrat__c cont1 = new Contrat__c(name='Contrat1');
            cont1.NomPartenaire__c = myaccount.Id; 
            cont1.OpportuniteCommerciale__c = myOpp1.id;
            cont1.EstContratcadre__c = true;
            cont1.OwnerId = u1.id;
            cont1.EstContratcadre__c = true;
            insert cont1;
            
            Contrat__c cont = new Contrat__c(name='Contrat');
            cont.NomPartenaire__c = myaccount.Id; 
            cont.OpportuniteCommerciale__c = myOpp1.id;
            cont.EstContratcadre__c = true;
            cont.OwnerId = u1.id;
            cont.EstContratcadre__c = false;
            cont.ContratCadre__c = cont1.id;
            insert cont;
            
            Contrat__c cont2 = new Contrat__c(name='Contrat');
            cont2.NomPartenaire__c = myaccount.Id; 
            cont2.OpportuniteCommerciale__c = myOpp1.id;
            cont2.EstContratcadre__c = true;
            cont2.OwnerId = u1.id;
            cont2.EstContratcadre__c = false;
            insert cont2;
        }
    }
}