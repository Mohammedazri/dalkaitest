/**
* @author: Jimmy Khalil
* @date: 17/11/2021
* @description: Test Class for "Batch121_MAJCaMbP6Opp" 
*/
@isTest
public class Batch121_MAJCaMbP6Opp_Test {
    
    @istest
    static void testCreationOpp() 
    {
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        myOpp.EstOpportuniteMere__c = true;
        myOpp.NatureOpportunitMere__c = Label.AP16_National;
        insert myOpp;
        
        List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        /*Fiche_de_synthese__c Fiche= new Fiche_de_synthese__c();
        Fiche.Name='testFiche1';
Fiche.Opportunit_commerciale__c=myOpp.Id;*/
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c Fiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
        Fiche.OffreA1P1VentesServices__c=5;
        Fiche.OffreA1P2VentesServices__c=10;
        Fiche.OffreA1P3VentesServices__c=15;
        Fiche.OffreA1P4VentesServices__c=20;
        listFDS.add(Fiche);
        Update listFDS;
        
        Batch121_MAJCaMbP6Opp batch121 = new Batch121_MAJCaMbP6Opp();
        database.executeBatch(batch121);
    }
     @istest
    static void testCreationOpp1() 
    {
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        myOpp.EstOpportuniteMere__c = true;
        myOpp.NatureOpportunitMere__c = Label.AP16_National;
        insert myOpp;
        
        List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        /*Fiche_de_synthese__c Fiche= new Fiche_de_synthese__c();
        Fiche.Name='testFiche1';
Fiche.Opportunit_commerciale__c=myOpp.Id;*/
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c Fiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
        Fiche.OffreA1P1VentesServices__c=5;
        Fiche.OffreA1P2VentesServices__c=10;
        Fiche.OffreA1P3VentesServices__c=15;
        Fiche.OffreA1P4VentesServices__c=20;
        listFDS.add(Fiche);
        Update listFDS;
        
        Batch121_MAJCaMbP6Opp batch121 = new Batch121_MAJCaMbP6Opp();
        database.executeBatch(batch121);
    }
}