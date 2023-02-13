/*
 * @Fonctionnalité: test Classe utilisée pour couvrir  lightning LC28_OpportunityPath_controller
 * @Auteur: Johny Kassis
 * @Date: 22/01/2018
 * @Class: LC28_OpportunityPath_controller
 */
@isTest
public class LC28_OpportunityPath_controller_Test {
    testmethod static void  testController(){

        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        String teamMemberRole = 'Account Manager';

        Contrat__c cont = new Contrat__c(name = 'TEST');
        cont.NomPartenaire__c = myaccount.id;
        cont.TypeReconduction__c = 'RNUL';
        cont.DatePriseEffet__c = System.Today() -2;
        cont.DureeInitialeContrat__c = 1;
        cont.NombreReconductionsPassees__c = 1;
        cont.DureeReconduction__c = 1;
        cont.NombreReconductionsAutorisees__c = 1;
        cont.DureeProlongationTotale__c = 1;
        insert cont;

        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.AccountId = myaccount.Id;
        myOpp.closeDate = Date.today();
        myOpp.Amount = 3;
        myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        myOpp.ContratOrigine__c = cont.id;
        insert myOpp;

        Test.startTest();
        CS01_CloseOpportunityStage__c stageCS = new CS01_CloseOpportunityStage__c(Stage__c = Label.PV_Realisation, name = 'test');
        insert stageCS;

        CS01_CloseOpportunityStat__c statCS = new CS01_CloseOpportunityStat__c(Statut__c = myOpp.Type_pers__c, name = 'test', Stage__c = Label.PV_Realisation);
        insert statCS;
        LC28_OpportunityPath_controller.setfields(myOpp.id, 'En cours', 'Piste', myOpp.ContratOrigine__r, 'Prix');
        String stage = LC28_OpportunityPath_controller.getCurrentStage(myOpp.id);
        LC28_OpportunityPath_controller.getContratdOrigine(myOpp.id);
        list<LC28_OpportunityPath_controller.WRP02_MenuPickList> listWRP02 = LC28_OpportunityPath_controller.GetMotifsDeFermeture('perdue');
        list<LC28_OpportunityPath_controller.WRP02_MenuPickList> listWRP02Cond = LC28_OpportunityPath_controller.LoadDependantConditionValues('Refus reconduction tacite');
        List<String> lStage = LC28_OpportunityPath_controller.getselectOptions(myOpp.id);
        List<String> lStat = LC28_OpportunityPath_controller.getStatus(myOpp.id);
        LC28_OpportunityPath_controller.QueryingOpportunityFields(myOpp.id);
        boolean testbool = LC28_OpportunityPath_controller.getUserInfo();
        myOpp.EstOpportuniteMere__c = true;
        myOpp.NatureOpportunitMere__c = Label.AP16_National;
        myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        myOpp.Type_pers__c = Label.LC35_Renouv;
        system.debug('#myOpp' + myOpp);
        update myOpp;
        Contrat__c cont2 = new Contrat__c(name = 'TEST2');
        cont2.DatePriseEffet__c = date.today();
        cont2.NomPartenaire__c = myaccount.id;
        cont2.ContratCadre__c = cont.Id;
        cont2.TypeReconduction__c = 'RNUL';
        cont2.DatePriseEffet__c = System.Today() -2;
        cont2.DureeInitialeContrat__c = 1;
        cont2.NombreReconductionsPassees__c = 1;
        cont2.DureeReconduction__c = 1;
        cont2.NombreReconductionsAutorisees__c = 1;
        cont2.DureeProlongationTotale__c = 1;
        insert cont2;
        opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today() + 1, 'En cours', 'Piste');
        myOpp2.AccountId = myaccount.Id;
        myOpp2.closeDate = Date.today();
        myOpp2.Amount = 3;
        myOpp2.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp2.Type_pers__c = Label.LC35_Renouv;
        myOpp2.ContratOrigine__c = cont2.id;
        insert myOpp2;
        Contrat__c cont3 = new Contrat__c(name = 'TEST3');
        cont3.NomPartenaire__c = myaccount.id;
        cont3.ContratCadre__c = cont.Id;
        cont3.OpportuniteCommerciale__c = myOpp.Id;
        cont3.DatePriseEffet__c = date.today();
        cont3.DatePriseEffet__c = System.Today() -2;
        cont3.DureeInitialeContrat__c = 1;
        cont3.NombreReconductionsPassees__c = 1;
        cont3.DureeReconduction__c = 1;
        cont3.NombreReconductionsAutorisees__c = 1;
        cont3.DureeProlongationTotale__c = 1;
        insert cont3;
        LC28_OpportunityPath_controller.checkIfCanRealiseOpp(myOpp.id);
        LC28_OpportunityPath_controller.getIfShowHelpText(myOpp.id);

