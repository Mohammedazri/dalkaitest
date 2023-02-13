/**
* @author: Jacques Akiki -EI Technologies
* @date: 23/05/2019
* @description: Test class of LC54_ApprouverFDSCont
*/
@istest
public class LC54_ApprouverFDSCont_test {
    @isTest
    static void testmeth()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId]; // admin profile
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        u1.Bypass_Workflow__c = true; 
        u1.BypassProcessBuilder__c = true;
        u1.BypassFilters__c = true;
        insert u1; // user to perform tests
        
        System.runAs(u1)
        {
            Account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount; // insert new Account
            Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.statut__c =Label.LC29_newStat; //statut en cours 
            myOpp.Type_pers__c = Label.LC35_Renouv; // type renouvellement
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            insert myOpp; // insert new Opportunity
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c myfds= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            /*Fiche_de_synthese__c myfds= new Fiche_de_synthese__c(Name='testfds'); 
            myfds.Opportunit_commerciale__c=myOpp.Id;
            insert myfds;*/// insert new fiche de synthèse
            Approbation__c app = new Approbation__c();
            app.Name = 'test';
            app.tech_Attribue__c = UserInfo.getUserId();
            app.statut__c =Label.LC54_sansRep;
            app.Date_de_soumission__c = DATE.today();
            app.tech_FicheDeSynthese__c = myfds.Id;
            insert app;
            test.startTest();
            LC54_ApprouverFDSCont.getAppData();
            test.stopTest();
        }
    }
}