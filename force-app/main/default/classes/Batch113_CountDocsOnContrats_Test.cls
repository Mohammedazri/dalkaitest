/**
* @author: Jimmy Khalil -EI Technologies
* @date: 09/06/2021
* @description: Test Class for "Batch113_CountDocsOnContrats" 
*/
@isTest
public class Batch113_CountDocsOnContrats_Test {
    static testMethod void testDocIncrement()
    {
        
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;
        
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.Name='testtingg ';
        c1.DureeInitialeContrat__c = 1;
        c1.DatePriseEffet__c = date.today();
        
        Contrat__c c2= new Contrat__c();
        c2.NomPartenaire__c=a1.Id;
        c2.Name='testtingg ';
        c2.DureeInitialeContrat__c = 1;
        c2.DatePriseEffet__c = date.today();
        
        Contrat__c c3= new Contrat__c();
        c3.NomPartenaire__c=a1.Id;
        c3.Name='testtingg ';
        c3.DureeInitialeContrat__c = 1;
        c3.DatePriseEffet__c = date.today();
        
        insert new List<Contrat__c> {c1,c2,c3};
            
            List<RecordType> recTypeList = [select Id from RecordType where DeveloperName=:Label.DocumentContractuelNonSync];
        
        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.RecordTypeId = recTypeList[0].id;
        DC1.NatureDocument__c = 'DOC01';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = c1.Id;
        DC1.DatePriseEffet__c = date.today();
        DC1.DateSignature__c = date.today();
        
        Document_Contractuel__c DC2 = new Document_Contractuel__c();
        DC2.RecordTypeId = recTypeList[0].id;
        DC2.NatureDocument__c = 'DOC03';
        DC2.StatutDocument__c = 'ACT';
        DC2.Contrat__c = c1.Id;
        DC2.DatePriseEffet__c = date.today();
        DC2.DateSignature__c = date.today();
        
        Document_Contractuel__c DC3 = new Document_Contractuel__c();
        DC3.RecordTypeId = recTypeList[0].id;
        DC3.NatureDocument__c = 'DOC01';
        DC3.StatutDocument__c = 'ACT';
        DC3.Contrat__c = c2.Id;
        DC3.DatePriseEffet__c = date.today();
        DC3.DateSignature__c = date.today();
        
        insert new List<Document_Contractuel__c> {DC1,DC2,DC3};
            
            Test.startTest();
        Batch113_CountDocsOnContrats rdd = new Batch113_CountDocsOnContrats();
        Database.executeBatch(rdd);
        Test.stopTest();
    }
}