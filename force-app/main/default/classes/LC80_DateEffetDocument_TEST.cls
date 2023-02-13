/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Alain Ghoussoub
Company: EI-Technologies
Description: Test class of LC80_DateEffetDocument_Controller
-------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class LC80_DateEffetDocument_TEST {
    @isTest
    public static void  testController()
    {
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),'En cours', 'Piste');
            myOpp2.AccountId=myaccount.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.Amount=3;
            myOpp2.Type_pers__c = Label.Renouvellement;
            myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp2.EstOpportuniteMere__c = true;
            myOpp2.NatureOpportunitMere__c = 'National';
            insert myOpp2;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.Type_pers__c = Label.Renouvellement;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.OpportuniteMere__c = myOpp2.id;
            myOpp.NatureOpportunitMere__c = 'National';
            insert myOpp;
            
            
            
            LC80_DateEffetDocument_Controller.getCurrentObject(myOpp.id);
            LC80_DateEffetDocument_Controller.updateOpp(myOpp.id);
        }            
        Test.stopTest();
    }
}