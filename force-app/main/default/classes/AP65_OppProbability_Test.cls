/**
* @author: Jacques Akiki -EI Technologies
* @date: 23/07/2019
* @description: Test class for AP65_OppProbability
*/
@isTest
public class AP65_OppProbability_Test {
    
    @isTest
    static void testAP65()
    {
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create user and	 add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        //run test as user 
        System.runAs(u2) 
        {
            //create and insert Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            insert a1;
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.Annee_de_signature__c='2017';
            myOpp.stageName= Label.PV_Realisation;
            insert myOpp;
        }
    }
}