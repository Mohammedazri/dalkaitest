/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Chadi Geara
Company: EI-Technologies
Description: Responsable for trimming a new opportunity name size up to 74 character, only opp that have a type of Nouveau
Test Class for : AP41_Opportunity 
-------------------------------------------------------------------------------------------------------------------------------------*/

@isTest

public class AP41_Opportunity_test {
    
    static testMethod void testOppNameLength() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassFilters__c = true;
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassValidationRules__c=true;
        u2.Bypass_Triggers__c = 'AP21_Opportunity;';
        PAD.PAD_BypassTrigger+=u2.Bypass_Triggers__c;
        insert u2;
        User u3 = testUtils.CreateUser('standt28', 'user31111@testorg2.com', 'Testing2', p.Id, 'user3rrr@testorg2.com');
        u3.BypassValidationRules__c=true;
        PAD.PAD_BypassTrigger+=u3.Bypass_Triggers__c;
        insert u3;
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        
        System.runAs(u2) {
            test.startTest();
            opportunity myOpp1 = testUtils.createOpportunity ('AABBBCCCDDDEEEFFFAAABBBCCCDDDEEEF', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.Amount=3;
           myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp1.Type_pers__c='Nouveau';
            insert myOpp1;
            
            
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),null, 'Piste');
            myOpp2.AccountId=myaccount.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.Amount=3;
            myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp2.Type_pers__c=Label.Renouvellement;
            insert myOpp2;
            
            
            
            //  test.startTest();
            myOpp1.EstOpportuniteMere__c = true;
            myOpp1.Annee_de_signature__c = '2020';
            myOpp1.Name = 'AAABBBCCCDDDEEEFFFAAABBBCCCDDDEEEFFFAAABBBCCCDDDEEEFFFAAABBBCCCDDDEEEFFFABXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
            myOpp1.OwnerId = u3.id; 
            update myOpp1;
            //test.stopTest();
            test.stopTest();
        }
    }
    
    
}