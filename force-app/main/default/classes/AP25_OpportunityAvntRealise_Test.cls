/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Classe test utilisé pour couvrir la classe AP25_OpportunityAvntRealise
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP25_OpportunityAvntRealise_Test 
{
    @isTest
    static void AP25_TestMethod() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        insert u2; 
        
        Contact cont = new Contact();
        cont.LastName = 'TEST';
        cont.FirstName = 'TEST';
        cont.Title = 'M';
        cont.Email = 'test.test@test.test';
        cont.Phone = '123';
        cont.Statut__c = 'Actif';
        
        Contact cont1 = new Contact();
        cont1.LastName = 'TEST1';
        cont1.FirstName = 'TEST1';
        cont1.Title = 'M';
        cont1.Email = 'test.test1@test.test';
        cont1.Phone = '1231';
        cont1.Statut__c = 'Actif';
        
        insert new List<Contact> {cont,cont1};
        
        List<Account> listAcc = new list<Account>();
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        listAcc.add(a1);
        
        account a2=testUtils.createAccount('testAccount-SDV', 'Lebanon', 'Privé');
        a2.Lieu_immatriculation_legale__c = 'test';
        a2.Immatriculation_Legale__c = 'test3';
        a2.Type_immatriculation__c = 'RCS';
        a2.StatutPartenaire__c = Label.WS11_OUV;
        a2.BillingCity='test';
        a2.BillingPostalCode='112';
        a2.Code_NACE__c = '222';
        a2.SIRET__c = '255236';
        a2.Siege_social_partenaire__c = true;
        a2.Categorie_partenaire__c = 'DLK';
        a2.DKCodeSurPartenaire__c = '112233';
        listAcc.add(a2);
        insert listAcc;
        
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.OwnerID=u2.id;
        c1.Name='testtingg ';
        c1.DureeInitialeContrat__c = 1;
        c1.DKCodeSurContrat__c = '123321';
        c1.Statut__c = 'OUV';
        c1.TypeReconduction__c = 'RNUL';
        c1.DatePriseEffet__c = System.Today() -2;
        c1.DureeInitialeContrat__c = 1;
        c1.NombreReconductionsPassees__c = 1;
        c1.DureeReconduction__c = 1;
        c1.NombreReconductionsAutorisees__c = 1;
        c1.DureeProlongationTotale__c = 1;
        insert c1;
        
        ContratContact__c cc = new ContratContact__c(contrat__c = c1.id, Contact__c= cont.id);
        insert new List<ContratContact__c> {cc};
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.OwnerId=u2.id;
        myOpp.accountId=a1.Id;
        myOpp.ContratOrigine__c=c1.id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.Societevente__c = a2.id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        insert myOpp;
        
        OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c= cont.id);
        OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c= cont1.id);
        insert new List<OpportuniteContact__c> {oc,oc1};
        
        //Sprint 31: Commented by Jimmy US C360-717
        /*Fiche_de_synthese__c fds =  testUtils.createFDS();
           fds.Opportunit_commerciale__c = myOpp.Id;
           insert fds;*/

        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c Fiche1 = [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1];
        Fiche1.OffreA1P1VentesServices__c = 0;
        update Fiche1;
        
        Test.startTest();
        AP25_OpportunityAvntRealise.firstRun =true;
        myOpp.Statut__c=Label.OppBeforeUp_gagne;
        myOpp.DureeProlongationSupp__c = 5;
        myOpp.stageName = Label.PV_Realisation;
        myOpp.ZZZ_TECH_RealiseDuChemin__c = true; 
        myOpp.Segment_client__c = Label.SegmentOpp_Tertaire;
        myOpp.SousSegmentMarche__c = Label.SousSegmentOpp_Autres;
        myOpp.natureOffre__c = Label.AP104_NatureCVC;
        myOpp.engagementEnergetique__c = Label.AP104_EngagementSansTravaux;
        myOpp.paiementDesEnergies__c = Label.AP104_PaiementDalkia;
        myOpp.niveauDeMaintenance__c = Label.AP104_NiveauGER;
        Update myOpp;
        
        Test.stopTest();
        
    }
}