@isTest
public class Batch70_UpdateSegmentSousSegment_test {
    static testMethod void tesOppSegemnt(){
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
        List<Opportunity> listOpp = new List<Opportunity>();
        List<Opportunity> listOppUpdate = new List<Opportunity>();
        opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.accountId=a1.Id;
        myOpp1.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp1.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        listOpp.add(myOpp1);
        
        opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp2.accountId=a1.Id;
        myOpp2.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp2.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        listOpp.add(myOpp2);
        
        opportunity myOpp3 = testUtils.createOpportunity ('testOpp3', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp3.accountId=a1.Id;
        myOpp3.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp3.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        listOpp.add(myOpp3);
        
        opportunity myOpp4 = testUtils.createOpportunity ('testOpp4', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp4.accountId=a1.Id;
        myOpp4.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp4.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        listOpp.add(myOpp4);
        
        opportunity myOpp5 = testUtils.createOpportunity ('testOpp5', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp5.accountId=a1.Id;
        myOpp5.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp5.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        listOpp.add(myOpp5);
        
        insert listOpp;
        /*List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
        myFDS1.name = 'test1';
        myFDS1.Opportunit_commerciale__c = myOpp4.id;
        listFDS.add(myFDS1);
        Fiche_de_synthese__c myFDS2 = testUtils.createFDS();
        myFDS2.name = 'test2';
        myFDS2.Opportunit_commerciale__c = myOpp5.id;
        listFDS.add(myFDS2);
        insert listFDS;*/
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
        
        for(Fiche_de_synthese__c fds:listFDS){
            fds.SaisieRefP1VentesServices__c=12;
            fds.OffreA1P1VentesServices__c=13;
        }
        Update listFDS;
        
        Contact cont = testUtils.createContact('Smith', a1.id, null);
        insert cont;
        
        OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp4.id, Contact__c= cont.id);
        OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp5.id, Contact__c= cont.id);
        insert new List<OpportuniteContact__c> {oc,oc1};
        
        test.StartTest();
        myOpp4.StageName = Label.LC28_Proposition;
        myOpp4.Duree_minimale_estimee__c = 2;
        listOppUpdate.add(myOpp4);
        myOpp5.StageName = Label.PV_Realisation;
        myOpp5.Statut__c = Label.OppBeforeUp_gagne;
        myOpp5.Duree_minimale_estimee__c = 2;
        myOpp5.Societevente__c = a2.id;
        myOpp5.ZZZ_TECH_RealiseDuChemin__c = true; 
        listOppUpdate.add(myOpp5);
        update listOppUpdate;
        
        Id BatchId = Database.executeBatch(new Batch70_UpdateSegmentSousSegment());
        test.StopTest();
        
    }
}