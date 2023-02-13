@isTest
public class Batch03_UpdateContratWithFDS_Test {
    
    @istest
    static void testBatch_UpdateContratWithFDS(){
        Account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        
        Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
        myOpp.AccountId=myaccount.Id;
        myOpp.Amount=3;
        myOpp.statut__c ='En cours';
        myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        insert myOpp;
        
        Contrat__c mycontrat= new Contrat__c(Name='testContrat');
        mycontrat.OpportuniteCommerciale__c=myOpp.Id;
        mycontrat.NomPartenaire__c=myaccount.Id;
        mycontrat.ReconductionFaitAutorisee__c = true;
        
        insert mycontrat;
        
        /*Fiche_de_synthese__c myfds= new Fiche_de_synthese__c(Name='testfds');
myfds.Opportunit_commerciale__c=myOpp.Id;
myfds.P1CaOf__c=2;
myfds.P2CaOf__c=2;
myfds.P3CaOf__c=2;
myfds.P4CaOf__c=2;
myfds.P6CaOf__c=2;
myfds.P1MbOf__c=2;
myfds.P2MbOf__c=2;
myfds.P3MbOf__c=2;
myfds.P4MbOf__c=2;
myfds.P6MbOf__c=2;
myfds.P1CaRef__c=2;
myfds.P2CaRef__c=2;
myfds.P3CaRef__c=2;
myfds.P4CaRef__c=2;
myfds.P6CaRef__c=2;
myfds.P1MbRef__c=2;
myfds.P2MbRef__c=2;
myfds.P3MbRef__c=2;
myfds.P4MbRef__c=2;
myfds.P6MbRef__c=2;
myfds.P1Energie__c='2';
myfds.P2Services__c='2';
myfds.P3GarantieTotale__c='2';
myfds.P4Financement__c='2';
myfds.P6Travaux__c='2';
myfds.SousTotP1234__c='2';
myfds.BklgHorsP6__c='2';
myfds.BklgAvecP6__c='2';
myfds.ValorisationMainOeuvre__c='ThoEtude';
insert myfds;*/
        
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c myfds= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
        myfds.P1CaOf__c=2;
        myfds.P2CaOf__c=2;
        myfds.P3CaOf__c=2;
        myfds.P4CaOf__c=2;
        myfds.P6CaOf__c=2;
        myfds.P1MbOf__c=2;
        myfds.P2MbOf__c=2;
        myfds.P3MbOf__c=2;
        myfds.P4MbOf__c=2;
        myfds.P6MbOf__c=2;
        myfds.P1CaRef__c=2;
        myfds.P2CaRef__c=2;
        myfds.P3CaRef__c=2;
        myfds.P4CaRef__c=2;
        myfds.P6CaRef__c=2;
        myfds.P1MbRef__c=2;
        myfds.P2MbRef__c=2;
        myfds.P3MbRef__c=2;
        myfds.P4MbRef__c=2;
        myfds.P6MbRef__c=2;
        myfds.P1Energie__c='2';
        myfds.P2Services__c='2';
        myfds.P3GarantieTotale__c='2';
        myfds.P4Financement__c='2';
        myfds.P6Travaux__c='2';
        myfds.SousTotP1234__c='2';
        myfds.BklgHorsP6__c='2';
        myfds.BklgAvecP6__c='2';
        myfds.ValorisationMainOeuvre__c='ThoEtude';
        update myfds; 
        
        Test.startTest();
        Batch03_UpdateContratWithFDS testBatch=new Batch03_UpdateContratWithFDS();
        DataBase.executeBatch(testBatch);
        Test.stopTest();
    }
}