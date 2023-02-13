/**
* @author: Charbel Khoury Hanna - EIT Mena
* @date: 05/25/2022
* @description: Test Class for AP111_DocumentContractuelUnicity 
*/

@isTest
public class AP111_DocumentContractuelUnicity_Test {
    
    static testMethod void test()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            List<Account> listAcc = new list<Account>();
            //create and insert Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            listAcc.add(a1);
            account a2=testUtils.createAccount('testAccount-SDV', 'Lebanon', 'Privé');
            a2.BillingCity='test';
            a2.BillingPostalCode='112';
            a2.Code_NACE__c = '222';
            a2.SIRET__c = '255236';
            a2.Siege_social_partenaire__c = true;
            a2.StatutPartenaire__c = Label.WS11_OUV;
            a2.Categorie_partenaire__c = 'DLK';
            listAcc.add(a2);
            insert listAcc;
            
            //create and insert Contract
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            c1.DatePriseEffet__c= date.today();
            insert c1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.id;
            myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
            myOpp.Societevente__c = a2.id;
            myOpp.Type_pers__c = Label.Evolution;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            insert myOpp;
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
         Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            Fiche1.OffreA1P2VentesServices__c = 100;
            update Fiche1;
            
            /*Fiche_de_synthese__c fds =  testUtils.createFDS();
            fds.Opportunit_commerciale__c = myOpp.Id;
            insert fds;*/
            
            Contact cont = testUtils.createContact('Smith', a1.id, null);
            insert cont;
            
            OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c= cont.id);
            insert oc;
            
            Test.startTest();
            AP25_OpportunityAvntRealise.firstRun =true;
            myOpp.Statut__c=Label.OppBeforeUp_gagne;
            myOpp.Duree_minimale_estimee__c = 2;  
            myOpp.DureeProlongationSupp__c = 5;
            myOpp.stageName = Label.PV_Realisation;
            myOpp.ZZZ_TECH_RealiseDuChemin__c = true; 
            Update myOpp;
            
            Document_Contractuel__c DC1 = new Document_Contractuel__c();
            DC1.TitreDocument__c = 'test1';
            DC1.NatureDocument__c = 'DOC01';
            DC1.StatutDocument__c = 'ACT';
            DC1.Contrat__c = c1.Id;
            DC1.DatePriseEffet__c = date.today();
            DC1.DateSignature__c = date.today();
            DC1.MajConditionsDuree__c = true;
            DC1.NiveauDeConfidentialite__c = 'DOC_C02';
            insert DC1;
            
            Document_Contractuel__c DC2 = new Document_Contractuel__c();
            DC2.TitreDocument__c = 'test2';
            DC2.NatureDocument__c = 'DOC05';
            DC2.StatutDocument__c = 'ACT';
            DC2.Contrat__c = c1.Id;
            DC2.DatePriseEffet__c = date.today();
            DC2.DateSignature__c = date.today();
            DC2.OpportuniteRattachee__c = myOpp.Id;
            DC2.MajConditionsDuree__c = true;
            DC2.NiveauDeConfidentialite__c = 'DOC_C02';
            insert DC2;
            
            DC2.NatureDocument__c = 'DOC10';
            update DC2;
            Test.stopTest();
        }
    }
}