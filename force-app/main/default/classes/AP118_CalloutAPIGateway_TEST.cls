@isTest
public with sharing class AP118_CalloutAPIGateway_TEST {


    @testSetup
    static void setup(){
    
    /*
    Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement1= testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');   
        Contact contact1 = testUtils.insertContact('FirstName1', 'LastName1', '06123456789', 'test1APIConDACRC@test.com');
        
        Case demande1 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact1, emplacement1, 'A Filtrer'); 
                            
        Emplacement__c emplacement2= testUtils.insertEmplacement('Emplacement 2', false, 'DKCode 2');   
        Contact contact2 = testUtils.insertContact('FirstName2', 'LastName2', '06123456788', 'test2APIConDACRC@test.com');
        
        Case demande2 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact2, emplacement2, 'A Filtrer'); 
        
        Emplacement__c emplacement3= testUtils.insertEmplacement('Emplacement 3', false, 'DKCode 3');   
        Contact contact3 = testUtils.insertContact('FirstName3', 'LastName3', '06123456785', 'test3APIConDACRC@test.com');
        
        Case demande3 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact3, emplacement3, 'A Filtrer'); 
    */
    }

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
        /*
         Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement1= testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');   
        Contact contact1 = testUtils.insertContact('FirstName1', 'LastName1', '06123456789', 'test1APIConDACRC@test.com');
        
        Case demande1 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact1, emplacement1, 'A Filtrer'); 
                            
        Emplacement__c emplacement2= testUtils.insertEmplacement('Emplacement 2', false, 'DKCode 2');   
        Contact contact2 = testUtils.insertContact('FirstName2', 'LastName2', '06123456788', 'test2APIConDACRC@test.com');
        
        Case demande2 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact2, emplacement2, 'A Filtrer'); 
        
        Emplacement__c emplacement3= testUtils.insertEmplacement('Emplacement 3', false, 'DKCode 3');   
        Contact contact3 = testUtils.insertContact('FirstName3', 'LastName3', '06123456785', 'test3APIConDACRC@test.com');
        
        Case demande3 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact3, emplacement3, 'A Filtrer'); 
      */
    }
        

    @isTest
    static void testCalloutAPIGateway()
    {
        User testUser = testgetenvUser();
        
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement= testUtils.insertEmplacement('Emplacement0', false, 'DKCode0');   
        Contact contact = testUtils.insertContact('FirstName0', 'LastName0', '06123456745', 'test0APIConDACRC@test.com');
        
        Case demande = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact, emplacement, 'A Filtrer'); 
        
        System.runas(testUser){
            Test.startTest();
                        
            demande.Description = 'Details';
            demande.Details__c = 'TITRE';
            demande.Reason = 'Alerte environnement';
            demande.Impact__c = 'Général';
            demande.Urgence__c = 'Urgente';
            update demande;   
             
            Test.stopTest();
        }
        
    }
}