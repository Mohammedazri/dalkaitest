/** 
* @author Charbel Khoury Hanna
* @date 04/02/2022
* @Test Class for Batch117_UpdateTitreScan
*/
@isTest
public class Batch117_UpdateTitreScan_Test {
    
    @testSetup static void setup() {
        account myaccount= testUtils.createAccount('TEST1', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        opportunity myOpp = testUtils.createOpportunity ('testContrat', date.today(),Label.OpportunityStatusEnCours, 'Piste');
        myOpp.accountId=myaccount.Id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Type_pers__c=Label.PV_Evolution;
        myOpp.Annee_de_signature__c='2017';
        insert myOpp;
        Contrat__c contrat = new Contrat__c();
        contrat.Name = 'TESTCONTRAT';
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        contrat.TypeContrat__c = 'IND';
        contrat.OpportuniteCommerciale__c = myOpp.id;
        contrat.NomPartenaire__c = myaccount.id;
        contrat.DatePriseEffet__c = system.today();
        insert contrat;
    }
    
    @isTest static void test()
    {
        Contrat__c contrat = [SELECT id FROM Contrat__c limit 1];  
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body'); 
        ContentVersion cv1 = new ContentVersion();
        cv1.title =  'test';      
        cv1.PathOnClient ='test';           
        cv1.VersionData =beforeblob;
        insert cv1;
        
        Document_Contractuel__c doc1 = new Document_Contractuel__c();
        doc1.ReferenceDocument__c = 'test alain';
        doc1.StatutSynchronisation__c = false;
        doc1.NatureDocument__c = 'DOC01';
        doc1.DatePriseEffet__c = system.today();
        doc1.TitreDocument__c ='test1';
        doc1.DateSignature__c = system.today();
        doc1.Contrat__c = contrat.id;
        doc1.MajConditionsDuree__c = true;
        doc1.NumeroPiece__c = '123';
        doc1.NiveauDeConfidentialite__c = 'DOC_C02';
        insert doc1;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = doc1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        Database.executeBatch(new Batch117_UpdateTitreScan());
    }
}