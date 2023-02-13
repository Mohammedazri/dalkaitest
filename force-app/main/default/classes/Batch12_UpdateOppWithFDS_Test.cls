@isTest
public class Batch12_UpdateOppWithFDS_Test {
    
    static testmethod void test() { 
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        //u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.CreerNouveauProjetCommercial__c = true;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type='Nouveau';
            insert myOpp;
            
            
            /*Fiche_de_synthese__c FDS = new Fiche_de_synthese__c();
            FDS.Opportunit_commerciale__c = myOpp.id;
            FDS.OffreA1P4VentesServices__c = 10;
            insert FDS;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c myfds:listFDS){
                myfds.OffreA1P4VentesServices__c = 10;
            }
            update listFDS;
            
            Test.startTest();
            Batch12_UpdateOppWithFDS Batch12 = new Batch12_UpdateOppWithFDS();
            Id batchId = Database.executeBatch(Batch12);
            Test.stopTest();}
    }
}