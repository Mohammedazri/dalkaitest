/** 
* @author Jacques Akiki - Ei technologies
* @date 20/04/2022 
* @description test class of AP108_Opportunity and AP109_OpportunityContact
*/
@istest
public with sharing class AP108AP109_test {
    @istest
    static void deleteContactTest() {
        Contact cont = new Contact();
        cont.LastName = 'TEST';
        cont.FirstName = 'TEST';
        cont.Title = 'M';
        cont.Email = 'test.test@test.test';
        cont.Phone = '123';
        cont.Statut__c = 'Actif';
        insert cont;
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
        
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
         Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1] ;
            Fiche1.OffreA1P2VentesServices__c = 100;
            update Fiche1;
        
        /*Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
        myFDS1.name = 'test1';
        myFDS1.Opportunit_commerciale__c = myOpp1.id;
        insert myFDS1;*/
        myOpp1.Duree_minimale_estimee__c = 2;
        myOpp1.Societevente__c = a2.id;
        try{
            myOpp1.StageName = 'Proposition';
            update myOpp1;
        }
        Catch (Exception e){
            System.Assert(e.getMessage().contains(Label.AP108_Erreur));
        }
        OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c= cont.id);
        insert oc;
        myOpp1.StageName = 'Proposition';
        update myOpp1;
        try{
            delete oc;
        }
        Catch(Exception e){
            System.Assert(e.getMessage().contains(Label.AP109_Error));
        }     
    }
}