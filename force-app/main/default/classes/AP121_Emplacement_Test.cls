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
    static public void getServiceSurEmplacement() {
    User testUser = testgetenvUser();
                            
        ConventionService__c cvs = new ConventionService__c(Name = 'cvs1',  DKCodeCVS__c = 'codeCVS1');
        insert cvs;
        
        Service__c service = new Service__c(Name = 'Service1', CodeService__c = 'codeS1');
        insert service;
        
        LienConventionService__c liencvs = new LienConventionService__c(Service__c = service.Id, ConventionService__c = cvs.Id);
        insert liencvs;                 
                            
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
        
        System.assertEquals('Service1', lstEmp[0].Service__c);
        System.assertEquals('codeS1', lstEmp[0].CodeService__c);
      Test.stopTest();  
     } 
  } 
}