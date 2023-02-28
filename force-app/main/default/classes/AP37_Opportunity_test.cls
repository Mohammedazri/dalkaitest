/*-------------------------------------------------------------------------------------------------------------------------------------
   Author: Jacques Akiki
   Company: EI-Technologies
   Description: Apex controller for the lightning component LC37_CreerOpportuniteFille  responsible of creating "des opportunités filles"
   related to the "Opportunité mère" that created the contrat upon Realisation
   Test Class: AP37_Opportunity_test
   -------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP37_Opportunity_test {
    static testMethod void testCreationOpp() {

        User u1 = testUtilsC360.CreateUser('standt28', 'user21111@testorg2.com', 'Testing', Label.AdminProfileId, 'user2rrr@testorg2.com');

        insert u1;

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        insert new List<Account> {a1, a2};

        Contact cont = testUtilsC360.createContact('TEST', a1.Id, null, true);
        Contact cont1 = testUtilsC360.createContact('TEST1', a2.Id, null, true);

        insert new List<Contact> {cont, cont1};

        System.runAs(u1) {

            opportunity myOpp = testUtilsC360.createOpportunityMereNouveauReseau('testOppRéseau', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id);
            opportunity myOppSPU = testUtilsC360.createOpportunityMereNouveauSPU('testOppRéseau', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id);
            insert new List<opportunity> {myOpp, myOppSPU};

            opportunity myOpp2 = testUtilsC360.createOpportunityFilleNouveauReseau('testOppRéseauFille', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id, myOpp.Id);
            insert myOpp2;

            testUtilsC360.completeeFDS(new set<Id> {myOpp.Id, myOpp2.Id});

            OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(myOpp.Id, cont.Id);
            OpportuniteContact__c oppCont2 = testUtilsC360.createOpportunityContrat(myOpp2.Id, cont.Id);
            insert new List<OpportuniteContact__c> {oppCont1, oppCont2};

            test.startTest();
            myOpp = testUtilsC360.realiseOpportunity(myOpp);
            myOpp2 = testUtilsC360.realiseOpportunity(myOpp2);
            Update new List<Opportunity> {myOpp, myOpp2};

            //retour en arriere
            myOpp2.StageName = Label.OpportunityStagePiste;
            myOpp2.Statut__c = Label.OpportunityStatusEnCours;
            update myOpp2;

            //Changer l'opp mere de reseau a SPU
            myOpp2.OpportuniteMere__c = null;
            myOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp2.EstOpportuniteMere__c = true;
            myOpp2.NatureOpportunitMere__c = Label.AP104_NatureMereSPU;
            myOpp2.natureOffre__c = Label.AP104_NaturePointUnique;
            myOpp2.engagementEnergetique__c = Label.AP104_EngagementSansTravaux;
            myOpp2.paiementDesEnergies__c = Label.AP104_PaiementDalkia;
            myOpp2.niveauDeMaintenance__c = Label.AP104_NiveauGER;
            myOpp2.Type_de_PdA_reseaux__c = '';
            update myOpp2;
            test.stopTest();
        }
    }
}