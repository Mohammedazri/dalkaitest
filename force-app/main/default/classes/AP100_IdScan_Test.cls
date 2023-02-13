/**
* @author: Charbel Khoury Hanna
* @date: 07/08/2021
* @description: Test Class for Class AP100_IdScan
*/
@isTest
public class AP100_IdScan_Test {
    
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
    
    static testMethod void deleteDocument()
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
        
        ContentDocumentLink contentlink1=new ContentDocumentLink();
        contentlink1.ShareType= 'V';
        contentlink1.LinkedEntityId = doc1.Id;            
        contentlink1.Visibility = 'AllUsers';
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id =:cv1.Id limit 1];
        contentlink1.ContentDocumentId = testContent.ContentDocumentId;
        insert contentlink1;
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        
        TEST.startTest();
        try{
            delete contentlink1;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        try{
            ContentDocument cd = [SELECT id FROM ContentDocument where id =:testContent.ContentDocumentId ];
            delete cd;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        TEST.stopTest();
    }
    
}