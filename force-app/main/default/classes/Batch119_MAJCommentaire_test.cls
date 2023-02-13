/**
* @author: Jacques Akiki
* @date: 10/08/2021
* @description: Test Class for "Batch118_OppRT_test" 
*/
@isTest
public class Batch119_MAJCommentaire_test {    
    static testMethod void test_OppFields()
    {
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        List<Opportunity> listOpp = new list<Opportunity>();
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        myOpp.Description = 'test';
        myOpp.Commentaire__c = 'test1';
        listOpp.add(myOpp);
        opportunity myOpp1 = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.accountId=a1.Id;
        myOpp1.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp1.Duree_minimale_estimee__c = 2;  
        myOpp1.Description = 'test';
        myOpp1.Type_pers__c =Label.Renouvellement;
        listOpp.add(myOpp1);
        opportunity myOpp2 = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp2.accountId=a1.Id;
        myOpp2.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        myOpp2.Duree_minimale_estimee__c = 2;  
        myOpp2.Type_pers__c =Label.Renouvellement;
        myOpp2.EstOpportuniteMere__c = true;
        myOpp2.NatureOpportunitMere__c = 'SPU';
        myOpp2.Commentaire__c = 'test1';
        listOpp.add(myOpp2);
        insert listOpp;
        Test.startTest();
        Id BatchId = Database.executeBatch(new Batch119_MAJCommentaire());
        Test.stopTest();
    }
}