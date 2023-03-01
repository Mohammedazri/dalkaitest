@isTest
public with sharing class ConventionServiceWebService_v2Test {

    // This test method tests the functionality of the UpsertConventionService() method in the ConventionServiceWebService_v2 class.
    // It creates test data for a ConventionService record and related objects, and calls the UpsertConventionService() method with a sample REST API request.
    @isTest
static void testUpsertConventionService() {

    Contrat__c contrat = new Contrat__c(DKCodeSurContrat__c = 'C00001525H',Statut_Lien_contact__c = true,TypeReconduction__c= 'RLRC',dureeReconduction__c=12,DureePreavis__c=1);
    try{
    insert contrat;
    }catch(DmlException e){
    System.debug('Error: ' + e.getMessage());
    }
    ConventionService__c cvs = new ConventionService__c(DKCodeCVS__c = 'V00044872M', Name = 'CVS RILLIEUX LA PAPE - Mohammed AZRI', Statut__c = 'ENOUV', DateDebut__c = Date.valueOf('2018-02-05'), Contrat__c =contrat.id /*contrat.Id, Metadata__c = metadata.Id*/);
    insert cvs;
    
    Emplacement__c emp1 = new Emplacement__c();
    emp1.DKCode_Emplacement__c='S00011915K';
    insert emp1;
    Emplacement__c emp2 = new Emplacement__c(DKCode_Emplacement__c='S00011916K');
    insert emp2;
    Service__c serv  =new Service__c(CodeService__c='S111');
    insert serv;
    
    List<LienConventionEmplacement__c> listLienCVSEm =new List<LienConventionEmplacement__c>();
    LienConventionEmplacement__c Lemp1 = new LienConventionEmplacement__c(DKCodeEmplacement__c = 'S00011915K', StatutLien__c = true,ConventionService__c=cvs.Id,Emplacement__c=emp1.id);
    LienConventionEmplacement__c Lemp2 = new LienConventionEmplacement__c(DKCodeEmplacement__c = 'S00011916K', StatutLien__c = true,ConventionService__c=cvs.Id,Emplacement__c=emp2.id);
    listLienCVSEm.add(Lemp1);
    listLienCVSEm.add(Lemp2);
    insert listLienCVSEm;
    
    LienConventionService__c service1 = new LienConventionService__c(CodeService__c = 'S111', StatutLien__c = true,ConventionService__c=cvs.Id,Service__c=serv.Id);
    LienConventionService__c service2 = new LienConventionService__c(CodeService__c = 'S112', StatutLien__c = true,ConventionService__c=cvs.Id,Service__c=serv.Id);
    LienConventionService__c service3 = new LienConventionService__c(CodeService__c = 'S113', StatutLien__c = true,ConventionService__c=cvs.Id,Service__c=serv.Id);
    
    List<LienConventionService__c> listLienCVS =new List<LienConventionService__c>();
    listLienCVS.add(service1);
    listLienCVS.add(service2);
    listLienCVS.add(service3);
    insert listLienCVS;
        Test.startTest();
         String requestBody ='{"dk_code_cvs":"V00044872M","libelle":"CVS RILLIEUX LA PAPE - AZRI","statut":"ENOUV","date_debut":"2018-02-05","contrat":{"dk_code_contrat":"C00001525H","statut_lien":true},"emplacement":[{"dk_code_emplacement":"S00011915K","statut_lien":false},{"dk_code_emplacement":"S00011916K","statut_lien":true}],"service":[{"code_service":"S111","statut_lien":true}, {"code_service":"S112","statut_lien":false},{"code_service":"S113","statut_lien":true}],"metadonnee":{"date_modification":"2023-02-06T13:34:10.195","effectue_par":"mlandais"}}';
         
         RestRequest request = new RestRequest();
         request.requestURI = '/services/apexrest/ConventionService_v2';
         request.httpMethod = 'PUT';
         request.requestBody = Blob.valueOf(requestBody);
         RestContext.request = request;
         ConventionServiceWebService_v2.UpsertConventionService();
         String requestBody1 ='{"dk_code_cvs":"V00044872M","libelle":"CVS RILLIEUX LA PAPE - AZRI","statut":"ENOUV","date_debut":"2018-02-05","contrat":{"dk_code_contrat":"C00001525H","statut_lien":true},"emplacement":[{"dk_code_emplacement":"S00011915K","statut_lien":true},{"dk_code_emplacement":"S00011916K","statut_lien":true}, {"dk_code_emplacement":"S00011917K","statut_lien":true}],"service":[{"code_service":"S111","statut_lien":true}, {"code_service":"S112","statut_lien":true},{"code_service":"S113","statut_lien":true},{"code_service":"S114","statut_lien":true}],"metadonnee":{"date_modification":"2023-02-06T13:34:10.195","effectue_par":"mlandais"}}';
        
        RestRequest request1 = new RestRequest();
         request1.requestURI = '/services/apexrest/ConventionService_v2';
         request1.httpMethod = 'PUT';
         request1.requestBody = Blob.valueOf(requestBody1);
         RestContext.request = request1;
         ConventionServiceWebService_v2.UpsertConventionService();
         String requestBody2 ='{"dk_code_cvs":"V00044873M","libelle":"CVS RILLIEUX LA PAPE - AZRI","statut":"ENOUV","date_debut":"2018-02-05","contrat":{"dk_code_contrat":"C00001525H","statut_lien":true},"emplacement":[{"dk_code_emplacement":"S00011915K","statut_lien":false},{"dk_code_emplacement":"S00011916K","statut_lien":true}, {"dk_code_emplacement":"S00011917K","statut_lien":true}],"service":[{"code_service":"S111","statut_lien":true}, {"code_service":"S114","statut_lien":false},{"code_service":"S115","statut_lien":true},{"code_service":"S116","statut_lien":true}],"metadonnee":{"date_modification":"2023-02-06T13:34:10.195","effectue_par":"mlandais"}}';         
         
         RestRequest request2 = new RestRequest();
         request2.requestURI = '/services/apexrest/ConventionService_v2';
         request2.httpMethod = 'PUT';
         request2.requestBody = Blob.valueOf(requestBody2);
         RestContext.request = request2;
         ConventionServiceWebService_v2.UpsertConventionService();
         Test.stopTest();
}
}