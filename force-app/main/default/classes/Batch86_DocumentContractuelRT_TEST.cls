/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 27/07/2020
* @description: Test Class for "Batch86_DocumentContractuelRT" 
*/
@isTest
public class Batch86_DocumentContractuelRT_TEST {
    static testMethod void testDocRecordType()
    {
        Account acc =  new Account(Name= 'test', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
        acc.Type_immatriculation__c = 'RCS';
        acc.Immatriculation_Legale__c = '12345';
        acc.StatutPartenaire__c = 'OUV';
        insert acc;
       
        Contrat__c contrat2 = new Contrat__c();
        contrat2.Name = 'testContrat2';
        contrat2.NomPartenaire__c = acc.Id;
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        contrat2.TypeContrat__c = 'IND';
        contrat2.DatePriseEffet__c = date.today();
        insert contrat2;
        
        List<RecordType> recTypeList = [select Id from RecordType where DeveloperName=:Label.DocumentContractuelSync];
        
        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.RecordTypeId = recTypeList[0].id;
        DC1.TitreDocument__c = 'test1';
        DC1.NumeroPiece__c='123';
        DC1.NatureDocument__c = 'DOC01';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = contrat2.Id;
        DC1.DatePriseEffet__c = date.today();
        DC1.DateSignature__c = date.today();
        insert DC1;
        
        test.startTest();
        Id batchJobId = Database.executeBatch(new Batch86_DocumentContractuelRT(), 200);
        test.stopTest();
    }
}