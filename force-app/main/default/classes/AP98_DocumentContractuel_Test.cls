/**
 * @author: Jimmy Khalil -EI Technologies
 * @date: 08/06/2021
 * @description: Test Class for "AP98_DocumentContractuel"
 */
@isTest
public class AP98_DocumentContractuel_Test {
    static testMethod void testDocIncrement(){

        account a1 = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity = 'test';
        a1.BillingPostalCode = '111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;

        Contrat__c c1 = new Contrat__c();
        c1.NomPartenaire__c = a1.Id;
        c1.Name = 'testtingg ';
        c1.DureeInitialeContrat__c = 1;
        c1.DatePriseEffet__c = date.today();
        insert c1;

        List<RecordType> recTypeList = [select Id from RecordType where DeveloperName =:Label.DocumentContractuelNonSync];

        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.RecordTypeId = recTypeList[0].id;
        DC1.NatureDocument__c = 'DOC01';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = c1.Id;
        DC1.DatePriseEffet__c = date.today();
        DC1.DateSignature__c = date.today();
        DC1.NiveauDeConfidentialite__c = 'DOC_C02';
        insert DC1;

        Document_Contractuel__c DC2 = new Document_Contractuel__c();
        DC2.RecordTypeId = recTypeList[0].id;
        DC2.NatureDocument__c = 'DOC03';
        DC2.StatutDocument__c = 'ACT';
        DC2.Contrat__c = c1.Id;
        DC2.DatePriseEffet__c = date.today();
        DC2.DateSignature__c = date.today();
        DC2.NiveauDeConfidentialite__c = 'DOC_C02';
        insert DC2;

        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp1.AccountId = a1.Id;
        myOpp1.closeDate = Date.today();
        myOpp1.statut__c = Label.Opp_StatutEnCours;
        myOpp1.Amount = 3;
        myOpp1.EstOpportuniteMere__c = true;
        myOpp1.NatureOpportunitMere__c = Label.AP16_National;
        //myOpp1.Composante_d_offre__c = 'Lifi';
        //myOpp1.Offres__c='FM global';
        insert myOpp1;

        Contrat__c cont = new Contrat__c(name = 'Contrat');
        cont.NomPartenaire__c = a1.Id;
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.EstContratcadre__c = true;
        cont.DatePriseEffet__c = date.today();
        insert cont;

        opportunity myOpp4 = testUtils.createOpportunity ('testOpp2', date.today(), Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp4.accountId = a1.Id;
        myOpp4.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp4.Type_pers__c = Label.Renouvellement;
        myOpp4.CreerNouveauProjetCommercial__c = false;
        myOpp4.Contrat_Genere_lookup__c = cont.id;
        myOpp4.ContratOrigine__c = cont.id;
        insert myOpp4;

        Document_Contractuel__c DC0 = new Document_Contractuel__c();
        DC0.RecordTypeId = recTypeList[0].id;
        DC0.NatureDocument__c = 'DOC01';
        DC0.StatutDocument__c = 'ACT';
        DC0.Contrat__c = cont.Id;
        DC0.DatePriseEffet__c = date.today();
        DC0.DateSignature__c = date.today();
        DC0.NiveauDeConfidentialite__c = 'DOC_C02';
        insert DC0;

        Document_Contractuel__c DC3 = new Document_Contractuel__c();
        DC3.RecordTypeId = recTypeList[0].id;
        DC3.NatureDocument__c = 'DOC11';
        DC3.StatutDocument__c = 'ACT';
        DC3.Contrat__c = cont.Id;
        DC3.DatePriseEffet__c = date.today();
        DC3.DateSignature__c = date.today();
        DC3.OpportuniteRattachee__c = myOpp4.id;
        DC3.NiveauDeConfidentialite__c = 'DOC_C02';

        try {
            insert DC3;
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.AP98_InterdireLettreResiliation) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        DC0.NatureDocument__c = 'DOC11';
        DC0.OpportuniteRattachee__c = myOpp4.Id;
        try {
            update DC0;
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.AP98_InterdireLettreResiliation) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
}