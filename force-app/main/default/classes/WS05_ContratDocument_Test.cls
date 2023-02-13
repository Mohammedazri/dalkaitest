@isTest
public class WS05_ContratDocument_Test {
    @isTest
    public static void insertDocumentTest(){
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        user.BypassFilters__c = true;
        user.BypassValidationRules__c = true;
        insert user;
        
        system.runAs(user)
        {
            WS05_ContratDocument.document docToInsert1 = new WS05_ContratDocument.document();
            docToInsert1.listeDocuments = new WS05_ContratDocument.listeDocuments();
            docToInsert1.listeDocuments.document = new List<WS05_ContratDocument.Documents>();
            WS05_ContratDocument.Documents doc1 = new WS05_ContratDocument.Documents();
            doc1.numeroPiece = 'test';
            doc1.referenceDuree = true;
            doc1.natureDocument = 'test';
            doc1.origineDocument = 'test';
            doc1.referenceDocument = 'test';
            doc1.titreDocument = 'test';
            doc1.dateSignature = System.today();
            doc1.datePriseEffet = System.today();
            doc1.statutDocument = 'test';
            doc1.dateStockage = System.today();
            doc1.niveauConfidentialite = 'DOC_C02';
            doc1.commentaireDocument = 'test';
            doc1.avenants = new WS05_ContratDocument.Avenants();
            doc1.metadonnees = new WS05_ContratDocument.Metadonnees_document();
            doc1.metadonnees.creationDate = System.today();
            doc1.metadonnees.creationId = 'test';
            doc1.metadonnees.updateDate = System.today();
            doc1.metadonnees.updateId = 'test';
            doc1.metadonnees.validationDate = System.today();
            doc1.metadonnees.validationId = 'test';
            docToInsert1.listeDocuments.document.add(doc1);
            WS05_ContratDocument.Documents doc3 = new WS05_ContratDocument.Documents();
            docToInsert1.listeDocuments.document.add(doc3);
            WS05_ContratDocument.Documents doc2 = new WS05_ContratDocument.Documents();
            doc2.numeroPiece = 'test';
            doc2.referenceDuree = true;
            doc2.natureDocument = 'test';
            doc2.origineDocument = 'test';
            doc2.referenceDocument = 'test';
            doc2.titreDocument = 'test';
            doc2.dateSignature = System.today();
            doc2.datePriseEffet = System.today();
            doc2.statutDocument = 'test';
            doc2.dateStockage = System.today();
            doc2.avenants = new WS05_ContratDocument.Avenants();
            doc2.avenants.MAJConditionsDuree = true;
            doc2.avenants.MAJConditionsTechniques = true;
            doc2.avenants.MAJConditionsFacturation = true;
            doc2.avenants.ajoutPrestations = true;
            doc2.avenants.retraitPrestations = true;
            doc2.avenants.autresModifications = true;
            doc2.metadonnees = new WS05_ContratDocument.Metadonnees_document();
            doc2.metadonnees.updateDate = System.today();
            doc2.metadonnees.updateId = 'test';
            doc2.metadonnees.validationDate = System.today();
            doc2.metadonnees.validationId = 'test';
            docToInsert1.listeDocuments.document.add(doc2);
            WS05_ContratDocument.document docToInsert2 = new WS05_ContratDocument.document();
            docToInsert2.DKCodeContrat = '1234';
            test.startTest();
            Response resp1 = WS05_ContratDocument.insertContratDocument(docToInsert1);
            Response resp2 = WS05_ContratDocument.insertContratDocument(docToInsert2);
            test.stopTest();
        }
    }
    
    @isTest
    public static void insertDocumentTest1(){
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU1', 'testU1@testorg.com', 'testU1', p.Id, 'testU1@testorg.com');
        user.ReferentielId__c = 'test123';
        user.BypassFilters__c = true;
        user.BypassValidationRules__c = true;
        insert user;
        
        system.runAs(user)
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.Lieu_immatriculation_legale__c = 'test';
            a1.DKCodeSurPartenaire__c = 'test';
            insert a1;
            
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            c1.EstContratcadre__c = true;
            c1.ReconductionFaitAutorisee__c = true;
            c1.Name='testtingg';
            c1.DKCodeSurContrat__c = '1234';
            insert c1;
            
            
            WS05_ContratDocument.document docToInsert1 = new WS05_ContratDocument.document();
            docToInsert1.listeDocuments = new WS05_ContratDocument.listeDocuments();
            docToInsert1.listeDocuments.document = new List<WS05_ContratDocument.Documents>();
            WS05_ContratDocument.Documents doc1 = new WS05_ContratDocument.Documents();
            doc1.numeroPiece = 'test';
            doc1.referenceDuree = true;
            doc1.natureDocument = 'test';
            doc1.origineDocument = 'test';
            doc1.referenceDocument = 'test';
            doc1.titreDocument = 'test';
            doc1.dateSignature = System.today();
            doc1.datePriseEffet = System.today();
            doc1.statutDocument = 'test';
            doc1.dateStockage = System.today();
            doc1.niveauConfidentialite = 'DOC_C02';
            doc1.commentaireDocument = 'test';
            doc1.metadonnees = new WS05_ContratDocument.Metadonnees_document();
            doc1.metadonnees.creationDate = System.today();
            doc1.metadonnees.creationId = 'test123';
            doc1.metadonnees.updateDate = System.today();
            doc1.metadonnees.updateId = 'test123';
            doc1.metadonnees.validationDate = System.today();
            doc1.metadonnees.validationId = 'test123';
            docToInsert1.listeDocuments.document.add(doc1);
            docToInsert1.DKCodeContrat = '1234';
            
            test.startTest();
            Response resp1 = WS05_ContratDocument.insertContratDocument(docToInsert1);
            test.stopTest();
        }
    }
}