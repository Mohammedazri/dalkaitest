/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: test class for Batch04_UpdateParentOpportunity
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch04_UpdateParentOpportunity_Test {
    
    @isTest 
    static void testBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        System.runAs(u2) 
            
        { 
            Test.startTest();
            Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp2.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp2.Type_pers__c=Label.Renouvellement;
            insert myOpp2;
            
            ProjetCommercial__c myProjet = new ProjetCommercial__c();
            myProjet.OpportunitCommerciale__c = myOpp2.id;
            insert myProjet;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.ProjetCommercial__c = myProjet.id;
            myOpp.CloseDate = Date.newInstance(2017, 12, 31);
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Opp_Type_Nouveau;
            myOpp.accountId=myaccount.Id;
            
            
            List<Opportunity> listOpp = new List<Opportunity>();
            listOpp.add(myOpp);
            insert listOpp;
            system.assert(listOpp.size() == 1, true);
            
            Batch04_UpdateParentOpportunity testBatch=new Batch04_UpdateParentOpportunity();
            Database.executebatch(testBatch);
            Test.stopTest();
        }
    }
}