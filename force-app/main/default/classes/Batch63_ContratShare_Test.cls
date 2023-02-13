@isTest
public class Batch63_ContratShare_Test {
    @isTest
    static void testBatch63()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId]; // admin profile
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c  ='OUV';
        insert myaccount; // insert new account
        
        List<user> listUs = new List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        u1.Bypass_Workflow__c = true; 
        u1.BypassProcessBuilder__c = true;
        u1.BypassValidationRules__c = true;
        u1.Bypass_Triggers__c='AP60_ContactShare';
        listUs.add(u1);
        
        User u2 = testUtils.CreateUser('standt12', 'standardusereee@testorg2.com', 'Testing', p.Id, 'standarduser2rrr@testorg.com'); // new user
        u2.Bypass_Workflow__c = true; 
        u2.BypassProcessBuilder__c = true;
        u2.BypassValidationRules__c = true;
        listUs.add(u2);
        
        insert listUs;
        
        System.runAs(u1) {
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste'); // new Opportunity
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Type_pers__c='Nouveau';
            insert myOpp;
            
            Contrat__c  myCont = new Contrat__c(Name='TEST', Opportunitecommerciale__c= myOpp.id,NomPartenaire__c = myaccount.id);
            insert myCont;
            
            OpportunityTeamMember OppTeamMember =  new OpportunityTeamMember();
            OppTeamMember.OpportunityId = myOpp.id;
            OppTeamMember.UserId = u2.id;
            OppTeamMember.OpportunityAccessLevel = 'Read';
            insert OppTeamMember;
            test.startTest();
            myOpp.Contrat_Genere_lookup__c = myCont.id;
            update myOpp;
            list<Contrat__share> listconts = [SELECT id FROM Contrat__share where UserOrGroupId=:u2.id];
            delete listconts;
            Id BatchId = Database.executeBatch(new Batch63_ContratShare());
            test.stopTest();
            
        }
    }
}