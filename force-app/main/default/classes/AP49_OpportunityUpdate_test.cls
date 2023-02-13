/**
* @author: Jacques Akiki -EI Technologies
* @date: 03/04/2019
* @description: test class for AP49_OpportunityUpdate 
*/
@istest
public class AP49_OpportunityUpdate_test 
{
    @istest
    static void testCreationOpp() 
    {
         Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;
        u2.Bypass_Workflow__c = true;
        u2.BypassFilters__c = true;
        insert u2;
        System.runAs(u2) {
            
            account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.StatutPartenaire__c = label.WS11_OUV;
            insert myaccount;
            
            opportunity myOpp1 = testUtils.createOpportunity ('testOppMere', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp1.Type_pers__c=Label.PV_Evolution;
            myOpp1.Statut__c = 'En cours';
            myOpp1.EstOpportuniteMere__c = true;
            myOpp1.Tech_CdtRefSelectionnee__c ='Budget';
            insert myOpp1;
             
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=myaccount.Id;
            insert c1;
            
            test.startTest();
            
            Budget__c Budg1 = testUtils.CreateBudget ('testBudget', '2016', c1.Id);
            Budg1.BudgetNP1VentesServices__c=10;
            insert Budg1;
            
            /*Fiche_de_synthese__c fds = testUtils.CreateFDS();
            fds.Opportunit_commerciale__c =myOpp1.id;
            fds.Budget__c= Budg1.id;
            fds.ConditionsDeReference__c='Budget';
            insert fds;*/
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1] ;
            Fiche1.Budget__c= Budg1.id;
            Fiche1.ConditionsDeReference__c='Budget';
            update Fiche1;
            
            Budg1.BudgetNP1VentesServices__c = 20;
            Update Budg1;
            
            test.stopTest();
        }
    }
}