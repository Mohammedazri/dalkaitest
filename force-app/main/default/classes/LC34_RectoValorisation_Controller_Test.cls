/**
 * This class contains unit tests for validating the behavior of Apex classe LC34_RectoValorisation_Controller
 */
@isTest(seealldata = true)
public class LC34_RectoValorisation_Controller_Test {

    // method used as test method to cover the Apex Controller LC34_RectoValorisation_Controller
    @isTest
    static void  LC34_RectoValorisationTest(){

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        Insert new List<Account> {a1, a2};

        String thisyear = String.valueOf(System.Today().year());
        String nextYear = String.valueOf(System.Today().year() + 1);

        Contact c1 = testUtilsC360.createContact('TestLC34', a1.Id, null, true);
        Insert c1;

        Opportunity opp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
        Insert opp1;

        testUtilsC360.completeeFDS(new set<Id> {opp1.Id});

        OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(opp1.Id, c1.Id);
        Insert oppCont1;

        opp1 = testUtilsC360.realiseOpportunity(opp1);
        Update opp1;

        List<Contrat__c> contList =  testUtilsC360.getContratGeneree(new set<Id> {opp1.Id});
        Contrat__c cont =  contList[0];

        Budget__c bud1 = testUtilsC360.createBudget('test', thisyear, cont.id, 100, 200);
        insert bud1;

        User u1 = testUtilsC360.CreateUser('standt18', 'lc34User@testorg1.com', 'Testing', Label.AdminProfileId, 'lc34User@testorg1.com');
        u1 = testUtilsC360.bypassUser(u1);

        Insert u1;

        PAD.PAD_BypassTrigger = ';' + u1.Bypass_Triggers__c + ';';

        System.runAs(u1){

            Test.startTest();
            //Updating the FDS
            Fiche_de_synthese__c myFiche = [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:opp1.Id Limit 1];

            myFiche.Budget__c = bud1.Id;
            myFiche.Budget_Realise__c = bud1.Id;
            update myFiche;

            // List of Wrapper_ApiToValue used as if the component is sending a serialized list to the Apex controller when calling the method UpdateFDS
            List<Wrapper_ApiToValue> listOfWrappers = new List<Wrapper_ApiToValue>();

            //Create a wrapper and add it to the list
            Wrapper_ApiToValue wrp1 = new Wrapper_ApiToValue();
            wrp1.ApiName = 'OffreA1P1VentesServices__c';
            wrp1.FieldValue = 3;
            listOfWrappers.add(wrp1);

            //Serialize the list of wrappers
            String wrapperSerialized = (String) Json.serialize(listOfWrappers);

            // List of Wrapper_ApiToValue used as if the component is sending a serialized list to the Apex controller when calling the method UpdateFDS
            List<Wrapper_ApiToValue> listOfWrappers1 = new List<Wrapper_ApiToValue>();

            //Create a wrapper and add it to the list
            Wrapper_ApiToValue wrp2 = new Wrapper_ApiToValue();
            wrp2.ApiName = 'SaisieRefP1VentesServices__c';
            wrp2.FieldValue = -999999999;
            listOfWrappers1.add(wrp2);

            //Serialize the list of wrappers
            String wrapperSerialized1 = (String) Json.serialize(listOfWrappers1);

            //Creating a record of the wrapper Wrapper_RectoValorisation
            Wrapper_RectoValorisation WRV = new Wrapper_RectoValorisation();
            WRV.Offre = 9;
            WRV.ApiNameSaisie = 'SaisieRefP1VentesServices__c';
            WRV.ApiNameOffre = 'OffreA1P1VentesServices__c';
            WRV.Title = 'Ventes services';
            WRV.rowspan = 10;
            WRV.editable = true;
            WRV.Realise = 5;
            WRV.Budget = 7;
            WRV.Saisie = 8;
            List<Wrapper_RectoValorisation> listWRV = new List<Wrapper_RectoValorisation>();
            listWRV.add(WRV);
            String listWRVJSON = (String) Json.serialize(listWRV);

            //Test.startTest();
            // call the functions of the Class LC34_RectoValorisation_Controller
            // using the variables and record created above
            List<Wrapper_RectoValorisation> wrappers = LC34_RectoValorisation_Controller.CreateWrappers( myFiche.Id);
            List<String> sringsReturned = LC34_RectoValorisation_Controller.UpdateFDS( wrapperSerialized, myFiche.Id, listWRVJSON);
            //List<String> sringsReturned1 = LC34_RectoValorisation_Controller.UpdateFDS(wrapperSerialized1, myFiche.Id, listWRVJSON);
            LC34_RectoValorisation_Controller.checkUserProfile();
            LC34_RectoValorisation_Controller.updateEcarttoZero(myFiche.Id);
            myFiche.SaisieRefP1VentesServices__c = NULL;
            update myFiche;

            // we are sorting the list to cover the implemented function compareTo in the class Wrapper_RectoValorisation
            wrappers.sort();
            Test.stopTest();
        }

    }

