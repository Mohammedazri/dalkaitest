/**
* @author: Jacques Akiki -EI Technologies
* @date: 09/09/2019
* @description: Test class of LC61_TauxRenouvellement_Cont
*/
@istest
public class LC61_TauxRenouvellement_Cont_Test {
@isTest
    static void testmeth()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.Nom_region__c = 'Test';
        u1.Nom_agence__c = 'Test';
        u1.BypassFilters__c = true;
        u1.BypassValidationRules__c = true;
        u1.BypassProcessBuilder__c = true;
        insert u1;
        System.runAs(u1) {
            
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            //myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
          
            
            List<Opportunity> listOpp = new List<Opportunity>();
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.Renouvellement;
            myOpp.StageName=Label.LC28_Realise;
            myOpp.Statut__c =Label.OppBeforeUp_gagne;
            myOpp.Annee_de_signature__c = String.valueOf(System.Today().year());
            myOpp.OwnerId = u1.id;
            listOpp.add(myOpp);
            
            opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp1.Type_pers__c=Label.Renouvellement;
            myOpp1.StageName=Label.LC28_Realise;
            myOpp1.Statut__c =Label.LC35_Statut;
            myOpp1.Annee_de_signature__c = String.valueOf(System.Today().year());
            myOpp1.OwnerId = u1.id;
            listOpp.add(myOpp1);
            insert listOpp;
            
            Test.startTest();
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            List<Fiche_de_synthese__c> listFDS = [Select id From Fiche_de_synthese__c];
            Fiche_de_synthese__c Fiche= listFDS[0];
            Fiche.OffreA1P1VentesServices__c=5;
            Fiche.OffreA1P2VentesServices__c=10;
            Fiche.OffreA1P3VentesServices__c=15;
            Fiche.OffreA1P4VentesServices__c=20;
            Fiche_de_synthese__c Fiche1 = listFDS[1];
            Fiche1.OffreA1P2VentesServices__c=5;
            Fiche1.OffreA1P3VentesServices__c=8;
            
            update listFDS;
            
            LC61_TauxRenouvellement_Cont.GetSegementPicklistValues();
            LC61_TauxRenouvellement_Cont.calculTauxdeRenouvellementGlobal('N/A');
            LC61_TauxRenouvellement_Cont.calculTauxdeRenouvellementGlobal('TEST');
            LC61_TauxRenouvellement_Cont.calculTauxdeRenouvellementRegion('N/A');
            LC61_TauxRenouvellement_Cont.calculTauxdeRenouvellementAgence('N/A');
            LC61_TauxRenouvellement_Cont.calculTauxdeRenouvellementUtilisateur('N/A');
            LC61_TauxRenouvellement_Cont.calculTauxdeRenouvellementUtilisateur('TEST');
            Test.stopTest();
    }
    }
}