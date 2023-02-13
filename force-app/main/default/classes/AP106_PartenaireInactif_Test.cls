/**
* @author: Charbel Khoury Hanna
* @date: 04/20/2022
* @description: Test Class for Class AP106_PartenaireInactif
*/
@isTest
public class AP106_PartenaireInactif_Test {

    @isTest
    static void test()
    {
        Profile p1 = [SELECT Id FROM Profile WHERE id=:Label.Flux_AC_Id];
        User u1 = testUtils.CreateUser('standt28', 'charbel.hanna@eit-mena.com', 'Testing2', p1.Id, 'ac1@testorg2.com');
        u1.Nom_agence__c = 'test123';
        insert u1;
        
        Profile p2 = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('intWes', 'charbel.hanna@eit-mena.com', 'Integration WebService', p2.Id, 'integration.webservice@dalkia.test');
        u2.Nom_agence__c = 'test123';
        insert u2;
        
        System.runAs(u2) 
        {
            Account acc =  new Account(Name= 'test', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
            acc.Type_immatriculation__c = 'RCS';
            acc.Immatriculation_Legale__c = '12345';
            acc.StatutPartenaire__c = 'OUV';
            acc.DKCodeSurPartenaire__c = 'TEST123';
            insert acc;
            
            Contrat__c contrat1 = new Contrat__c();
            contrat1.Name = 'testContrat1';
            contrat1.NomPartenaire__c = acc.Id;
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            contrat1.TypeContrat__c = 'IND';
            contrat1.DatePriseEffet__c = date.today();
            contrat1.PiloteDuContrat__c = u2.Id;
            insert contrat1;
            
            Contrat__c contrat2 = new Contrat__c();
            contrat2.Name = 'testContrat2';
            contrat2.NomPartenaire__c = acc.Id;
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            contrat2.TypeContrat__c = 'IND';
            contrat2.DatePriseEffet__c = date.today();
            contrat2.PiloteDuContrat__c = u2.Id;
            insert contrat2;
            
            Contrat__c contrat3 = new Contrat__c();
            contrat3.Name = 'testContrat3';
            contrat3.NomPartenaire__c = acc.Id;
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            contrat3.TypeContrat__c = 'IND';
            contrat3.DatePriseEffet__c = date.today();
            contrat3.PiloteDuContrat__c = u1.Id;
            insert contrat3;
            
            acc.StatutPartenaire__c = 'FER';
            update acc;
        }
    }
}