/**
* This class contains unit tests for validating the behavior of Apex classes AP21_Opportunity
*/
@isTest
public class AP21_Opportunity_Test {
    @isTest
    static void opportunityProjetCommercial_Test(){
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        System.runAs(u2) {
            opportunity testOpportunity = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            testOpportunity.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            testOpportunity.Type_pers__c=Label.PV_Opp_Type_Nouveau;
            testOpportunity.closeDate=Date.today();
            insert testOpportunity;
            ProjetCommercial__c testProjetCommercial = new ProjetCommercial__c();
            testProjetCommercial.OpportunitCommerciale__c  = testOpportunity.Id;
            insert testProjetCommercial;
            test.startTest();
            testOpportunity.ProjetCommercial__c = testProjetCommercial.Id;
            update testOpportunity;
            test.stopTest();
        }
    }
}