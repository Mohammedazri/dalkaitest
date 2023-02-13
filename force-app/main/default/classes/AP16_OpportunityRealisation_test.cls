/**
 * This class contains unit tests for validating the behavior of Apex classes AP16_OpportunityRealisation
   Update History:
 */
@isTest
public class AP16_OpportunityRealisation_test {
    @isTest
    static void tesAP16_Opportunity(){
        Contact contct = new Contact();
        contct.LastName = 'TEST';
        contct.FirstName = 'TEST';
        contct.Title = 'M';
        contct.Email = 'test.test@test.test';
        contct.Phone = '0123456789';
        contct.Statut__c = 'Actif';
        insert contct;

        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.Immatriculation_Legale__c = 'test1';
        myaccount.Type_immatriculation__c = 'RCS';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;

        account myaccount3 = testUtils.createAccount2('testAccount3', 'Lebanon', 'Privé');
        myaccount3.Lieu_immatriculation_legale__c = 'test';
        myaccount3.Immatriculation_Legale__c = 'test3';
        myaccount3.Type_immatriculation__c = 'RCS';
        myaccount3.StatutPartenaire__c = Label.WS11_OUV;
        myaccount3.BillingCity = 'test';
        myaccount3.BillingPostalCode = '112';
        myaccount3.Code_NACE__c = '222';
        myaccount3.SIRET__c = '255236';
        myaccount3.Siege_social_partenaire__c = true;
        myaccount3.Categorie_partenaire__c = 'DLK';

        insert new List<Account> {myaccount, myaccount3};

        opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp1.AccountId = myaccount.Id;
        myOpp1.closeDate = Date.today();
        myOpp1.Type_pers__c = Label.Renouvellement;
        myOpp1.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        myOpp1.EstOpportuniteMere__c = true;
        myOpp1.NatureOpportunitMere__c = Label.AP16_National;
        myOpp1.natureOffre__c = Label.AP104_NatureCVC;
        myOpp1.engagementEnergetique__c = 'COF11';
        myOpp1.paiementDesEnergies__c = 'COF21';
        myOpp1.niveauDeMaintenance__c = 'COF33';
        insert myOpp1;
        OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c = contct.id);
        insert oc;
        Contrat__c cont = new Contrat__c(name = 'Contrat');
        cont.NomPartenaire__c = myaccount3.Id;
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.EstContratcadre__c = true;
        cont.NatureContratCadre__c = Label.AP16_National;
        cont.Statut_Facturation__c = 'ATT';
        cont.ValeurEnEMWh__c = 1;
        cont.RepercussionChargeCEE__c = true;
        cont.DatePriseEffet__c = System.Today() -2;
        cont.DureeInitialeContrat__c = 1;
        cont.NombreReconductionsPassees__c = 1;
        cont.DureeReconduction__c = 1;
        cont.NombreReconductionsAutorisees__c = 1;
        cont.DureeProlongationTotale__c = 1;
        insert cont;

        opportunity myOpp2 = testUtils.createOpportunity ('testOpp5', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp2.AccountId = myaccount.Id;
        myOpp2.closeDate = Date.today();
        myOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp2.Type_pers__c = Label.Opp_type_Renewal;
        myOpp2.OpportuniteMere__c = myOpp1.id;
        myOpp2.NatureOpportunitMere__c = Label.AP16_National;
        myOpp2.Contrat_Genere_lookup__c = cont.id;
        myOpp2.TypeContratFirst__c = 'PFA';
        myOpp2.TypePrestations__c = 'P1';
        myOpp2.TypeEnergie__c = 'Chaleur';
        myOpp2.TransparenceP3__c = false;
        myOpp2.RapportActivite__c = false;
        myOpp2.ConsommationChaud__c = 5;
        myOpp2.ConsommationFroid__c = 5;
        myOpp2.PuissanceChaud__c = 5;
        myOpp2.PuissanceFroid__c = 5;

        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp.AccountId = myaccount.Id;
        myOpp.closeDate = Date.today();
        myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c = Label.Opp_type_Renewal;
        myOpp.OpportuniteMere__c = myOpp1.id;
        myOpp.NatureOpportunitMere__c = Label.AP16_National;

        insert new List<Opportunity> {myOpp2, myOpp};
        OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c = contct.id);
        OpportuniteContact__c oc2 = new OpportuniteContact__c(Opportunite__c = myOpp2.id, Contact__c = contct.id);
        insert new List<OpportuniteContact__c> {oc1, oc2};
        Test.startTest();
        //Sprint 31: Commented by Jimmy US C360-717
        /*Fiche_de_synthese__c fds1 =  testUtils.createFDS();
           fds1.Opportunit_commerciale__c = myOpp2.Id;

           Fiche_de_synthese__c fds2 =  testUtils.createFDS();
           fds2.Opportunit_commerciale__c = myOpp.Id;

           Fiche_de_synthese__c fds3 =  testUtils.createFDS();
           fds3.Opportunit_commerciale__c = myOpp1.Id;
           insert new List<Fiche_de_synthese__c> {fds1,fds2,fds3};*/
        List<Fiche_de_synthese__c> listFDS = [Select id From Fiche_de_synthese__c];
        for(Fiche_de_synthese__c fds : listFDS) {
            fds.OffreA1P1VentesServices__c = 1;
        }
        Update listFDS;

        

