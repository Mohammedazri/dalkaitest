/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Apex controller for the lightning component LC37_CreerOpportuniteFille  responsible of creating "des opportunités filles"
related to the "Opportunité mère" that created the contrat upon Realisation
Test Class: AP37_Opportunity_test
-------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP37_Opportunity_test {
    static testMethod void testCreationOpp() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c=true;
        insert u2;
        User u3 = testUtils.CreateUser('standt28', 'user31111@testorg2.com', 'Testing2', p.Id, 'user3rrr@testorg2.com');
        u3.BypassValidationRules__c=true;
        insert u3;
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = 'OUV';
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        insert myaccount;
        
        System.runAs(u2) {
            
           opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.Amount=3;
            myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp1.Type_pers__c=Label.Renouvellement;
            insert myOpp1;
            Contrat__c cont = new Contrat__c(name='Contrat');
            //cont.represente_par__c = null;
            cont.NomPartenaire__c = myaccount.Id; 
            cont.OpportuniteCommerciale__c = myOpp1.id;
            cont.EstContratcadre__c = true;
            insert cont;
            test.startTest();
            myOpp1.EstOpportuniteMere__c = true;
            myOpp1.Annee_de_signature__c = '2020';
            myOpp1.OwnerId = u3.id; 
            update myOpp1;
            test.stopTest();
        }
    }
}