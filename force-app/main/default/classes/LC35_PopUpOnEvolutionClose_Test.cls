/**
 * This class contains unit tests for validating the behavior of Apex classe LC35_PopUpOnEvolutionClose_Controller
 */
@isTest
public class LC35_PopUpOnEvolutionClose_Test {
    // method used as test method to cover the Apex Controller LC34_RectoValorisation_Controller
    @isTest
    static void  LC35_PopUpOnEvolutionCloseTest(){ 
        // query the profil
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId];
        // create the user
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c = true;//add bypass
        u2.Bypass_Triggers__c = 'AP09_Opportunity';
        u2.BypassFilters__c = true;
        insert u2;// insert the user

        // run test as the created user
        System.runAs(u2){
            // Create an Account
            account a1 = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity = 'test';
            a1.BillingPostalCode = '111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;

            // Create and insert Contrat
            Contrat__c c1 = new Contrat__c();
            c1.NomPartenaire__c = a1.Id;
            c1.TypeReconduction__c = 'RNUL';
            c1.DatePriseEffet__c = System.Today() -2;
            c1.DureeInitialeContrat__c = 1;
            c1.NombreReconductionsPassees__c = 1;
            c1.DureeReconduction__c = 1;
            c1.NombreReconductionsAutorisees__c = 1;
            c1.DureeProlongationTotale__c = 1;
            
            Contrat__c c2 = new Contrat__c();
            c2.NomPartenaire__c = a1.Id;
            c2.TypeReconduction__c = 'RNUL';
            c2.DatePriseEffet__c = System.Today() -2;
            c2.DureeInitialeContrat__c = 1;
            c2.NombreReconductionsPassees__c = 1;
            c2.DureeReconduction__c = 1;
            c2.NombreReconductionsAutorisees__c = 1;
            c2.DureeProlongationTotale__c = 1;

            insert new List<Contrat__c> {c1, c2};

            // Create an Opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), null, 'Piste');
            myOpp.accountId = a1.Id;
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.StageName = 'Réalisation';
            myOpp.Type_pers__c = Label.PV_Opp_Type_Nouveau;
            myOpp.Annee_de_signature__c = '2017';
            myOpp.Duree_minimale_estimee__c = 2;
            myOpp.ContratOrigine__c = c1.Id;

            opportunity myOpp1 = testUtils.createOpportunity ('testOpp', date.today(), null, 'Piste');
            myOpp1.accountId = a1.Id;
            myOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp1.StageName = 'Réalisation';
            myOpp1.Type_pers__c = Label.PV_Opp_Type_Nouveau;
            myOpp1.Annee_de_signature__c = '2017';
            myOpp1.ContratOrigine__c = c2.Id;
            insert new List<Opportunity> {myOpp, myOpp1};

            LC35_PopUpOnEvolutionClose_Controller.getMessage(myOpp.id);

            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            /*Fiche_de_synthese__c fds = new Fiche_de_synthese__c();
            fds.Opportunit_commerciale__c = myOpp.Id;
            insert fds;*/
            
            contact mycontact = testUtils.createContact('test 4', a1.Id, null);
            insert mycontact;

            OpportuniteContact__c oc = new OpportuniteContact__c(contact__c = mycontact.id, opportunite__c = myOpp.id);
            insert oc;
            Test.startTest();

            LC35_PopUpOnEvolutionClose_Controller.getMessage(myOpp.id);
            LC35_PopUpOnEvolutionClose_Controller.duplicate(myOpp.id);
            LC35_PopUpOnEvolutionClose_Controller.duplicate(myOpp1.id);
            LC35_PopUpOnEvolutionClose_Controller.getMessage(myOpp.id);
            LC35_PopUpOnEvolutionClose_Controller.cancel(myOpp.id);
            LC35_PopUpOnEvolutionClose_Controller.cancelConcurrente(myOpp.id);
            LC35_PopUpOnEvolutionClose_Controller.getOppConcurente(myOpp.id);
            LC35_PopUpOnEvolutionClose_Controller.getOppNow(myOpp.id);
            Test.stopTest();
        }
    }

}