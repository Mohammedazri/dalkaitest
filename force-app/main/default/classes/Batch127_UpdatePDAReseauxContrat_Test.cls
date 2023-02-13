/**
* @author Charbel Khoury Hanna - EIT Mena
* @date 04/01/2022
* @description Test Class Batch127_UpdatePDAReseauxContrat
*/

@isTest
public class Batch127_UpdatePDAReseauxContrat_Test {
    
    @isTest
    static void  testBatch(){
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),'En cours', 'Piste');
            myOpp2.AccountId=myaccount.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.Amount=3;
            myOpp2.Type_pers__c = Label.PV_Opp_Type_Nouveau;
            myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp2.EstOpportuniteMere__c = true;
            myOpp2.NatureOpportunitMere__c = 'National';
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

            Contrat__c mycontrat= new Contrat__c(Name='testContrat');
            mycontrat.OpportuniteCommerciale__c=myOpp.Id;
            mycontrat.NomPartenaire__c=myaccount.Id;
            insert mycontrat;
            
            Id BatchId = Database.executeBatch(new Batch127_UpdatePDAReseauxContrat());
        }
    }
    
}