        myOpp2.name = 'test001233';
        myOpp2.Stagename = Label.AP16_Realisation;
        myOpp2.ZZZ_TECH_RealiseDuChemin__c  = true;
        myOpp2.Segment_client__c = Label.SegmentOpp_Tertaire;
        myOpp2.SousSegmentMarche__c = Label.SousSegmentOpp_Autres;
        myOpp2.Duree_minimale_estimee__c = 5;
        myOpp2.TypeReconduction__c = 'RNUL';
        myOpp2.Statut__c = Label.OppBeforeUp_gagne;
        myOpp2.Societevente__c = myaccount3.ID;
        myOpp2.TypeContratFirst__c = 'PF';
        myOpp2.TypePrestations__c = 'P2';
        myOpp2.TypeEnergie__c = 'Bois';
        myOpp2.TransparenceP3__c = true;
        myOpp2.RapportActivite__c = true;
        myOpp2.ConsommationChaud__c = 6;
        myOpp2.ConsommationFroid__c = 6;
        myOpp2.PuissanceChaud__c = 6;
        myOpp2.PuissanceFroid__c = 6;
        myOpp2.natureOffre__c = Label.AP104_NatureCVC;
        myOpp2.engagementEnergetique__c = 'COF11';
        myOpp2.paiementDesEnergies__c = 'COF21';
        myOpp2.niveauDeMaintenance__c = 'COF33';
        myOpp2.ContratObligeantCEEPck__c = 'Oui';

        myOpp.Stagename = Label.AP16_Realisation;
        myOpp.ZZZ_TECH_RealiseDuChemin__c   = true;
        myOpp.Segment_client__c = Label.SegmentOpp_Tertaire;
        myOpp.SousSegmentMarche__c = Label.SousSegmentOpp_Autres;
        myOpp.Duree_minimale_estimee__c = 5;
        myOpp.TypeReconduction__c = 'RNUL';
        myOpp.Statut__c = Label.OppBeforeUp_gagne;
        myOpp.Societevente__c = myaccount3.ID;
        myOpp.name = 'test001';
        myOpp.CloseDate = Date.newInstance(2019, 11, 20);
        myOpp.natureOffre__c = Label.AP104_NatureCVC;
        myOpp.engagementEnergetique__c = 'COF11';
        myOpp.paiementDesEnergies__c = 'COF21';
        myOpp.niveauDeMaintenance__c = 'COF33';
        myOpp.ContratObligeantCEEPck__c = 'Oui';

