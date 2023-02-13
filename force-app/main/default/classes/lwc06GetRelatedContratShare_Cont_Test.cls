/** 
* @author Jacques Akiki
* @date 28/09/2022 
* @test Class of lwc06GetRelatedContratShare_Controller
*/

@isTest
public class lwc06GetRelatedContratShare_Cont_Test {
    static testMethod void testDisplayContratShare() 
    {
        Profile CommFirst = [SELECT Id FROM Profile WHERE Name=:label.Profile_CommercialFirst];
        User u2 = testUtils.CreateUser('standt8', 'user211@testorg2.com', 'Testi2', CommFirst.Id, 'user2@testorg2.com');
        u2.Organisation__c = 'J00003660J';
        insert u2;
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
        Contact contct = new Contact();
        contct.LastName = 'TEST';
        contct.FirstName = 'TEST';
        contct.Title = 'M';
        contct.Email = 'test.test@test.test';
        contct.Phone = '123';
        contct.Statut__c = 'Actif';
        
        insert contct;
            
         OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c= contct.id);
        insert oc;
        
        Fiche_de_synthese__c myFiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1] ;
        myFiche.OffreA1P1VentesServices__c = 0;
        update myFiche;
        myOpp1.StageName = Label.PV_Realisation;
        myOpp1.Statut__c = Label.OppBeforeUp_gagne;
        myOpp1.Duree_minimale_estimee__c = 2;
        myOpp1.Societevente__c = a2.id;
        myOpp1.ZZZ_TECH_RealiseDuChemin__c =true;
        myOpp1.natureOffre__c ='NOF03';
        myOpp1.engagementEnergetique__c='COF11'; 
        myOpp1.niveauDeMaintenance__c ='COF32';
        myOpp1.paiementDesEnergies__c ='COF21';
        update myOpp1;

        List<Contrat__c> listCont =[SELECT id,OpportuniteCommerciale__c FROM Contrat__c where OpportuniteCommerciale__c=:myOpp1.id];
        Test.startTest();
        System.Assert(lwc06GetRelatedContratShare_Controller.getTotalContratShare(listCont[0].id)==1);
        System.Assert(lwc06GetRelatedContratShare_Controller.getRelatedContratSharerefresh(listCont[0].id, 1, 1)[0].notdeleteable);
        Contrat__Share cs = new Contrat__Share();
        cs.parentId= listCont[0].id;
        cs.AccessLevel = 'Read';
        cs.UserOrGroupId = u2.id;
        insert cs;
        System.Assert(lwc06GetRelatedContratShare_Controller.deleteContratShare(cs.Id)=='OK');
        Test.stopTest();
        
    }
}