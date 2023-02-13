/**
* This class contains unit tests for validating the behavior of Apex classes AP08_Opportunity
*/
@isTest
private class AP08_Opportunity_TEST {
    
    static testMethod void myUnitTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        insert new List<User>{u1,u2};
            String teamMemberRole = 'Account Manager';
        AccountTeamMember myaccoutMember= New AccountTeamMember(AccountId = myaccount.id, TeamMemberRole = teamMemberRole, UserId= u1.Id);
        insert myaccoutMember;
        Test.startTest();
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.OpportunityStatusEnCours, 'Etude');
        myOpp.AccountId=myaccount.Id;
        myOpp.closeDate=Date.today();
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c= Label.PV_Opp_Type_Nouveau;
        myOpp.CreerNouveauProjetCommercial__c = true;
        myOpp.Amount=3;
        
        opportunity myOpp2 = testUtils.createOpportunity ('testOpp', date.today(),Label.OpportunityStatusEnCours, 'Piste');
        myOpp2.AccountId=myaccount.Id;
        myOpp2.closeDate=Date.today();
        myOpp2.Amount=3;
        myOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp2.Type_pers__c= Label.PV_Evolution;
        
        insert new list<opportunity>{myOpp, myOpp2};
            
        myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp2.Type_pers__c= Label.PV_Opp_Type_Nouveau;
        myOpp2.CreerNouveauProjetCommercial__c = true;
        myOpp2.name='testOpp2';
        myOpp2.Annee_de_signature__c='2018';
        myOpp2.closeDate=Date.today() + 1;
        myOpp2.OwnerId=u2.Id;
        update myOpp2;
        
        
        
        Test.stopTest();
        
    }
}