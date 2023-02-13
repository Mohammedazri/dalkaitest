/**
* @author: Charbel Khoury Hanna
* @date: 26/11/2020
* @description: Test Class for "Batch103_OppHeureP2Ecart" 
*/
@isTest
public class Batch103_OppHeureP2Ecart_Test {
    static testMethod void test()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        //u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2)
        {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            insert myaccount;
            
            Opportunity myOpp = TestUtils.createOpportunity('test',date.today(),'Gagnée','Qualification');
            myOpp.Type_pers__c = Label.Evolution;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            insert myOpp;
            
            /*Fiche_de_synthese__c FDS = new Fiche_de_synthese__c();
            FDS.Opportunit_commerciale__c = myOpp.id;
			insert FDS;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.SaisieRefP1VentesServices__c=12;
                fds.OffreA1P1VentesServices__c=13;
            }
            Update listFDS;
            
            Test.startTest();
            Batch103_OppHeureP2Ecart Batch12 = new Batch103_OppHeureP2Ecart();
            Id batchId = Database.executeBatch(Batch12);
            Test.stopTest();
        }
    }
}