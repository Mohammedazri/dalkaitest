/**
* This class contains unit tests for validating the behavior of Apex classes AP05_Opportunity
*/
@isTest
public class AP05_Opportunity_Test {
    
    
    
    @isTest
    static void tesAP05_Opportunity(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        User u3 = testUtils.CreateUser('standt38', 'user31111@testorg3.com', 'Testing2', p.Id, 'user3rrr@testorg3.com');
        insert new List<User>{u1,u2,u3};
            
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        myaccount.OwnerId = u2.Id;
        insert myaccount;   
        String teamMemberRole = 'Account Manager';
        AccountTeamMember myaccoutMember= New AccountTeamMember(AccountId = myaccount.id, TeamMemberRole = teamMemberRole, UserId= u1.Id);
        
        //Remove account owner from account teams
        List<AccountTeamMember> ownerMember = [SELECT Id,UserId
                                               FROM AccountTeamMember
                                               WHERE UserId =:u2.Id And AccountId=:myaccount.id];
        if(ownerMember != null && ownerMember.size()>0){
            delete ownerMember;
        }
        
        insert myaccoutMember;
        Test.startTest();
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp.AccountId=myaccount.Id;
        myOpp.closeDate=Date.today();
        myOpp.Amount=3;
        insert myOpp;
        myOpp.OwnerId=u3.Id;
        update myOpp;
        /* myOpp.OwnerId=u1.Id;
update myOpp;*/
        
        Test.stopTest();
    }
}