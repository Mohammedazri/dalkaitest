@isTest
public class AP68_UpdateTypeContrat_TEST {
    @isTest
    static void TestUpdateContratReseau() {
        User u1 = testUtilsC360.CreateUser('standt28', 'user21111@testorg2.com', 'Testing', Label.AdminProfileId, 'user2rrr@testorg2.com');

        insert u1;

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        insert new List<Account> {a1, a2};

        Contact cont = testUtilsC360.createContact('TEST', a1.Id, null, true);
        Contact cont1 = testUtilsC360.createContact('TEST1', a2.Id, null, true);

        insert new List<Contact> {cont, cont1};

        system.runAs(u1){

            opportunity myOppReseau = testUtilsC360.createOpportunityMereNouveauReseau('testOppRéseau', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id);
            insert myOppReseau;

            opportunity myOppReseauFille = testUtilsC360.createOpportunityFilleNouveauReseau('testOppRéseauFille', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id, myOppReseau.Id);
            insert myOppReseauFille;

            testUtilsC360.completeeFDS(new set<Id> {myOppReseau.Id, myOppReseauFille.Id});

            OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(myOppReseau.Id, cont.Id);
            OpportuniteContact__c oppCont2 = testUtilsC360.createOpportunityContrat(myOppReseauFille.Id, cont.Id);
            insert new List<OpportuniteContact__c> {oppCont1, oppCont2};

            test.startTest();

            myOppReseau = testUtilsC360.realiseOpportunity(myOppReseau);
            Update myOppReseau;

            myOppReseauFille = testUtilsC360.realiseOpportunity(myOppReseauFille);
            Update myOppReseauFille;
            test.stopTest();

        }
    }
    @isTest
    static void TestUpdateContratSPU() {
        User u1 = testUtilsC360.CreateUser('standt28', 'user21111@testorg2.com', 'Testing', Label.AdminProfileId, 'user2rrr@testorg2.com');

        insert u1;

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        insert new List<Account> {a1, a2};

        Contact cont = testUtilsC360.createContact('TEST', a1.Id, null, true);
        Contact cont1 = testUtilsC360.createContact('TEST1', a2.Id, null, true);

        insert new List<Contact> {cont, cont1};

        system.runAs(u1){

            opportunity myOppSPU = testUtilsC360.createOpportunityMereNouveauSPU('testOppSPU', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id);
            insert myOppSPU;

            opportunity myOppFilleSPU = testUtilsC360.createOpportunityFilleNouveauSPU('testOppSPUFille', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id, myOppSPU.Id);

            insert myOppFilleSPU;

            testUtilsC360.completeeFDS(new set<Id> {myOppSPU.Id, myOppFilleSPU.Id});

            OpportuniteContact__c oppCont3 = testUtilsC360.createOpportunityContrat(myOppSPU.Id, cont.Id);
            OpportuniteContact__c oppCont4 = testUtilsC360.createOpportunityContrat(myOppFilleSPU.Id, cont.Id);
            insert new List<OpportuniteContact__c> {oppCont3, oppCont4};

            test.startTest();

            myOppSPU = testUtilsC360.realiseOpportunity(myOppSPU);
            Update myOppSPU;

            myOppFilleSPU = testUtilsC360.realiseOpportunity(myOppFilleSPU);
            Update myOppFilleSPU;
            test.stopTest();

        }
    }
    @isTest
    static void TestUpdateContratIndep() {
        User u1 = testUtilsC360.CreateUser('standt28', 'user21111@testorg2.com', 'Testing', Label.AdminProfileId, 'user2rrr@testorg2.com');

        insert u1;

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        insert new List<Account> {a1, a2};

        Contact cont = testUtilsC360.createContact('TEST', a1.Id, null, true);
        Contact cont1 = testUtilsC360.createContact('TEST1', a2.Id, null, true);

        insert new List<Contact> {cont, cont1};

        system.runAs(u1){

            opportunity myOpp = testUtilsC360.createOpportunityIndepNouveau('testOpp1', String.valueOf(System.Today().year()), Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
            insert myOpp;

            testUtilsC360.completeeFDS(new set<Id> {myOpp.Id});

            OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(myOpp.Id, cont.Id);
            insert oppCont1;

            test.startTest();

            myOpp = testUtilsC360.realiseOpportunity(myOpp);
            Update myOpp;
            test.stopTest();

        }
    }
}