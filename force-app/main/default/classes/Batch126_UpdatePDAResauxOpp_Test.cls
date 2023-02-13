/**
* @author Charbel Khoury Hanna - EIT Mena
* @date 28/03/2022
* @description Test Class Batch126_UpdatePDAResauxOpp
*/

@isTest
public class Batch126_UpdatePDAResauxOpp_Test {
    
    @isTest
    static void  testBatch(){
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.Immatriculation_Legale__c = 'test1';
        myaccount.Type_immatriculation__c = 'RCS';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),'Gagnée',Label.PV_Realisation);
            myOpp2.AccountId=myaccount.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.Amount=3;
            myOpp2.Type_pers__c = Label.PV_Opp_Type_Nouveau;
            myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp2.EstOpportuniteMere__c = true;
            myOpp2.NatureOpportunitMere__c = 'Réseau';
            myOpp2.StageName = Label.PV_Realisation;
            insert myOpp2;
            
            
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.Type_pers__c = Label.Opp_type_Renewal;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.OpportuniteMere__c = myOpp2.id;
            myOpp.NatureOpportunitMere__c = 'Réseau';
            insert myOpp;
            
            opportunity myOpp4 = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp4.AccountId=myaccount.Id;
            myOpp4.closeDate=Date.today();
            myOpp4.Amount=3;
            myOpp4.Type_pers__c = Label.PV_Opp_Type_Nouveau;
            myOpp4.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp4.OpportuniteMere__c = myOpp2.id;
            myOpp4.NatureOpportunitMere__c = 'Réseau';
            insert myOpp4;
            
            Id BatchId = Database.executeBatch(new Batch126_UpdatePDAResauxOpp());
        }
    }
    
}