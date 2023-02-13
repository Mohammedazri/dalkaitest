@isTest
private class Batch06_UpdateOpportunityWithFDS_Test {
    static testmethod void test() { 
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        System.runAs(u2) {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            insert myaccount;
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.CreerNouveauProjetCommercial__c = true;
            myOpp.Amount=3;
            myOpp.Type = 'Renouvellement';
            myOpp.Statut__c = 'En cours';
            insert myOpp;
            
            /*Fiche_de_synthese__c FDS = new Fiche_de_synthese__c();
FDS.Opportunit_commerciale__c = myOpp.id;
FDS.P1MbOf__c = 10;
FDS.P2MbOf__c = 10;
FDS.P3MbOf__c = 10;
FDS.P4MbOf__c=10;
FDS.P1CaOf__c = 10;
FDS.P2CaOf__c = 10;
FDS.P3CaOf__c = 10;
FDS.P4CaOf__c=10; 
insert FDS;*/
            //myOpp.Amount = 3;
            //myOpp.MargeBruteOffre__c = 3;
            //update myOpp;
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c FDS:listFDS){
                FDS.P1MbOf__c = 10;
                FDS.P2MbOf__c = 10;
                FDS.P3MbOf__c = 10;
                FDS.P4MbOf__c=10;
                FDS.P1CaOf__c = 10;
                FDS.P2CaOf__c = 10;
                FDS.P3CaOf__c = 10;
                FDS.P4CaOf__c=10; 
            }
            update listFDS;
            Test.startTest();
            Batch06_UpdateOpportunityWithFDS Batch06 = new Batch06_UpdateOpportunityWithFDS();
            Id batchId = Database.executeBatch(Batch06);
            Test.stopTest();}
    }
    
}