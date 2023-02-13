/*--------------------------------------------------------------------------------------------------------------------------
   Author: Jimmy Khalil
   Company: EI-Technologies
   Description: Test Class for AP104_Opportunity
   Coverage: 100%
   --------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP104_Opportunity_Test {
    @isTest
    static void setNatureOffreTestReseaux() {
        list<Account> listAcc = new List<Account>();

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        listAcc.add(a1);

        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        listAcc.add(a2);
        insert listAcc;

        Contact cont = testUtilsC360.createContact('TEST', a1.Id, null, true);
        Contact cont1 = testUtilsC360.createContact('TEST1', a1.Id, null, true);

        insert new List<Contact> {cont, cont1};

        User u1 = testUtilsC360.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', Label.AdminProfileId, 'standarduser1rrr@testorg.com');

        Insert u1;

        System.runAs(u1) {

            opportunity myOpp = testUtilsC360.createOpportunityMereNouveauReseau('testOppRéseau', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id);
            insert myOpp;

            opportunity myOpp2 = testUtilsC360.createOpportunityFilleNouveauReseau('testOppRéseauFille', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id, myOpp.Id);
            insert myOpp2;

            Test.startTest();

            testUtilsC360.completeeFDS(new set<Id> {myOpp.Id, myOpp2.Id});

            OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(myOpp.Id, cont.Id);
            OpportuniteContact__c oppCont2 = testUtilsC360.createOpportunityContrat(myOpp2.Id, cont.Id);
            insert new List<OpportuniteContact__c> {oppCont1, oppCont2};

            myOpp = testUtilsC360.realiseOpportunity(myOpp);
            myOpp2 = testUtilsC360.realiseOpportunity(myOpp2);
            Update new List<Opportunity> {myOpp, myOpp2};

            List<Contrat__c> contratGeneree =  testUtilsC360.getContratGeneree(new set<Id> {myOpp.Id, myOpp2.Id});

            String contratCadreId;
            String contratFilsId;
            for(Contrat__c mycontrat : contratGeneree) {
                if(mycontrat.OpportuniteCommerciale__c == myOpp.Id) {
                    contratCadreId = mycontrat.Id;
                } else {
                    contratFilsId = mycontrat.Id;
                }
            }

            opportunity myOppMereRenouv = testUtilsC360.createOpportunityMereRenouvReseau('testOppRéseauRenouv', '2022', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue, a1.Id, a2.Id, u1.Id, contratCadreId);
            Insert myOppMereRenouv;

            opportunity myOppFilleRenouv = testUtilsC360.createOpportunityFilleRenouvReseau('testOppRéseauRenouvFille', '2022', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue, a1.Id, a2.Id, u1.Id, contratFilsId, myOppMereRenouv.Id);
            Insert myOppFilleRenouv;

            Test.stopTest();
        }
    }
    @isTest
    static void setNatureOffreTestSPU() {
        list<Account> listAcc = new List<Account>();

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        listAcc.add(a1);

        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        listAcc.add(a2);
        insert listAcc;

        Contact cont = testUtilsC360.createContact('TEST', a1.Id, null, true);
        Contact cont1 = testUtilsC360.createContact('TEST1', a1.Id, null, true);

        insert new List<Contact> {cont, cont1};

        User u1 = testUtilsC360.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', Label.AdminProfileId, 'standarduser1rrr@testorg.com');

        Insert u1;

        System.runAs(u1) {

            opportunity myOpp = testUtilsC360.createOpportunityMereNouveauSPU('testOppRéseau', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id);
            insert myOpp;

            opportunity myOpp2 = testUtilsC360.createOpportunityFilleNouveauSPU('testOppRéseauFille', '2022', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, u1.Id, myOpp.Id);
            insert myOpp2;

            Test.startTest();

            testUtilsC360.completeeFDS(new set<Id> {myOpp.Id, myOpp2.Id});

            OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(myOpp.Id, cont.Id);
            OpportuniteContact__c oppCont2 = testUtilsC360.createOpportunityContrat(myOpp2.Id, cont.Id);
            insert new List<OpportuniteContact__c> {oppCont1, oppCont2};

            myOpp = testUtilsC360.realiseOpportunity(myOpp);
            myOpp2 = testUtilsC360.realiseOpportunity(myOpp2);
            Update new List<Opportunity> {myOpp, myOpp2};

            List<Contrat__c> contratGeneree =  testUtilsC360.getContratGeneree(new set<Id> {myOpp.Id, myOpp2.Id});

            String contratCadreId;
            String contratFilsId;
            for(Contrat__c mycontrat : contratGeneree) {
                if(mycontrat.OpportuniteCommerciale__c == myOpp.Id) {
                    contratCadreId = mycontrat.Id;
                } else {
                    contratFilsId = mycontrat.Id;
                }
            }

            opportunity myOppMereRenouv = testUtilsC360.createOpportunityMereRenouvSPU('testOppRéseauRenouv', '2022', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue, a1.Id, a2.Id, u1.Id, contratCadreId);
            Insert myOppMereRenouv;

            opportunity myOppFilleRenouv = testUtilsC360.createOpportunityFilleRenouvSPU('testOppRéseauRenouvFille', '2022', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue, a1.Id, a2.Id, u1.Id, contratFilsId, myOppMereRenouv.Id);
            Insert myOppFilleRenouv;

            Test.stopTest();
        }
    }
}