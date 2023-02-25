@isTest
public with sharing class ConventionServiceWebServiceTest {
    
    
    @isTest
    static void testUpsertConventionService() {
        

// Contrat__c contrat = [SELECT id, DKCodeSurContrat__c, Statut_Lien_contact__c,dureeReconduction__c,DureePreavis__c
//                       FROM Contrat__c 
//                       WHERE id = 'a031n00000ZBZq4AAH'];



Contrat__c contrat = new Contrat__c();
contrat.DKCodeSurContrat__c = 'C00001525H';                                                                                                                                                  
contrat.Statut_Lien_contact__c = true;
contrat.TypeReconduction__c= 'RLRC';
contrat.dureeReconduction__c=12;
contrat.DureePreavis__c=1;


try{
insert contrat;
}catch(DmlException e){
System.debug('Error: ' + e.getMessage());
}

System.debug('contrat >>> '+contrat);

ConventionService__c cvs = new ConventionService__c(DKCodeCVS__c = 'V00044872M', Name = 'CVS RILLIEUX LA PAPE - HATEM', Statut__c = 'ENOUV', DateDebut__c = Date.valueOf('2018-02-05'), Contrat__c =contrat.id /*contrat.Id, Metadata__c = metadata.Id*/);
insert cvs;
System.debug('cvs >>> '+cvs);
List<LienConventionEmplacement__c> listLienCVE =new List<LienConventionEmplacement__c>();
// Create the Emplacement records

LienConventionEmplacement__c emp1 = new LienConventionEmplacement__c(DKCodeEmplacement__c = 'S00011915K', StatutLien__c = true,ConventionService__c=cvs.Id);
LienConventionEmplacement__c emp2 = new LienConventionEmplacement__c(DKCodeEmplacement__c = 'S00011915K', StatutLien__c = true,ConventionService__c=cvs.Id);
//insert new List<LienConventionEmplacement__c>{emp1,emp2};

listLienCVE.add(emp1);
listLienCVE.add(emp2);
insert listLienCVE;
System.debug('listLienCVE >>> '+listLienCVE);

// Create the Service records
LienConventionService__c service1 = new LienConventionService__c(CodeService__c = 'S111', StatutLien__c = true,ConventionService__c=cvs.Id);
LienConventionService__c service2 = new LienConventionService__c(CodeService__c = 'S111', StatutLien__c = true,ConventionService__c=cvs.Id);
LienConventionService__c service3 = new LienConventionService__c(CodeService__c = 'S111', StatutLien__c = true,ConventionService__c=cvs.Id);
// insert new List<LienConventionService__c>{service1, service2, service3};

List<LienConventionService__c> listLienCVS =new List<LienConventionService__c>();
listLienCVS.add(service1);
listLienCVS.add(service2);
listLienCVS.add(service3);
insert listLienCVS;
System.debug('listLienCVS >>> '+listLienCVS);

        // Define the request body
         String requestBody ='{"dk_code_cvs":"V00044872M","libelle":"CVS RILLIEUX LA PAPE - AZRI","statut":"ENOUV","date_debut":"2018-02-05","contrat":{"dk_code_contrat":"C00001525H","statut_lien":true},"emplacement":[{"dk_code_emplacement":"S00011915K","statut_lien":true}, {"dk_code_emplacement":"S00011917K","statut_lien":true}],"service":[{"code_service":"S111","statut_lien":true}, {"code_service":"S114","statut_lien":true},{"code_service":"S115","statut_lien":true}],"metadonnee":{"date_modification":"2023-02-06T13:34:10.195","effectue_par":"mlandais"}}';
         // Call the REST API

         system.debug('requestBody >>> '+requestBody);
         Test.startTest();
         RestRequest request = new RestRequest();
         request.requestURI = '/services/apexrest/ConventionService';
         request.httpMethod = 'PUT';
         request.requestBody = Blob.valueOf(requestBody);
         RestContext.request = request;
         ConventionServiceWebService.UpsertConventionService();
         Test.stopTest();
         system.debug('RestContext >>>>  '+RestContext.request);
        // Verify that the conventionservice is create and update the record
        // Verify that the Convention record was created
        //Contrat__c contrats =[SELECT Id, DKCodeSurContrat__c, Statut_Lien_contact__c,dureeReconduction__c,DureePreavis__c FROM Contrat__c];        
        //contrat  




         ConventionService__c conventions = [SELECT Id,DKCodeCVS__c,Name,Statut__c,DateDebut__c,Contrat__c  FROM ConventionService__c];
        //System.assertEquals(1, conventions.size());
        
        System.assertEquals(contrat.id,conventions.Contrat__c);
        System.assertEquals('V00044872M', conventions.DKCodeCVS__c);
        System.assertEquals('CVS RILLIEUX LA PAPE - AZRI', conventions.Name);
        System.assertEquals('ENOUV', conventions.Statut__c);
        System.assertEquals(Date.valueOf('2018-02-05'), conventions.DateDebut__c);
        System.assertEquals(null, conventions.Contrat__c);

        // Verify that the Emplacement records were created
        LienConventionEmplacement__c[] LienCVSEmplacements = [SELECT Id, DKCodeEmplacement__c, StatutLien__c,ConventionService__c FROM LienConventionEmplacement__c];
        //System.assertEquals(2, Liencvsemplacements.size());

    
        System.assertEquals('S00011915K',Liencvsemplacements[0].DKCodeEmplacement__c);
        System.assertEquals(true, Liencvsemplacements[0].StatutLien__c);
        System.assertEquals(conventions.Id,Liencvsemplacements[0].ConventionService__c);
        

        // Verify that the Service records were created
        LienConventionService__c[] LienCVSservices = [SELECT Id, CodeService__c, ConventionService__c, StatutLien__c FROM LienConventionService__c];
        System.assertEquals(3, LienCVSservices.size());
        System.assertEquals(conventions.Id,LienCVSservices[0].ConventionService__c);
        System.assertEquals('S111', LienCVSservices[0].CodeService__c);



        

}
}
