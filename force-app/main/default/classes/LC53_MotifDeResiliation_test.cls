/**
* @author: Jacques Akiki -EI Technologies
* @date:27/06/2019
* @description: Test Class for LC53_MotifDeResiliation
*/
@isTest
public class LC53_MotifDeResiliation_test {
    
    @isTest
    static void  LC35_PopUpOnEvolutionCloseTest() 
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
        
        Contrat__c cont = new Contrat__c(name='TEST');
        cont.NomPartenaire__c = a1.id;
        insert cont;
        
        Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.AccountId=a1.Id;
        myOpp.closeDate=Date.today();
        myOpp.ContratOrigine__c=cont.id;
        myOpp.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        myOpp.Type_pers__c = Label.Renouvellement;
        myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        insert myOpp;
        
        Test.startTest();
        
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
            
         OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c= conta.id);
        OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c= cont1.id);
        insert new List<OpportuniteContact__c> {oc,oc1};
        /*Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
        myFDS1.name = 'test1';
        myFDS1.Opportunit_commerciale__c = myOpp.id;
        insert myFDS1;*/
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c myFiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
        myFiche.P6MbOf__c=12;
        myFiche.P6CaOf__c=11;
        myFiche.OffreA1P1VentesServices__c = 0;
        update myFiche;
        
        myOpp.StageName = Label.PV_Realisation;
        myOpp.Statut__c = Label.OppBeforeUp_gagne;
        myOpp.Duree_minimale_estimee__c = 2;
        myOpp.Societevente__c = a2.id;
        myOpp.ZZZ_TECH_RealiseDuChemin__c = true;
        update myOpp;
        
        LC53_MotifDeResiliation.getContratdOrigine(myOpp.Id);
        LC53_MotifDeResiliation.GetMotifsDeFermeture(myOpp.Id);
        LC53_MotifDeResiliation.updateContratdOrigine(cont, myOpp.Id);
        LC53_MotifDeResiliation.LoadDependantConditionValues('Refus reconduction tacite');
        LC53_MotifDeResiliation.QueryingOpportunityFields(myOpp.Id);
        Test.stopTest();
        
    }
}