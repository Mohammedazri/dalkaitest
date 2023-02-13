/**
* This class contains unit tests for validating the behavior of Apex classes LC12_ValorisationDeLOffre_Controller
*/
@isTest
public class LC12_ValorisationOffre_Controller_Test 
{
    @isTest
    static void LC12_ValorisationOffreTest() 
    {
        //query the profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create the user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.BypassValidationRules__c =true;//add bypass 
        u2.BypassFilters__c = true;
        insert u2;// insert the user
        
        // run test as the created user 
        System.runAs(u2) 
        {
            // Create an Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            insert a1;
            
            // Create an Opportunity 
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            //myOpp.Record_type__c=Label.OppType_EvRen;
            insert myOpp;
            
            // Create a fiche_de_synthese__c
            /*fiche_de_synthese__c myFiche=testUtils.CreateFDS();*/
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
         Fiche_de_synthese__c myFiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            
            //myFiche.Opportunit_commerciale__c=myOpp.Id;
            myFiche.OffreA1P1VentesServices__c=4;
            myFiche.OffreA1P2VentesServices__c=3;
            myFiche.OffreA1P3VentesServices__c=2;
            myFiche.OffreA1P4VentesServices__c=1;
            myFiche.OffreA1P6VentesServices__c=15;
            //myFiche.OffreA1P1MargeBruteSurCA__c=15;
            myFiche.SaisieRefP1VentesServices__c=15;
            //myFiche.SaisieRefP1MargeBruteSurCA__c=15;
            //myFiche.Name='test1';
            
            update myFiche;
            
            Test.startTest(); 
            // call the functions of the Class LC12_ValorisationDeLOffre_Controller
            Wrapper_FDSValOffre wrp1= LC12_ValorisationDeLOffre_Controller.LoadWrapperBudget(myFiche.Id);
            //Wrapper_FDSValOffre wrp2= LC12_ValorisationDeLOffre_Controller.LoadWrapperRealise(myFiche.Id);
            Wrapper_FDSValOffre wrp3= LC12_ValorisationDeLOffre_Controller.LoadWrapperSaisie(myFiche.Id);
            LC12_ValorisationDeLOffre_Controller.GetConditionDeReferencePicklistValues();
            LC12_ValorisationDeLOffre_Controller.GetConditionDeReferenceSelected(myFiche.Id);
            LC12_ValorisationDeLOffre_Controller.getConditionOfPicklist(myFiche.Id);
            
            //query the fields of the FDS that are used in the assert
            myFiche=[SELECT Id,OffreA1P1VentesServices__c,OffreA1P1MargeBrute__c,
                     OffreA1P2VentesServices__c,OffreA1P2MargeBrute__c,
                     OffreA1P3VentesServices__c,OffreA1P3MargeBrute__c,
                     OffreA1P4VentesServices__c,OffreA1P4MargeBrute__c,
                     OffreA1P6VentesServices__c,OffreA1P6MargeBrute__c
                     FROM fiche_de_synthese__c
                     WHERE id =:myFiche.ID];
            
            //Assert to check the proper functioning of the functions 
            //assert on the variables P1_Offre_MB and P1_Offre_CA
            System.assert(wrp1.P1_Offre_MB==myFiche.OffreA1P1MargeBrute__c);
            System.assert(wrp1.P1_Offre_CA==myFiche.OffreA1P1VentesServices__c);
            
            
            //assert on the variables P2_Offre_MB and P2_Offre_CA
            System.assert(wrp1.P2_Offre_MB==myFiche.OffreA1P2MargeBrute__c);
            System.assert(wrp1.P2_Offre_CA==myFiche.OffreA1P2VentesServices__c);
            
            
            //assert on the variables P3_Offre_MB and P3_Offre_CA
            System.assert(wrp1.P3_Offre_MB==myFiche.OffreA1P3MargeBrute__c);
            System.assert(wrp1.P3_Offre_CA==myFiche.OffreA1P3VentesServices__c);
            
            
            //assert on the variables P4_Offre_MB and P4_Offre_CA
            System.assert(wrp1.P4_Offre_MB==myFiche.OffreA1P4MargeBrute__c);
            System.assert(wrp1.P4_Offre_CA==myFiche.OffreA1P4VentesServices__c);
            
            
            //assert on the variables P6_Offre_MB and P6_Offre_CA
            System.assert(wrp1.P6_Offre_MB==myFiche.OffreA1P6MargeBrute__c);
            System.assert(wrp1.P6_Offre_CA==myFiche.OffreA1P6VentesServices__c);
            
            Test.stopTest();
        }
    }
}