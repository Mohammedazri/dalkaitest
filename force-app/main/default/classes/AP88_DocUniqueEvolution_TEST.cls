/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 28/07/2020
* @description: Test Class for "AP88_DocUniqueEvolution" 
*/
@isTest
public class AP88_DocUniqueEvolution_TEST {
    static testMethod void testDocRecordType()
    {
        //create and insert Account
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = 'OUV';
        insert a1;
        
        //create and insert Contract
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        insert c1;
        
        Date myDate = Date.newInstance(2019, 03, 20);
        Time myTime = Time.newInstance(9, 11, 44, 88);
        DateTime dt = DateTime.newInstance(myDate, myTime);
        
        Account acc =  new Account(Name= 'test', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
        acc.Type_immatriculation__c = 'RCS';
        acc.Immatriculation_Legale__c = '12345';
        acc.StatutPartenaire__c = 'OUV';
        insert acc;
 
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
        myOpp.accountId=a1.Id;
        myOpp.ContratOrigine__c=c1.Id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Type_pers__c=Label.PV_Evolution;
        myOpp.Annee_de_signature__c='2017';
        myOpp.Statut__c = 'En cours';
        insert myOpp;
        
        Contrat__c contrat2 = new Contrat__c();
        contrat2.Name = 'testContrat2';
        contrat2.NomPartenaire__c = acc.Id;
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        contrat2.TypeContrat__c = 'IND';
        contrat2.DatePriseEffet__c = date.today();
        insert contrat2;
                
        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.RecordTypeId = Schema.SObjectType.Document_Contractuel__c.getRecordTypeInfosByDeveloperName().get(Label.DocumentContractuelSync).getRecordTypeId();
        DC1.TitreDocument__c = 'test1';
        DC1.NumeroPiece__c='123';
        DC1.NatureDocument__c = 'DOC01';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = contrat2.Id;
        DC1.DatePriseEffet__c = date.today();
        DC1.DateSignature__c = date.today();
        DC1.NiveauDeConfidentialite__c = 'DOC_C02';
        insert DC1;
    }
}