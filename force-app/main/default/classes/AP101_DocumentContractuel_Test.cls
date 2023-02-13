/**
* @author: Charbel Khoury Hanna
* @date: 09/27/2021
* @description: Test Class for Class AP101_DocumentContractuel
*/
@isTest
public class AP101_DocumentContractuel_Test {

    @isTest
    static void test()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        insert u2;
        
        System.runAs(u2) 
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
            contrat2.DureeInitialeContrat__c = 1;
            contrat2.DatePriseEffet__c = System.Today() -2;
            contrat2.NombreReconductionsPassees__c = 1;
            contrat2.DureeReconduction__c = 1;
            contrat2.NombreReconductionsAutorisees__c = 1;
            contrat2.DureeProlongationTotale__c = 1;
            insert contrat2;
            
            Document_Contractuel__c DC1 = new Document_Contractuel__c();
            DC1.TitreDocument__c = 'test1';
            DC1.NumeroPiece__c='123xcv';
            DC1.NatureDocument__c = 'DOC02';
            DC1.StatutDocument__c = 'ACT';
            DC1.Contrat__c = contrat2.Id;
            DC1.DateSignature__c = Date.today();
            DC1.DatePriseEffet__c = Date.Today();
            DC1.NiveauDeConfidentialite__c = 'DOC_C02';
            insert DC1;

            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
            ContentVersion cv = new ContentVersion();
            cv.title = 'test content';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;          
            insert cv;
            
            test.startTest();
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=DC1.id;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=documents[0].Id;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink;
            delete contentlink;
            test.stopTest();
        }
    }
}