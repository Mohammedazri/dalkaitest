/*
Author: Johny Kassis
Company: EI-technologies
Description: Test Class used to cover the class AP22_OpportunityTeamMember and the trigger OpportunityTeamAfterInsert
Date: 26/03/2018
*/
@isTest
public class AP22_OpportunityTeamMember_test {
    @isTest
    static  void testCheckOpportunityOwner()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        insert u1;
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c =true;
        insert u2;
        System.runAs(u2) 
        {
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.StageName=Label.LC28_Realise;
            myOpp.Statut__c =Label.OppBeforeUp_gagne;
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.OwnerId=u1.Id;
            insert myOpp; 
            
            OpportunityTeamMember oppteamMember = new OpportunityTeamMember();
            oppteamMember.OpportunityId=myOpp.id;
            oppteamMember.userID=u2.id;
            oppteamMember.TeamMemberRole=Label.AP22_TeamMemberRole;
            try{
                insert oppteamMember;
            }
            catch (Exception e)
            {
                Boolean expectedExceptionThrown =  e.getMessage().contains(Label.AP22_errorMsg) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
            OpportunityTeamMember oppteamMember1 = new OpportunityTeamMember();
            oppteamMember1.OpportunityId=myOpp.id;
            oppteamMember1.userID=u1.id;
            oppteamMember1.TeamMemberRole=Label.AP22_TeamMemberRole;
            insert oppteamMember1;
            
            oppteamMember1.TeamMemberRole='Direction';
            try{
                update oppteamMember1;
            }
            catch (Exception e)
            {
                Boolean expectedExceptionThrown =  e.getMessage().contains(Label.AP22_errorMsg) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
                
            }
        }
    }
}