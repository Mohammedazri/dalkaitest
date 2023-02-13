/**
 * @author Jimmy Khalil - Ei technologies
 * @date 24/05/2021
 * @description test Class Batch112_UpdateActiviteContrat
 */
@isTest
public class Batch112_UpdateActiviteContrat_TEST {
    static testMethod void testContrat(){
        Profile p = [SELECT Id FROM Profile WHERE name =:Label.Profile_CommercialFirst];

        Agence__c a1 = new agence__c();
        a1.Code_Agence__c = 'Agence One';
        a1.DKCode__c = 'code1';
        a1.Name = 'Agence One';
        insert a1;

        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        u1.Organisation__c = 'code1';//Agence One

        insert u1;
        System.runAs(u1){
            Account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            myaccount.BillingCity = 'test';
            myaccount.BillingPostalCode = '111';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            list<Opportunity> listOpp = new List<Opportunity>();
            Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
            myOpp1.AccountId = myaccount.Id;
            myOpp1.closeDate = Date.today();
            myOpp1.Amount = 3;
            listOpp.add(myOpp1);
            Opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
            myOpp2.AccountId = myaccount.Id;
            myOpp2.closeDate = Date.today();
            myOpp2.Amount = 3;
            listOpp.add(myOpp2);
            insert listOpp;

            list<contrat__c> listcont = new List<Contrat__c>();
            Contrat__c cont = new Contrat__c(Name = 'TEST');
            cont.DureeProlongationTotale__c = 0;
            cont.NomPartenaire__c = myaccount.Id;
            cont.OpportuniteCommerciale__c = myOpp1.id;
            listcont.add(cont);
            Contrat__c cont1 = new Contrat__c(Name = 'TEST11');
            cont1.DureeProlongationTotale__c = 0;
            cont1.NomPartenaire__c = myaccount.Id;
            cont1.OpportuniteCommerciale__c = myOpp2.id;
            listcont.add(cont1);
            insert listcont;

            id BatchId = Database.executeBatch(new Batch112_UpdateActiviteContrat());
        }
    }
    static testMethod void testContrat1(){
        Profile p = [SELECT Id FROM Profile WHERE name =:Label.Profile_CommercialFirst];

        Agence__c a1 = new agence__c();
        a1.Code_Agence__c = 'Agence One';
        a1.DKCode__c = 'code1';
        a1.Name = 'Agence One';
        insert a1;

        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        u1.Organisation__c = 'code1';//Agence One

        insert u1;
        System.runAs(u1){
            Account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            myaccount.BillingCity = 'test';
            myaccount.BillingPostalCode = '111';
            myaccount.Lieu_immatriculation_legale__c = 'test';

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

            Contrat__c contOrigine = new Contrat__c(Name = 'TEST');
            contOrigine.DureeProlongationTotale__c = 0;
            contOrigine.NomPartenaire__c = myaccount.Id;

            insert contOrigine;

            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
            myOpp.AccountId = myaccount.Id;
            myOpp.closeDate = Date.today();
            myOpp.Type_pers__c = Label.Opp_type_Renewal;
            myOpp.EstOpportuniteMere__c = true;
            myOpp.NatureOpportunitMere__c = Label.AP16_National;
            myOpp.ContratOrigine__c = contOrigine.ID;
            myOpp.Annee_de_signature__c = String.valueOf(System.Today().year());
            insert myOpp;

            Contact Cnct = TestUtils.createContact('test', myaccount2.id, null);
            Cnct.FirstName = 'test';
            Cnct.Phone = '123456';
            insert Cnct;

            OpportuniteContact__c oc = new OpportuniteContact__c(contact__c = Cnct.id, Opportunite__c = myOpp.id);
            insert oc;

            Test.startTest();
            /*Fiche_de_synthese__c fds =  testUtils.createFDS();
               fds.Opportunit_commerciale__c = myOpp.Id;
               insert fds;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS = [Select id From Fiche_de_synthese__c];

            for(Fiche_de_synthese__c fds : listFDS) {
                fds.SaisieRefP1VentesServices__c = 12;
                fds.OffreA1P1VentesServices__c = 13;
                fds.tech_previous_changes__c = null;
            }
            Update listFDS;

            contOrigine.Statut__c = Label.ContratFerme;
            update contOrigine;

            myOpp.Statut__c = Label.OppBeforeUp_gagne;
            myOpp.Stagename = Label.AP16_Realisation;
            myOpp.Name = 'test6';
            myOpp.ZZZ_TECH_RealiseDuChemin__c   = true;
            myOpp.Segment_client__c = Label.SegmentOpp_Tertaire;
            myOpp.SousSegmentMarche__c = Label.SousSegmentOpp_Autres;
            myOpp.Duree_minimale_estimee__c = 5;
            myOpp.TypeReconduction__c = 'RNUL';
            myOpp.Duree_maximale_estimee__c = 6;

            myOpp.Societevente__c = myaccount2.ID;
            myOpp.natureOffre__c = Label.AP104_NaturePointUnique;
            myOpp.engagementEnergetique__c = Label.AP104_EngagementSansTravaux;
            myOpp.paiementDesEnergies__c = Label.AP104_PaiementDalkia;
            myOpp.niveauDeMaintenance__c = Label.AP104_NiveauGER;

            update myOpp;

            Contrat__c cont = new Contrat__c(Name = 'TEST');
            cont.DureeProlongationTotale__c = 0;
            cont.NomPartenaire__c = myaccount.Id;
            cont.OpportuniteCommerciale__c = myOpp.id;
            cont.Statut__c = Label.ContratFerme;
            insert cont;

            id BatchId = Database.executeBatch(new Batch112_UpdateActiviteContrat());
            Test.stopTest();
        }
    }
}