@isTest
public with sharing class CaseBeforeUpdate_Test {

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
    static public void ModificationServicePASPossible() {
    User testUser = testgetenvUser();
     
    Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        emplacement1.CodeService__c = 'S001';
        emplacement1.Service__c = 'Demarrage machine';
        
        update emplacement1;
           
        Contact contact1 = testUtils.insertContact('FirstName1', 'LastName1', '0612345678', 'test1APIConDACRC@test.com');
        
        Case demande1 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact1, emplacement1, 'A Filtrer'); 
        demande1.Details__c = 'details';
        demande1.Impact__c = 'Général';
        demande1.Urgence__c = 'Normale';

        update demande1;

     System.runAs(testUser) {
      Test.startTest();
        demande1.Service__c = 'S114';
        demande1.Motif_Depannage__c = 'M2112';
        
        List <Emplacement__c> lstEmp = [Select Id, Service__c From Emplacement__c where Id =: emplacement1.Id limit 1];
        system.debug ('lstEmp[0].CodeService__c :'+lstEmp[0].Service__c);
        Database.update(demande1, false);
        System.assertEquals('Veuillez choisir un des services associés à cet Emplacement : '+lstEmp[0].Service__c, Database.update(demande1, false).getErrors()[0].getMessage());
      Test.stopTest();  
     } 
  } 
}