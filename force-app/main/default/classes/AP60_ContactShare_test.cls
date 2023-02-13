/**
 * @author: Jacques Akiki -EI Technologies
 * @date: 06/06/2019
 * @description: Test Class for Class AP60_ContactShare
 */
@isTest
public class AP60_ContactShare_test {
    @isTest
    static void TestAP60(){
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId]; // admin profile
        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c  = Label.WS11_OUV;
        insert myaccount; // insert new account

        List<user> listUs = new List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        listUs.add(u1);

        User u2 = testUtils.CreateUser('standt12', 'standardusereee@testorg2.com', 'Testing', p.Id, 'standarduser2rrr@testorg.com'); // new user
        listUs.add(u2);

        insert listUs;

        opportunity myOpp = testUtils.createOpportunity ('testOpp1', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue); // new Opportunity
        myOpp.AccountId = myaccount.Id;
        myOpp.closeDate = Date.today();
        myOpp.Type_pers__c = Label.LC28_TypeNouveau;
        insert myOpp;

        Contrat__c myCont = new Contrat__c(Name = 'TEST', Opportunitecommerciale__c = myOpp.id, NomPartenaire__c = myaccount.id);
        insert myCont;

        myOpp.Contrat_Genere_lookup__c = myCont.id;
        update myOpp;

        test.startTest();
        OpportunityTeamMember OppTeamMember =  new OpportunityTeamMember();
        OppTeamMember.OpportunityId = myOpp.id;
        OppTeamMember.UserId = u2.id;
        OppTeamMember.OpportunityAccessLevel = 'Read';
        insert OppTeamMember;
        myOpp.closeDate = Date.TODAY();
        update myOpp;
        delete OppTeamMember;
        test.stopTest();
    }

    @isTest
    static void TestContratOrigine(){
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId]; // admin profile
        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c  = Label.WS11_OUV;
        insert myaccount; // insert new account

        List<user> listUs = new List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        listUs.add(u1);

        User u2 = testUtils.CreateUser('standt12', 'standardusereee@testorg2.com', 'Testing', p.Id, 'standarduser2rrr@testorg.com'); // new user
        listUs.add(u2);

        insert listUs;

        opportunity myOpp = testUtils.createOpportunity ('testOpp1', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue); // new Opportunity
        myOpp.AccountId = myaccount.Id;
        myOpp.closeDate = Date.today();
        myOpp.Type_pers__c = Label.LC28_TypeNouveau;
        insert myOpp;

        Contrat__c myCont = new Contrat__c(Name = 'TEST', NomPartenaire__c = myaccount.id);
        insert myCont;

        myOpp.ContratOrigine__c = myCont.id;
        update myOpp;

        test.startTest();
        OpportunityTeamMember OppTeamMember =  new OpportunityTeamMember();
        OppTeamMember.OpportunityId = myOpp.id;
        OppTeamMember.UserId = u2.id;
        OppTeamMember.OpportunityAccessLevel = 'Read';
        insert OppTeamMember;
        test.stopTest();
    }
}