    @isTest
    static void LC34_testBouttonVerso(){
        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        Insert new List<Account> {a1, a2};

        String thisyear = String.valueOf(System.Today().year());
        String nextYear = String.valueOf(System.Today().year() + 1);

        Contact c1 = testUtilsC360.createContact('TestLC34', a1.Id, null, true);
        Insert c1;

        Opportunity opp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
        Insert opp1;

        testUtilsC360.completeeFDS(new set<Id> {opp1.Id});

        OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(opp1.Id, c1.Id);
        Insert oppCont1;

        opp1 = testUtilsC360.realiseOpportunity(opp1);
        Update opp1;

        List<Contrat__c> contList =  testUtilsC360.getContratGeneree(new set<Id> {opp1.Id});
        Contrat__c cont =  contList[0];

        Budget__c bud1 = testUtilsC360.createBudget('test', thisyear, cont.id, 100, 200);
        insert bud1;

        User u1 = testUtilsC360.CreateUser('standt18', 'lc34User@testorg1.com', 'Testing', Label.AdminProfileId, 'lc34User@testorg1.com');
        u1 = testUtilsC360.bypassUser(u1);

        Insert u1;

        PAD.PAD_BypassTrigger = ';' + u1.Bypass_Triggers__c + ';';
        System.runAs(u1){
            Test.startTest();
            Fiche_de_synthese__c myFiche = [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:opp1.Id Limit 1];

            LC34_RectoValorisation_Controller.updateEcarttoZero(myFiche.Id);

            myFiche.Budget__c = bud1.Id;
            myFiche.SaisieRefP2Fournituresetpetitsmat__c = NULL;
            myFiche.SaisieRefP2Electricite__c = NULL;
            myFiche.SaisieRefP2EauProduitsTrait__c = NULL;
            myFiche.SaisieRefP2STControlesReglem__c = NULL;
            myFiche.SaisieRefP2STEntretienCompteurs__c = NULL;
            myFiche.SaisieRefP2STGECogeneration__c = NULL;
            myFiche.SaisieRefP2EtudesDemarrage__c = NULL;
            myFiche.SaisieRefP2Amortissements__c = NULL;
            myFiche.SaisieRefP2AutresChargesEtProduits__c = NULL;
            myFiche.SaisieRefP3VentesServices__c = NULL;
            myFiche.SaisieRefP3AchatsExternes__c = NULL;
            myFiche.SaisieRefP3Autreschargesetproduits__c = NULL;
            myFiche.SaisieRefP4Investissements__c = NULL;
            myFiche.SaisieRefP4VentesServices__c = NULL;
            myFiche.SaisieRefP4Amortissements__c = NULL;
            myFiche.SaisieRefP4Autreschargesetproduits__c = NULL;
            myFiche.SaisieRefP6VentesServices__c = NULL;
            myFiche.SaisieRefP6AchatsExternes__c = NULL;
            myFiche.SaisieRefP6Autreschargesetproduits__c = NULL;
            myFiche.SaisieRefP2STTraitementEau__c = NULL;
            myFiche.SaisieRefP2STMultiservices__c = NULL;
            myFiche.SaisieRefP2STAutresPrestations__c = NULL;
            myFiche.SaisieRefP2SousTraitanceInterne__c = NULL;
            myFiche.SaisieRefP2LocationsEntretien__c = NULL;
            myFiche.SaisieRefP2Telesurveillance__c = NULL;
            myFiche.SaisieRefP1Investissements__c = NULL;
            myFiche.SaisieRefP1VentesServices__c = NULL;
            myFiche.SaisieRefP1AchatsEnergieGaz__c = NULL;
            myFiche.SaisieRefP1AchatsEnergieFuel__c = NULL;
            myFiche.SaisieRefP1AchatsEnergieCharbon__c = NULL;
            myFiche.SaisieRefP1AchatsEnergieBiomasse__c = NULL;
            myFiche.SaisieRefP1AchatsEnergieElectricite__c = NULL;
            myFiche.SaisieRefP1AchatsAutresEnergies__c = NULL;
            myFiche.SaisieRefP1Amortissements__c = NULL;
            myFiche.SaisieRefP1AutresChargesEtProduits__c = NULL;
            myFiche.SaisieRefP2Investissements__c = NULL;
            myFiche.SaisieRefP2VentesServices__c = NULL;
            myFiche.SaisieRefMainOeuvreDontNbHeureP2__c = NULL;
            myFiche.SaisieRefMainOeuvreDontNbHeureP3__c = NULL;
            myFiche.SaisieRefMainOeuvreDontNbHeureP6__c = NULL;
            myFiche.SaisieRefMainOeuvreValorisationTHO__c = NULL;
            myFiche.SaisieRefMainOeuvreEffectifDedie__c = NULL;
            update myFiche;
            LC34_RectoValorisation_Controller.updateEcarttoZero(myFiche.Id);
            Test.stopTest();
        }
    }
}