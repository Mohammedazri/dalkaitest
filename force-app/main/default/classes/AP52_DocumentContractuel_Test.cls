/**
* @author: Rita Bejjani -EI Technologies
* @date: 12/04/2019
* @description: Test Class for "AP52_DocumentContractuel" 
*/
@isTest
public class AP52_DocumentContractuel_Test {
    
    static testMethod void testCheckPreviousDcContrat()
    {
        //query the profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create the user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.BypassValidationRules__c =true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassFilters__c = true;
        insert u2;// insert the user
        
        // run test as the created user 
        System.runAs(u2) 
        {
            test.startTest();
            
            Account acc =  new Account(Name= 'test', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
            insert acc;
            
            Contrat__c contrat = new Contrat__c();
            contrat.Name = 'testContrat';
            contrat.NomPartenaire__c = acc.Id;
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            contrat.TypeContrat__c = 'IND';
            insert contrat;
            
            Contrat__c contrat2 = new Contrat__c();
            contrat2.Name = 'testContrat2';
            contrat2.NomPartenaire__c = acc.Id;
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            contrat2.TypeContrat__c = 'IND';
            insert contrat2;
            
            Document_Contractuel__c DC1 = new Document_Contractuel__c();
            DC1.TitreDocument__c = 'test1';
            DC1.NumeroPiece__c='123';
            DC1.NatureDocument__c = 'DOC01';
            DC1.StatutDocument__c = 'ACT';
            DC1.Contrat__c = contrat.Id;
            DC1.DatePriseEffet__c = date.today();
            DC1.DateSignature__c = date.today();
            insert DC1;
            
            Document_Contractuel__c DC2 = new Document_Contractuel__c();
            DC2.TitreDocument__c = 'test2';
            DC2.NumeroPiece__c='123';
            DC2.NatureDocument__c = 'DOC01';
            DC2.StatutDocument__c = 'ACT';
            DC2.Contrat__c = contrat.Id;
            DC2.DatePriseEffet__c = date.today();
            DC2.DateSignature__c = date.today();
            
            Document_Contractuel__c DC3 = new Document_Contractuel__c();
            DC3.TitreDocument__c = 'test3';
            DC3.NumeroPiece__c='133';
            DC3.NatureDocument__c = 'DOC01';
            DC3.StatutDocument__c = 'ACT';
            DC3.Contrat__c = contrat2.Id;
            DC3.DatePriseEffet__c = date.today();
            DC3.DateSignature__c = date.today();
            insert DC3;
            
            
            try{
                insert DC2;
            }
            catch(exception e){
                system.debug('exception message: '+e.getMessage());
                system.assertEquals(e.getMessage().contains(Label.AP52_Error), true);
            }
            
            try{
                DC3.Contrat__c = contrat.id;
                update DC3;
            }
            catch(exception e){
                system.debug('exception message: '+e.getMessage());
                //system.assertEquals(e.getMessage(), 'Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Impossible d\'ajouter plus qu\'un seul document contractuel de nature \'contrat\' sur ce contrat: []');
            }
            
            test.stopTest();
        }
    }
    
    /*static testMethod void testCheckPreviousDcContratDuree()
        {
        test.startTest();
        
        Account acc =  new Account(Name= 'test', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',Statut__c='ACTIF',EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
        insert acc;
        
        Contrat__c contrat = new Contrat__c();
        contrat.Name = 'testContrat';
        contrat.NomPartenaire__c = acc.Id;
        contrat.TypeContrat__c = 'IND';
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        insert contrat;
        
        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.TitreDocument__c = 'test1';
        DC1.NumeroPiece__c='123';
        DC1.NatureDocument__c = 'DOC01';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = contrat.Id;
        DC1.ReferenceDuree__c =true;
        insert DC1;
        
        Document_Contractuel__c DC2 = new Document_Contractuel__c();
        DC2.TitreDocument__c = 'test2';
        DC2.NumeroPiece__c='123';
        DC2.NatureDocument__c = 'DOC02';
        DC2.StatutDocument__c = 'ACT';
        DC2.ReferenceDuree__c = true;
        DC2.Contrat__c = contrat.Id;
        
        Document_Contractuel__c DC3 = new Document_Contractuel__c();
        DC3.TitreDocument__c = 'test3';
        DC3.NumeroPiece__c='133';
        DC3.NatureDocument__c = 'DOC02';
        DC3.StatutDocument__c = 'ACT';
        DC3.Contrat__c = contrat.Id;
        insert DC3;
        
        
        try{
        insert DC2;
        }
        catch(exception e){
        system.debug('exception message:1 '+e.getMessage());
        //system.assertEquals(e.getMessage(), ' Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Le champ "Détermine les durées" doit obligatoirement être coché pour un unique document associé à un contrat.: []');
        }
        
        try{
        DC3.ReferenceDuree__c = true;
        update DC3;
        }
        catch(exception e){
        system.debug('exception message:2 '+e.getMessage());
        //system.assertEquals(e.getMessage(), 'Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Impossible d\'ajouter plus qu\'un seul document contractuel de nature \'contrat\' sur ce contrat: []');
        }
        
        test.stopTest();
        }*/
    
    static testMethod void testCheckDcContratDuree()
    {
        //query the profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create the user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.BypassValidationRules__c =true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassFilters__c = true;
        insert u2;// insert the user
        
        // run test as the created user 
        System.runAs(u2) 
        {
            test.startTest();
            
            Account acc =  new Account(Name= 'test', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
            insert acc;
            
            Contrat__c contrat = new Contrat__c();
            contrat.Name = 'testContrat';
            contrat.NomPartenaire__c = acc.Id;
            contrat.TypeContrat__c = 'IND';
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            insert contrat;
            
            Document_Contractuel__c DC1 = new Document_Contractuel__c();
            DC1.TitreDocument__c = 'test1';
            DC1.NumeroPiece__c='123';
            DC1.NatureDocument__c = 'DOC01';
            DC1.StatutDocument__c = 'ACT';
            DC1.Contrat__c = contrat.Id;
            DC1.DatePriseEffet__c = date.today();
            DC1.DateSignature__c = date.today();
            
            try{
                insert DC1;
            }
            catch(exception e){
                system.debug('exception message:1 '+e.getMessage());
                //system.assertEquals(e.getMessage(), ' Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Le champ "Détermine les durées" doit obligatoirement être coché pour un unique document associé à un contrat.: []');
            }
            
            test.stopTest();
        }
    }
    
    static testMethod void testCheckContratAvenant()
    {
        //query the profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create the user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.BypassValidationRules__c =true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassFilters__c = true;
        insert u2;// insert the user
        
        // run test as the created user 
        System.runAs(u2) 
        {
            test.startTest();
            
            Account acc =  new Account(Name= 'test', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
            insert acc;
            
            Contrat__c contrat = new Contrat__c();
            contrat.Name = 'testContrat';
            contrat.NomPartenaire__c = acc.Id;
            contrat.Avenant__c = 'Non';
            contrat.TypeContrat__c = 'IND';
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            insert contrat;
            
            Document_Contractuel__c DC1 = new Document_Contractuel__c();
            DC1.TitreDocument__c = 'test1';
            DC1.NumeroPiece__c='123';
            DC1.NatureDocument__c = 'DOC05';
            DC1.StatutDocument__c = 'ACT';
            DC1.Contrat__c = contrat.Id;
            DC1.DatePriseEffet__c = date.today();
            DC1.DateSignature__c = date.today();
            
            try{
                insert DC1;
                DC1.NatureDocument__c = 'DOC01';
                try{
                    update DC1;
                }
                catch(exception e){
                    system.debug('exception message:2 '+e.getMessage());
                }
            }
            catch(exception e){
                system.debug('exception message:1 '+e.getMessage());
                //system.assertEquals(e.getMessage(), ' Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Le champ "Détermine les durées" doit obligatoirement être coché pour un unique document associé à un contrat.: []');
            }
            
            test.stopTest();
        }
    }
}