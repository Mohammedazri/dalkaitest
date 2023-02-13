@isTest
public class AP118_ScanRdd_Test {
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
            contrat2.DatePriseEffet__c = date.today();
            insert contrat2;
            
            List<Document_Contractuel__c> lstDocs = new List<Document_Contractuel__c>();
            
            Document_Contractuel__c DC1 = new Document_Contractuel__c();
            DC1.TitreDocument__c = 'test1';
            DC1.NumeroPiece__c='123xcv';
            DC1.NatureDocument__c = 'DOC02';
            DC1.StatutDocument__c = 'ACT';
            DC1.Contrat__c = contrat2.Id;
            DC1.DateSignature__c = Date.today();
            DC1.DatePriseEffet__c = Date.Today();
            DC1.NiveauDeConfidentialite__c = 'DOC_C02';
            DC1.Commentaire__c = '123';
            lstDocs.add(DC1);
            
            Document_Contractuel__c DC2 = new Document_Contractuel__c();
            DC2.TitreDocument__c = 'test2';
            DC2.NumeroPiece__c='123xcv';
            DC2.NatureDocument__c = 'DOC14';
            DC2.StatutDocument__c = 'ACT';
            DC2.Contrat__c = contrat2.Id;
            DC2.DateSignature__c = Date.today();
            DC2.DatePriseEffet__c = Date.Today();
            DC2.NiveauDeConfidentialite__c = 'DOC_C02';
            DC2.Commentaire__c = '123';
            lstDocs.add(DC2);
            
            Document_Contractuel__c DC3 = new Document_Contractuel__c();
            DC3.TitreDocument__c = 'test3';
            DC3.NumeroPiece__c='123xcv';
            DC3.NatureDocument__c = 'DOC14';
            DC3.StatutDocument__c = 'ACT';
            DC3.Contrat__c = contrat2.Id;
            DC3.DateSignature__c = Date.today();
            DC3.DatePriseEffet__c = Date.Today();
            DC3.NiveauDeConfidentialite__c = 'DOC_C02';
            DC3.Commentaire__c = '123';
            lstDocs.add(DC3);
            
            Document_Contractuel__c DC4 = new Document_Contractuel__c();
            DC4.TitreDocument__c = 'test4';
            DC4.NumeroPiece__c='123xcv';
            DC4.NatureDocument__c = 'DOC14';
            DC4.StatutDocument__c = 'ACT';
            DC4.Contrat__c = contrat2.Id;
            DC4.DateSignature__c = Date.today();
            DC4.DatePriseEffet__c = Date.Today();
            DC4.NiveauDeConfidentialite__c = 'DOC_C02';
            DC4.Commentaire__c = '123';
            lstDocs.add(DC4);
            
            insert lstDocs;
            
            Set<String> s = new Set<String>{DC1.id+'',DC2.id+'',DC3.id+'',DC4.id+''};
            AP118_ScanRdd.ModifierDocumentContractuel(s);
		}
    }
}