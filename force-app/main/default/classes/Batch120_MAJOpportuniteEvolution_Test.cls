/**
* @author: Charbel Khoury Hanna
* @date: 25/08/2021
* @description: Test Class for "Batch120_MAJOpportuniteEvolution" 
*/
@isTest
public class Batch120_MAJOpportuniteEvolution_Test {
    
    @istest
    static void testCreationOpp() 
    {
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        myOpp.EstOpportuniteMere__c = true;
        myOpp.NatureOpportunitMere__c = Label.AP16_National;
        insert myOpp;
        
        Batch120_MAJOpportuniteEvolution batch120 = new Batch120_MAJOpportuniteEvolution();
        database.executeBatch(batch120);
    }
}