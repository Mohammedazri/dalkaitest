@isTest
public class ScheduledUpdateOpportunityFDS_Test{
    public static testmethod void test(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        System.runAs(u2) {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            myaccount.Immatriculation_Legale__c = 'test1';
            myaccount.Type_immatriculation__c = 'RCS';
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.CreerNouveauProjetCommercial__c = true;
            myOpp.Amount=3;
            myOpp.Type = 'Renouvellement';         
            insert myOpp;
            
            /*Fiche_de_synthese__c FDS = new Fiche_de_synthese__c();
            FDS.Opportunit_commerciale__c = myOpp.id;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c FDS= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            FDS.P1MbOf__c = 10;
            FDS.P2MbOf__c = 10;
            FDS.P3MbOf__c = 10;
            FDS.P4MbOf__c=10;
            FDS.P1CaOf__c = 10;
            FDS.P2CaOf__c = 10;
            FDS.P3CaOf__c = 10;
            FDS.P4CaOf__c=10; 
            update FDS;
            //myOpp.Amount = 3;
            //myOpp.MargeBruteOffre__c = 3;
            //update myOpp;
            
            // This test runs a scheduled job at midnight Sept. 3rd. 2022
            String CRON_EXP = '0 0 0 3 9 ? 2022';
            // Schedule the test job
            String jobId = System.schedule('ScheduledUpdateOpportunityFDSTest', CRON_EXP, new ScheduledUpdateOpportunityFDS());
            Test.stopTest();        
        }
    }
}