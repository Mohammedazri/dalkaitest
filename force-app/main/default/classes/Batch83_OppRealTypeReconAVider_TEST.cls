/**
* @author Alain Ghoussoub -EI Technologies
* @date 09/07/2020
* @description Test Class for Batch82_OppRealisationReconduction
*/
@isTest
public class Batch83_OppRealTypeReconAVider_TEST {
    @isTest
    static void testOppRealTypeReconAVider() {
        list<Account> listAcc = new List<Account>();
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.StatutPartenaire__c='OUV';
        listAcc.add(a1);
        account a2=testUtils.createAccount('testAccoun22', 'Lebanon', 'Privé');
        a2.StatutPartenaire__c='OUV';
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
        myOpp1.TypeReconduction__c ='RNUL';
        insert myOpp1;
        /*Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
        myFDS1.name = 'test1';
        myFDS1.Opportunit_commerciale__c = myOpp1.id;
        insert myFDS1;
        myOpp1.StageName = Label.PV_Realisation;
        myOpp1.Statut__c = Label.OppBeforeUp_gagne;
        myOpp1.Duree_minimale_estimee__c = 2;
        myOpp1.Societevente__c = a2.id;
        myOpp1.ZZZ_TECH_RealiseDuChemin__c = true;
        update myOpp1;*/
        Test.startTest();            
        Id batchJobId = Database.executeBatch(new Batch83_OppRealTypeReconAVider(), 200);
        Test.stopTest();
    }
}