        update new List<Opportunity> {myOpp2, myOpp};

    }

    @isTest
    static void tesAP16_OpportunityCase2(){

        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId];
        Contact contct = new Contact();
        contct.LastName = 'TEST';
        contct.FirstName = 'TEST';
        contct.Title = 'M';
        contct.Email = 'test.test@test.test';
        contct.Phone = '0123456789';
        contct.Statut__c = 'Actif';
        insert contct;
        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.Immatriculation_Legale__c = 'test1';
        myaccount.Type_immatriculation__c = 'RCS';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;

        account myaccount2 = testUtils.createAccount2('testAccount3', 'Lebanon', 'Privé');
        myaccount2.Lieu_immatriculation_legale__c = 'test';
        myaccount2.Immatriculation_Legale__c = 'test3';
        myaccount2.Type_immatriculation__c = 'RCS';
        myaccount2.StatutPartenaire__c = Label.WS11_OUV;
        myaccount2.BillingCity = 'test';
        myaccount2.BillingPostalCode = '112';
        myaccount2.Code_NACE__c = '222';
        myaccount2.SIRET__c = '255236';
        myaccount2.Siege_social_partenaire__c = true;
        myaccount2.Categorie_partenaire__c = 'DLK';
        myaccount2.DKCodeSurPartenaire__c = '112233';

        insert new List<Account> {myaccount, myaccount2};

        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        insert u1;

        String teamMemberRole = 'Account Manager';
        AccountTeamMember myaccoutMember = New AccountTeamMember(AccountId = myaccount.id, TeamMemberRole = teamMemberRole, UserId = u1.Id);
        insert myaccoutMember;

        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp.AccountId = myaccount.Id;
        myOpp.closeDate = Date.today();
        myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        myOpp.Type_pers__c = Label.Opp_type_Renewal;
        myOpp.EstOpportuniteMere__c = true;
        myOpp.NatureOpportunitMere__c = Label.AP16_National;
        insert myOpp;

        Contrat__c cont = new Contrat__c(name = 'Contrat');
        //cont.represente_par__c = null;
        cont.NomPartenaire__c = myaccount.Id;
        cont.OpportuniteCommerciale__c = myOpp.id;
        cont.EstContratcadre__c = true;
        cont.Statut_Facturation__c = 'ATT';
        cont.ValeurEnEMWh__c = 1;
        cont.RepercussionChargeCEE__c = true;
        cont.TypeReconduction__c = 'RNUL';
        cont.DatePriseEffet__c = System.Today() -2;
        cont.DureeInitialeContrat__c = 1;
        cont.NombreReconductionsPassees__c = 1;
        cont.DureeReconduction__c = 1;
        cont.NombreReconductionsAutorisees__c = 1;
        cont.DureeProlongationTotale__c = 1;
        insert cont;

        opportunity myOpp2 = testUtils.createOpportunity ('testOpp5', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp2.AccountId = myaccount.Id;
        myOpp2.closeDate = Date.today();
        myOpp2.EstOpportuniteMere__c = true;
        myOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        myOpp2.Type_pers__c = Label.Opp_type_Renewal;
        myOpp2.NatureOpportunitMere__c = Label.AP16_National;
        insert myOpp2;
        OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c = contct.id);
        OpportuniteContact__c oc2 = new OpportuniteContact__c(Opportunite__c = myOpp2.id, Contact__c = contct.id);
        insert new List<OpportuniteContact__c> {oc1, oc2};
        Test.startTest();
        //Sprint 31: Commented by Jimmy US C360-717
        /*Fiche_de_synthese__c fds1 =  testUtils.createFDS();
           fds1.Opportunit_commerciale__c = myOpp2.Id;

           Fiche_de_synthese__c fds2 =  testUtils.createFDS();
           fds2.Opportunit_commerciale__c = myOpp.Id;
           insert new List<Fiche_de_synthese__c> {fds1,fds2};*/
        List<Fiche_de_synthese__c> listFDS = [Select id From Fiche_de_synthese__c];
        for(Fiche_de_synthese__c fds : listFDS) {
            fds.OffreA1P1VentesServices__c = 1;
        }
        Update listFDS;

        EcosystemePartenaire__c myEco = new EcosystemePartenaire__c();
        myEco.PartenaireLie__c = myaccount2.Id;
        myEco.TypeRelation__c = 'Concurrents';
        myEco.Opportunite__c = myOpp.Id;
        insert myEco;

        myOpp2.Stagename = Label.AP16_Realisation;
        myOpp2.Name = 'test6';
        myOpp2.ZZZ_TECH_RealiseDuChemin__c  = true;
        myOpp2.Segment_client__c = Label.SegmentOpp_Tertaire;
        myOpp2.SousSegmentMarche__c = Label.SousSegmentOpp_Autres;
        myOpp2.Duree_minimale_estimee__c = 5;
        myOpp2.TypeReconduction__c = 'RNUL';
        myOpp2.Statut__c = Label.OppBeforeUp_gagne;
        myOpp2.Societevente__c = myaccount2.ID;
        myOpp2.natureOffre__c = Label.AP104_NatureCVC;
        myOpp2.engagementEnergetique__c = 'COF11';
        myOpp2.paiementDesEnergies__c = 'COF21';
        myOpp2.niveauDeMaintenance__c = 'COF33';
        myOpp2.ContratObligeantCEEPck__c = 'Oui';

        myOpp.Statut__c = Label.OppBeforeUp_gagne;
        myOpp.Stagename = Label.AP16_Realisation;
        myOpp.Name = 'test6';
        myOpp.ZZZ_TECH_RealiseDuChemin__c   = true;
        myOpp.Segment_client__c = Label.SegmentOpp_Tertaire;
        myOpp.SousSegmentMarche__c = Label.SousSegmentOpp_Autres;
        myOpp.Duree_minimale_estimee__c = 5;
        myOpp.TypeReconduction__c = 'RNUL';
        myOpp.Societevente__c = myaccount2.ID;
        myOpp.natureOffre__c = Label.AP104_NatureCVC;
        myOpp.engagementEnergetique__c = 'COF11';
        myOpp.paiementDesEnergies__c = 'COF21';
        myOpp.niveauDeMaintenance__c = 'COF33';
        myOpp.ContratObligeantCEEPck__c = 'Oui';

        update new List<Opportunity> {myOpp, myOpp2};

        myOpp.TypeReconduction__c = 'RTAC';
        myOpp.StageName = 'Proposition';
        myOpp.name = 'test001';
        myOpp.CloseDate = Date.newInstance(2019, 11, 20);
        myOpp.Statut__c = Label.Opp_StatutEnCours;
        myOpp.OwnerID = u1.id;
        myOpp.Duree_minimale_estimee__c = 3;
        myOpp.Duree_maximale_estimee__c = 4;
        myOpp.DureeReconduction__c = 3;
        myOpp.NombreReconductionsAutorisees__c = 3;
        myOpp.ReconductionFaitAutorisee__c = true;
        myOpp.DureePreavis__c = 3;
        myOpp.ConsommationChaud__c = 3;
        myOpp.ConsommationFroid__c = 3;
        myOpp.PuissanceChaud__c = 3;
        myOpp.PuissanceFroid__c = 3;
        update myOpp;

    }
}