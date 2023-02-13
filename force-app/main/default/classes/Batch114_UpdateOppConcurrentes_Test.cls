/*--------------------------------------------------------------------------------------------------------------------------
   Author: Jimmy Khalil
   Company: EI-Technologies
   Description: Test Class for Batch114_UpdateOppConcurrentes
   Coverage: 89%
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   03/02/2022    Jimmy Khalil   Creation
   --------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch114_UpdateOppConcurrentes_Test {
    // method used as test method to cover the Apex Controller LC34_RectoValorisation_Controller
    @isTest
    static void  testBatch(){
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

            Contrat__c c2 = new Contrat__c();
            c2.NomPartenaire__c = a1.Id;

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

            insert new List<Opportunity> {myOpp};

            LC35_PopUpOnEvolutionClose_Controller.getMessage(myOpp.id);

            /*Fiche_de_synthese__c fds = new Fiche_de_synthese__c();
            fds.Opportunit_commerciale__c = myOpp.Id;
            insert fds;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.SaisieRefP1VentesServices__c=12;
                fds.OffreA1P1VentesServices__c=13;
                fds.tech_previous_changes__c = null;
            }
            Update listFDS;
            contact mycontact = testUtils.createContact('test 4', a1.Id, null);
            insert mycontact;

            OpportuniteContact__c oc = new OpportuniteContact__c(contact__c = mycontact.id, opportunite__c = myOpp.id);
            insert oc;
            Test.startTest();

            LC35_PopUpOnEvolutionClose_Controller.duplicate(myOpp.id);
            Test.stopTest();
            Id BatchId = Database.executeBatch(new Batch114_UpdateOppConcurrentes());
        }
    }

}