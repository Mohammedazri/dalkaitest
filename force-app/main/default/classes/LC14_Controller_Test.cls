/**
* This class contains unit tests for validating the behavior of Apex classes LC14_ContratValorisationOffre_Controller
*/
@isTest
public class LC14_Controller_Test {
    
    @isTest
    static void LC14_ContratValorisationOffreTest(){
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.BypassFilters__c =true;
        u1.BypassValidationRules__c = true;
        insert u1;
        
        system.runAs(u1)
        {
            Test.startTest(); 
            account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.Type = 'PUB';
            insert myaccount;
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=myaccount.Id;
            //myOpp.Record_type__c=Label.OppType_EvRen;
            myOpp.Statut__c='En cours';
            insert myOpp;
            /*Fiche_de_synthese__c Fiche1= New Fiche_de_synthese__c();
            Fiche1.Name='testFiche1';
            Fiche1.Opportunit_commerciale__c=myOpp.Id;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
         Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            Fiche1.P1CaOf__c=8;
            Fiche1.P6MbOf__c=12;
            Fiche1.P6CaOf__c=11;
            update Fiche1;
            contrat__c mycontrat = new contrat__c();
            mycontrat.OpportuniteCommerciale__c=myOpp.Id;
            mycontrat.NomPartenaire__c=myaccount.Id;
            myContrat.ReconductionFaitAutorisee__c  = false;
            insert mycontrat;
            LC14_ContratValorisationOffre_Controller.getCurrentObject(myContrat.Id);
            Test.stopTest();
        }
    } 
}