/**
* @author: Jacques Akiki
* @date: 23/04/2020
* @description: test class of AP81_OpportunityRenouv
*/
@isTest
public class AP81_OpportunityRenouv_Test {
    static testMethod void testPiloteRealisation(){
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
        insert myOpp1;
        
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
            Fiche1.OffreA1P1VentesServices__c = 0;
            update Fiche1; 
        
        /*Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
        myFDS1.name = 'test1';
        myFDS1.Opportunit_commerciale__c = myOpp1.id;
        insert myFDS1;*/
        myOpp1.StageName = Label.PV_Realisation;
        myOpp1.Statut__c = Label.OppBeforeUp_gagne;
        myOpp1.Duree_minimale_estimee__c = 2;
        myOpp1.Societevente__c = a2.id;
        myOpp1.ZZZ_TECH_RealiseDuChemin__c = true;
        update myOpp1;
        Test.startTest();
        List<contrat__c> listCont =[SELECT id FROM Contrat__c limit 1];
        List<opportunity> listOppRenouv = new List<Opportunity>();
        opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp2.accountId=a1.Id;
        myOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp2.Type_pers__c = Label.Renouvellement;
        myOpp2.CreerNouveauProjetCommercial__c = false;
        if(listCont[0]<>null)
        {
            myOpp2.ContratOrigine__c =listCont[0].id;
        }
        listOppRenouv.add(myOpp2);
        opportunity myOpp3 = testUtils.createOpportunity ('testOpp2', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp3.accountId=a1.Id;
        myOpp3.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp3.Type_pers__c = Label.Renouvellement;
        myOpp3.CreerNouveauProjetCommercial__c = false;
        if(listCont[0]<>null)
        {
            myOpp3.ContratOrigine__c =listCont[0].id;
        }
        listOppRenouv.add(myOpp3);
        try
        {
            insert listOppRenouv;
        }
        catch (Exception e)
        {
            System.assert(e.getMessage().contains(Label.AP81_ErreurRenouvellement));
        }
        insert myOpp2;        
        myOpp3.ContratOrigine__c = null;
        insert myOpp3;
        if(listCont[0]<>null)
        {
            myOpp3.ContratOrigine__c =listCont[0].id;
        }
        try
        {
            update myOpp3;        
        }
        catch (Exception e)
        {
            System.assert(e.getMessage().contains(Label.AP81_ErreurRenouvellement));
        }
        Test.stopTest();
    }
}