/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 25/03/2020
* @Coverage: 100%
*/
@isTest
public class AP78_CannotDeleteContrat_TEST {
    @isTest
    static void TestUpdateContratFilsDate() {
        Profile p = [SELECT Id FROM Profile WHERE name=:Label.ProfilADV];
        
        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        u1.BypassValidationRules__c=true;
        u1.Bypass_Workflow__c = true;
        u1.BypassProcessBuilder__c = true;
        u1.BypassFilters__c = true;
        insert u1;
        system.runAs(u1){
            Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            
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
            try{
                delete cont1;
            }
            catch(Exception e){
                system.debug('Exception ' + e);
            }
        }
    }
}