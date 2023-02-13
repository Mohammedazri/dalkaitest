/**
* @author: Jacques Akiki -EI Technologies
* @date: 23/04/2019
* @description: Test Class for Class AP53_Opportunity
*/
@isTest
public class AP53_Opportunity_test 
{
    @isTest
    static void TestAP53()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId]; // admin profile
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        insert myaccount; // insert new account
        
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        u1.Bypass_Workflow__c = true; 
        u1.BypassProcessBuilder__c = true;
        u1.BypassValidationRules__c = true;
        u1.BypassFilters__c = true;
        insert u1;
        
        System.runAs(u1) {
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste'); // new Opportunity
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.LC35_Renouv;
            myOpp.Statut__c=Label.LC35_Statut;
            insert myOpp;
            Test.startTest();
            myOpp.Statut__c = Label.LC29_newStat; // modify statut
            myOpp.Tech_ResilistionFirst__c = true; // enter condition of LC visibility 
            update myOpp;
            Test.stopTest();
        }
    }
    
}