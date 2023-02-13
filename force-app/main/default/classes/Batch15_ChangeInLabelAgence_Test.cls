/*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Mattar 
Company: EI-Technologies
Description: This class contains unit tests for validating the behavior of Apex classes Batch15_ChangeInLabelAgence
Test Class: Batch15_ChangeInLabelAgence_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
30/08/2018   Rita Mattar      Creation of the test class
--------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class Batch15_ChangeInLabelAgence_Test {
    @isTest
    
    static void testUser(){
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Nom_agence__c = 'AGENCE COMMERCIALE MARCHE SANTE ET GRAND PROJETS';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        u2.Bypass_Triggers__c='AP32_ChangeInLabelAgence;AP09_User';
        insert u2;
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.OwnerId = u2.id;
            insert a1;
            
            Agence__c ag = new Agence__c();
            ag.Name = 'AGENCE COMMERCIALE MARCHE SANTE ET GRAND PROJETS';
            insert ag;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.Type_pers__c='Nouveau';
            myOpp.tech_Budget__c = null;
            myOpp.Annee_de_signature__c='2017';
            myOpp.OwnerId = u2.id;
            insert myOpp; 
            Opportunity opp = [select id,OwnerId,Owner.Nom_agence__c,Tech_Libelle_agence__c,libelle_agence__c from Opportunity where id =:myOpp.id];

            Test.startTest(); 
            Batch15_ChangeInLabelAgence obj = new Batch15_ChangeInLabelAgence();
            DataBase.executeBatch(obj);
            Test.stopTest();
        }
    }
}