        LC28_OpportunityPath_controller.getMotifPerteValues();
        LC28_OpportunityPath_controller.getSelectedMotifPerte(myOpp.id);
        LC28_OpportunityPath_controller.getContratdOrigine(myOpp.id);

        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.TitreDocument__c = 'test1';
        DC1.NumeroPiece__c = '';
        DC1.NatureDocument__c = 'DOC01';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = cont2.Id;
        DC1.DatePriseEffet__c = system.today() - 2;
        DC1.DateSignature__c = date.today();
        DC1.NiveauDeConfidentialite__c = 'DOC_C02';

        insert DC1;

        LC28_OpportunityPath_controller.checkIfCanRealiseOpp(myOpp2.id);

        Test.stopTest();

    }
    testmethod static void  testControllerEvol(){

        List<Account> listAcc = new list<Account>();
        account a1 = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity = 'test';
        a1.BillingPostalCode = '111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        listAcc.add(a1);

        account a2 = testUtils.createAccount('testAccount-SDV', 'Lebanon', 'Privé');
        a2.Lieu_immatriculation_legale__c = 'test';
        a2.Immatriculation_Legale__c = 'test3';
        a2.Type_immatriculation__c = 'RCS';
        a2.StatutPartenaire__c = Label.WS11_OUV;
        a2.BillingCity = 'test';
        a2.BillingPostalCode = '112';
        a2.Code_NACE__c = '222';
        a2.SIRET__c = '255236';
        a2.Siege_social_partenaire__c = true;
        a2.Categorie_partenaire__c = 'DLK';
        a2.DKCodeSurPartenaire__c = '112233';
        listAcc.add(a2);
        insert listAcc;

        Contrat__c c1 = new Contrat__c();
        c1.NomPartenaire__c = a1.Id;
        c1.Name = 'testtingg ';
        c1.DureeInitialeContrat__c = 1;
        c1.DatePriseEffet__c = date.today();
        c1.TypeReconduction__c = 'RNUL';
        c1.DatePriseEffet__c = System.Today() -2;
        c1.DureeInitialeContrat__c = 1;
        c1.NombreReconductionsPassees__c = 1;
        c1.DureeReconduction__c = 1;
        c1.NombreReconductionsAutorisees__c = 1;
        c1.DureeProlongationTotale__c = 1;
        insert c1;

        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId = a1.Id;
        myOpp.ContratOrigine__c = c1.id;
        myOpp.Annee_de_signature__c = Label.LC30_TEST_Anne;
        myOpp.Societevente__c = a2.id;
        myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;
        myOpp.DureeProlongationSupp__c = 5;
        myOpp.Type_pers__c = Label.Evolution;
        insert myOpp;

        Test.startTest();
        CS01_CloseOpportunityStage__c stageCS = new CS01_CloseOpportunityStage__c(Stage__c = 'test', name = 'test');
        insert stageCS;

        CS01_CloseOpportunityStat__c statCS = new CS01_CloseOpportunityStat__c(Statut__c = 'test', name = 'test');

        insert statCS;

        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        /*Fiche_de_synthese__c fds =  testUtils.createFDS();
           fds.Opportunit_commerciale__c = myOpp.Id;
           insert fds;*/

        myOpp.PuissanceChaud__c = 123;
        update myOpp;

        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.TitreDocument__c = 'test1';
        DC1.NumeroPiece__c = '123';
        DC1.NatureDocument__c = 'DOC01';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = c1.Id;
        DC1.DatePriseEffet__c = system.today() - 2;
        DC1.DateSignature__c = date.today();
        DC1.NiveauDeConfidentialite__c = 'DOC_C02';
        insert DC1;

        Document_Contractuel__c DC2 = new Document_Contractuel__c();
        DC2.TitreDocument__c = 'test2';
        DC2.NumeroPiece__c = '124';
        DC2.NatureDocument__c = 'DOC05';
        DC2.StatutDocument__c = 'ACT';
        DC2.Contrat__c = c1.Id;
        DC2.DatePriseEffet__c = date.today();
        DC2.DateSignature__c = date.today();
        DC2.OpportuniteRattachee__c = myOpp.Id;
        DC2.MajConditionsDuree__c = true;
        DC2.NiveauDeConfidentialite__c = 'DOC_C02';
        insert DC2;

        Test.stopTest();
        LC28_OpportunityPath_controller.setfields(myOpp.id, Label.OppBeforeUp_gagne, Label.PV_Realisation, null, 'Prix');

    }
    testmethod static void  testControllerCatch(){

        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        String teamMemberRole = 'Account Manager';

        Contrat__c cont = new Contrat__c(name = 'TEST');
        cont.NomPartenaire__c = myaccount.id;
        cont.TypeReconduction__c = 'RNUL';
        cont.DatePriseEffet__c = System.Today() -2;
        cont.DureeInitialeContrat__c = 1;
        cont.NombreReconductionsPassees__c = 1;
        cont.DureeReconduction__c = 1;
        cont.NombreReconductionsAutorisees__c = 1;
        cont.DureeProlongationTotale__c = 1;
        insert cont;

        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.AccountId = myaccount.Id;
        myOpp.closeDate = Date.today();
        myOpp.Amount = 3;
        myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        myOpp.ContratOrigine__c = cont.id;
        insert myOpp;

        Test.startTest();
        CS01_CloseOpportunityStage__c stageCS = new CS01_CloseOpportunityStage__c(Stage__c = 'test', name = 'test');
        insert stageCS;

        CS01_CloseOpportunityStat__c statCS = new CS01_CloseOpportunityStat__c(Statut__c = 'test', name = 'test');
        insert statCS;
        LC28_OpportunityPath_controller.setfields(myOpp.id, 'Actif', 'Piste', cont, 'Prix');

    }
    testmethod static void  testControllerRealise(){

        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        String teamMemberRole = 'Account Manager';

        Contrat__c cont = new Contrat__c(name = 'TEST');
        cont.NomPartenaire__c = myaccount.id;
        cont.TypeReconduction__c = 'RNUL';
        cont.DatePriseEffet__c = System.Today() -2;
        cont.DureeInitialeContrat__c = 1;
        cont.NombreReconductionsPassees__c = 1;
        cont.DureeReconduction__c = 1;
        cont.NombreReconductionsAutorisees__c = 1;
        cont.DureeProlongationTotale__c = 1;
        insert cont;

        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.AccountId = myaccount.Id;
        myOpp.closeDate = Date.today();
        myOpp.Amount = 3;
        myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c = Label.LC35_Renouv;
        myOpp.ContratOrigine__c = cont.id;
        insert myOpp;

        Test.startTest();
        CS01_CloseOpportunityStage__c stageCS = new CS01_CloseOpportunityStage__c(Stage__c = 'test', name = 'test');
        insert stageCS;

        CS01_CloseOpportunityStat__c statCS = new CS01_CloseOpportunityStat__c(Statut__c = 'test', name = 'test');
        insert statCS;
        LC28_OpportunityPath_controller.setfields(myOpp.id, 'Actif', Label.PV_Realisation, cont, 'Prix');

    }
}