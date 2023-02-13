/**
* @author: Charbel Khoury Hanna
* @date: 06/23/2021
* @description: Test Class for Class AP99_ContratUOPilote
*/
@isTest
public class AP99_ContratUOPilote_Test {

    @isTest
    static void test()
    {
        list<Account> listAcc = new List<Account>();
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.StatutPartenaire__c=Label.WS11_OUV;
        listAcc.add(a1);
        account a2=testUtils.createAccount('testAccoun22', 'Lebanon', 'Privé');
        a2.StatutPartenaire__c=Label.WS11_OUV;
        a2.Code_NACE__c = '123';
        a2.SIRET__c = '112233';
        a2.Categorie_partenaire__c = 'DLK';
        a2.Siege_social_partenaire__c = true;
        listAcc.add(a2);
        insert listAcc;
        opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.accountId=a1.Id;
        myOpp1.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp1.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        insert myOpp1;
        CentreFinance__c cf = new CentreFinance__c(name = 'TESTCF');
        insert cf;
        Region__c reg = new Region__c (name = 'TESTReg' , CentreFinance__c = cf.id);
        insert reg;
        Agence__c ag = new Agence__c (name='TESTAg' , Region__c = reg.id);
        insert ag;
        
        CentreFinance__c cf1 = new CentreFinance__c(name = 'TESTCF1');
        insert cf1;
        Region__c reg1 = new Region__c (name = 'TESTReg1' , CentreFinance__c = cf1.id);
        insert reg1;
        Agence__c ag1 = new Agence__c (name='TESTAg1' , Region__c = reg1.id);
        insert ag1;
        
        Test.startTest();
        
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
            
         OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c= cont.id);
        OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c= cont1.id);
        insert new List<OpportuniteContact__c> {oc,oc1};
            
         //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
         Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1] ;
            Fiche1.OffreA1P2VentesServices__c = 100;
            update Fiche1; 
        
/*        Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
        myFDS1.name = 'test1';
        myFDS1.Opportunit_commerciale__c = myOpp1.id;
        insert myFDS1;*/
        myOpp1.StageName = Label.PV_Realisation;
        myOpp1.Statut__c = Label.OppBeforeUp_gagne;
        myOpp1.Duree_minimale_estimee__c = 2;
        myOpp1.Societevente__c = a2.id;
        myOpp1.ZZZ_TECH_RealiseDuChemin__c  = true;
        myOpp1.Libelle_Agence__c = ag.id;
        update myOpp1;
        //List<contrat__c> listCont =[SELECT id, Libelle_Agence__c FROM Contrat__c limit 1];
        //listCont[0].Libelle_Agence__c = ag1.id;
        
        Contrat__c contrat2 = new Contrat__c();
        contrat2.NomPartenaire__c = a2.Id;
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        contrat2.TypeContrat__c = 'IND';
        insert contrat2;
        contrat2.Libelle_Agence__c = ag1.id;
        update contrat2;
        
    }
}