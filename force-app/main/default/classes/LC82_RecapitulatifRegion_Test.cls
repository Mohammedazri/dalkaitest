/** 
* @author Jacques Akiki
* @date 30/10/2020 
* @test Class of LC82_RecapitulatifRegion_Cont
*/

@isTest
public class LC82_RecapitulatifRegion_Test {
    static testMethod void testgetContratByReg() 
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
        a1.parentId = a2.id;
        update a1;
        Region__c reg = new Region__c (name = 'TESTReg');
        insert reg;
        Agence__c ag = new Agence__c (name='TESTAg' , Region__c = reg.id);
        insert ag;
        opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.accountId=a1.Id;
        myOpp1.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp1.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        myOpp1.Libelle_Agence__c = ag.id;
        insert myOpp1;
        Contact conta = new Contact();
        conta.LastName = 'TEST';
        conta.FirstName = 'TEST';
        conta.Title = 'M';
        conta.Email = 'test.test@test.test';
        conta.Phone = '123';
        conta.Statut__c = 'Actif';
        
        Contact cont1 = new Contact();
        cont1.LastName = 'TEST1';
        cont1.FirstName = 'TEST1';
        cont1.Title = 'M';
        cont1.Email = 'test.test1@test.test';
        cont1.Phone = '1231';
        cont1.Statut__c = 'Actif';
        
        insert new List<Contact> {conta,cont1};
            
         OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c= conta.id);
        OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c= cont1.id);
        insert new List<OpportuniteContact__c> {oc,oc1};
        /*Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
        myFDS1.name = 'test1';
        myFDS1.Opportunit_commerciale__c = myOpp1.id;
        insert myFDS1;*/
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c myFiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1] ;
        myFiche.OffreA1P1VentesServices__c = 0;
        update myFiche;
        myOpp1.StageName = Label.PV_Realisation;
        myOpp1.Statut__c = Label.OppBeforeUp_gagne;
        myOpp1.Duree_minimale_estimee__c = 2;
        myOpp1.Societevente__c = a2.id;
        myOpp1.ZZZ_TECH_RealiseDuChemin__c =true;
        update myOpp1;
        Test.startTest();
        LC82_RecapitulatifRegion_Cont.getContratByRegion(a2.id);
        Test.stopTest();
        
    }
}