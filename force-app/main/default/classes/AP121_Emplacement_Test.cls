@isTest
public with sharing class AP121_Emplacement_Test {

static public User testgetenvUser()
    {
        // mettre en région français
        Profile p = [SELECT Id FROM Profile WHERE Name=/*'Téléopérateur'*/ 'System Administrator' ];
        User u = new User(Alias = 'tele', Email='teleoperateuruser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='teleTesting', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='teleoperateuruser@testorg.com',
                            BypassValidationRules__c = True);
        return u;
    }
    

    @isTest
    static public void getServiceOnEmplacementByInsertionEmplacementAssocie() {
    User testUser = testgetenvUser();
                            
        ConventionService__c cvs = new ConventionService__c(Name = 'cvs1',  DKCodeCVS__c = 'codeCVS1');
        insert cvs;
        
        Service__c service1 = new Service__c(Name = 'Service1', CodeService__c = 'codeS1');
        insert service1;
        
        Service__c service2 = new Service__c(Name = 'Service2', CodeService__c = 'codeS2');
        insert service2;
        
        LienConventionService__c liencvs1 = new LienConventionService__c(Service__c = service1.Id, ConventionService__c = cvs.Id);
        insert liencvs1; 
        
        LienConventionService__c liencvs2 = new LienConventionService__c(Service__c = service2.Id, ConventionService__c = cvs.Id);
        insert liencvs2;                
                            
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        emplacement1.CodeService__c = '';
        emplacement1.Service__c = '';   
        update emplacement1;
        
        lienConventionEmplacement__c liencve = new lienConventionEmplacement__c(ConventionService__c = cvs.Id, Emplacement__c = emplacement1.Id); 

     System.runAs(testUser) {
      Test.startTest();
        //lienConventionEmplacement__c liencve = new lienConventionEmplacement__c(ConventionService__c = cvs.Id, Emplacement__c = emplacement1.Id);
        Database.insert(liencve, false);      
        List <Emplacement__c> lstEmp = [Select Id, Service__c, CodeService__c From Emplacement__c where Id =: emplacement1.Id limit 1];
        system.debug ('lstEmp[0].CodeService__c :'+lstEmp[0].Service__c);
        
        System.assertEquals(service1.Name + '\r' + service2.Name, lstEmp[0].Service__c);
        System.assertEquals(service1.CodeService__c + '\r' + service2.CodeService__c, lstEmp[0].CodeService__c);
      Test.stopTest();  
     } 
  } 
  
  @isTest
    static public void getServiceOnEmplacementByDeletionEmplacementAssocie() {
    User testUser = testgetenvUser();
                            
        ConventionService__c cvs = new ConventionService__c(Name = 'cvs1',  DKCodeCVS__c = 'codeCVS1');
        insert cvs;
        
        Service__c service1 = new Service__c(Name = 'Service1', CodeService__c = 'codeS1');
        insert service1;
        
        Service__c service2 = new Service__c(Name = 'Service2', CodeService__c = 'codeS2');
        insert service2;
        
        LienConventionService__c liencvs1 = new LienConventionService__c(Service__c = service1.Id, ConventionService__c = cvs.Id);
        insert liencvs1; 
        
        LienConventionService__c liencvs2 = new LienConventionService__c(Service__c = service2.Id, ConventionService__c = cvs.Id);
        insert liencvs2;                
                            
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        emplacement1.CodeService__c = '';
        emplacement1.Service__c = '';   
        update emplacement1;
        
        lienConventionEmplacement__c liencve = new lienConventionEmplacement__c(ConventionService__c = cvs.Id, Emplacement__c = emplacement1.Id, StatutLien__c = true); 
        liencve.StatutLien__c = false;
        
     System.runAs(testUser) {
      Test.startTest();
        //lienConventionEmplacement__c liencve = new lienConventionEmplacement__c(ConventionService__c = cvs.Id, Emplacement__c = emplacement1.Id);
        Database.insert(liencve, false);      
        List <Emplacement__c> lstEmpInsertion = [Select Id, Service__c, CodeService__c From Emplacement__c where Id =: emplacement1.Id limit 1];
        system.debug ('lstEmpInsertion[0].CodeService__c :'+lstEmpInsertion[0].Service__c);
        
        System.assertEquals(service1.Name + '\r' + service2.Name, lstEmpInsertion[0].Service__c);
        System.assertEquals(service1.CodeService__c + '\r' + service2.CodeService__c, lstEmpInsertion[0].CodeService__c);
        
        update liencve;
        
        Database.delete(liencve, false);      
        List <Emplacement__c> lstEmpUpdate = [Select Id, Service__c, CodeService__c From Emplacement__c where Id =: emplacement1.Id limit 1];
        //system.debug ('lstEmpUpdate[0].CodeService__c :'+lstEmpUpdate.Service__c);
        
        System.assertEquals(null, lstEmpUpdate[0].Service__c);
        System.assertEquals(null, lstEmpUpdate[0].CodeService__c);
      Test.stopTest();  
     } 
  } 
  
  @isTest
    static public void getServiceOnEmplacementByInsertionServiceAssocie() {
    User testUser = testgetenvUser();
                            
        ConventionService__c cvs = new ConventionService__c(Name = 'cvs1',  DKCodeCVS__c = 'codeCVS1');
        insert cvs;
        
        Service__c service1 = new Service__c(Name = 'Service1', CodeService__c = 'codeS1');
        insert service1;
        
        Service__c service2 = new Service__c(Name = 'Service2', CodeService__c = 'codeS2');
        insert service2;
        
        Service__c service3 = new Service__c(Name = 'Service3', CodeService__c = 'codeS3');
        insert service3;
        
        LienConventionService__c liencvs1 = new LienConventionService__c(Service__c = service1.Id, ConventionService__c = cvs.Id);
        insert liencvs1; 
        
        LienConventionService__c liencvs2 = new LienConventionService__c(Service__c = service2.Id, ConventionService__c = cvs.Id);
        insert liencvs2;  
        
        LienConventionService__c liencvs3 = new LienConventionService__c(Service__c = service3.Id, ConventionService__c = cvs.Id);              
                            
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        emplacement1.CodeService__c = '';
        emplacement1.Service__c = '';   
        update emplacement1;
        
        lienConventionEmplacement__c liencve = new lienConventionEmplacement__c(ConventionService__c = cvs.Id, Emplacement__c = emplacement1.Id); 
        insert liencve;
        
     System.runAs(testUser) {
      Test.startTest();
        //lienConventionEmplacement__c liencve = new lienConventionEmplacement__c(ConventionService__c = cvs.Id, Emplacement__c = emplacement1.Id);
        Database.insert(liencvs3, false);      
        List <Emplacement__c> lstEmp = [Select Id, Service__c, CodeService__c From Emplacement__c where Id =: emplacement1.Id limit 1];
        system.debug ('lstEmp[0].CodeService__c :'+lstEmp[0].Service__c);
        
        System.assertEquals(service1.Name + '\r' + service2.Name + '\r' + service3.Name, lstEmp[0].Service__c);
        System.assertEquals(service1.CodeService__c + '\r' + service2.CodeService__c + '\r' + service3.CodeService__c, lstEmp[0].CodeService__c);
      Test.stopTest();  
     } 
  }
   
   @isTest
    static public void getServiceOnEmplacementByDeletionServiceAssocie() {
    User testUser = testgetenvUser();
                            
        ConventionService__c cvs = new ConventionService__c(Name = 'cvs1',  DKCodeCVS__c = 'codeCVS1');
        insert cvs;
        
        Service__c service1 = new Service__c(Name = 'Service1', CodeService__c = 'codeS1');
        insert service1;
        
        Service__c service2 = new Service__c(Name = 'Service2', CodeService__c = 'codeS2');
        insert service2;
        
        LienConventionService__c liencvs1 = new LienConventionService__c(Service__c = service1.Id, ConventionService__c = cvs.Id, StatutLien__c = true);
        insert liencvs1; 
        liencvs1.StatutLien__c = false;
        
        LienConventionService__c liencvs2 = new LienConventionService__c(Service__c = service2.Id, ConventionService__c = cvs.Id, StatutLien__c = true);
        insert liencvs2;                
                            
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        emplacement1.CodeService__c = '';
        emplacement1.Service__c = '';   
        update emplacement1;
        
        lienConventionEmplacement__c liencve = new lienConventionEmplacement__c(ConventionService__c = cvs.Id, Emplacement__c = emplacement1.Id, StatutLien__c = true); 
        insert liencve;
        
     System.runAs(testUser) {
      Test.startTest();
        
        update liencvs1;
        
        Database.delete(liencvs1, false);      
        List <Emplacement__c> lstEmpUpdate = [Select Id, Service__c, CodeService__c From Emplacement__c where Id =: emplacement1.Id limit 1];
        //system.debug ('lstEmpUpdate[0].CodeService__c :'+lstEmpUpdate.Service__c);
        
        System.assertEquals('Service2', lstEmpUpdate[0].Service__c);
        System.assertEquals('codeS2', lstEmpUpdate[0].CodeService__c);
      Test.stopTest();  
     } 
  }  
}