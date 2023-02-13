/**
* This class contains unit tests for validating the behavior of Apex classe Batch71_DeleteOppContratOrigine
*/
@isTest
public class Batch71_DeleteOppContratOrigine_TEST {
    @isTest
    static void  Batch71_DeleteOppContratOrigineTEST() 
    {
        // query the profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        // create the user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.BypassValidationRules__c =true;//add bypass
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.Bypass_Triggers__c ='AP09_Opportunity';
        u2.BypassFilters__c = true;
        insert u2;// insert the user
        
        // run test as the created user 
        System.runAs(u2) 
        {
            // Create an Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            
            // Create and insert Contrat
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            opportunity myOpp1 = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp1.accountId=a1.Id;
            myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp1.Statut__c = 'En cours';
            myOpp1.StageName = 'Piste';
            myOpp1.Type_pers__c =Label.Renouvellement;
            myOpp1.Annee_de_signature__c='2017';
            myOpp1.Duree_minimale_estimee__c = 2;
            myOpp1.ContratOrigine__c=c1.Id;
            
            // Create an Opportunity 
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Statut__c = 'En cours';
            myOpp.StageName = 'Piste';
            myOpp.Type_pers__c =Label.PV_Opp_Type_Nouveau;
            myOpp.Annee_de_signature__c='2017';
            myOpp.Duree_minimale_estimee__c = 2;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.OpportuniteDorigine__c = myOpp1.Id;
            insert new list<opportunity>  {myOpp1,myOpp};
            /*Fiche_de_synthese__c fds = new Fiche_de_synthese__c();
            fds.Opportunit_commerciale__c = myOpp.Id;
            insert fds;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.SaisieRefP1VentesServices__c=12;
                fds.OffreA1P1VentesServices__c=13;
            }
            Update listFDS;
            
            Test.startTest(); 
            Id BatchId = Database.executeBatch(new Batch71_DeleteOppContratOrigine());
            Test.stopTest();
        }
    }
}