@isTest
public with sharing class AP118_ConnecteurDACRC_TEST {


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
    static void testgetToken_ok()
    {
        User testUser = testgetenvUser();
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper = new AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper();
        
        System.runas(testUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, 
                         new AP118_ConnecteurDACRC_Mock_TEST(200, 'OK', '{"access_token":"unBonToken"}', null, null));
            String tokenSucces = AP118_ConnecteurDACRC.getToken(demande_OTWrapper);
            System.assertEquals('unBonToken', tokenSucces , 'token invalide');
            Test.stopTest();
        }
        
    }

    @isTest
    static void testgetToken_ko()
    {
        User testUser = testgetenvUser();
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper = new AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper();
        
        System.runas(testUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, 
                new AP118_ConnecteurDACRC_Mock_TEST(400, 'KO', '{"access_token":"NotGood"}', null, null));
            String tokenSucces = AP118_ConnecteurDACRC.getToken(demande_OTWrapper);
            System.assertEquals('', tokenSucces, 'le token retourné n est pas vide');
            System.assertEquals(null, demande_OTWrapper.isErrorDemande,  'le demande_OTWrapper n a pas d erreur');
            //System.assertNotEquals( '', consigneWrapper.strError, 'le consigneWrapper n a pas de message d erreur');
            Test.stopTest();
        }
    }

 
    @isTest
    static void testcreateDemande_ok() {
        
        User testUser = testgetenvUser();
        
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper;
        
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();  
                            
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1'); 
        emplacement1.Nature_Emplacement__c = 'SIT'; 
        update emplacement1;
          
        Contact contact1 = testUtils.insertContact('FirstName1', 'LastName1', '+33612345678', 'test1APIConDACRC@test.com');
        
        Case demande1 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact1, emplacement1, 'A Filtrer');   
            
        String respondeBody = '[{"message": "le message a bien \u00e9t\u00e9 envoy\u00e9"}]';
        webservicelog__c wsLog = null;
        
        System.runas(testUser){
            Test.startTest();
            //demande1.CaseNumber = '00001';
            demande1.Description = 'Details';
            demande1.Details__c = 'TITRE';
            demande1.Reason = 'Alerte environnement';
            demande1.Impact__c = 'Général';
            demande1.Urgence__c = 'Urgente';
            //demande1.Status = 'A Traiter';
            update demande1;
            Test.setMock(HttpCalloutMock.class, 
                new AP118_ConnecteurDACRC_Mock_TEST(200, 'OK', respondeBody, null, null));
            //system.assertequals('OK', demande1.StatutRetourWebServiceMSAD__c);  
            //system.assertequals(respondeBody, demande1.MessageRetourWebServiceMSAD__c);
            //system.assertequals('200', wsLog.CodeRetour__c);  
            //system.assertequals(respondeBody, wsLog.Response__c);   
                
            Test.stopTest();
        }
    }
  
  /*  
    @isTest
    static void testcreateOrdreTravail_ok() {
        
        User testUser = testgetenvUser();
        
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper;
        
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');   
        Contact contact1 = testUtils.insertContact('FirstName1', 'LastName1', '06123456789', 'test1APIConDACRC@test.com');
        
        Case demande1 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact1, emplacement1, 'A Filtrer'); 
     
            
        String respondeBody = '[{"message": "le message a bien \u00e9t\u00e9 envoy\u00e9"}]';
        webservicelog__c wsLog = null;
        
        System.runas(testUser){
            Test.startTest();
            //demande1.CaseNumber = '00001';
            demande1.Description = 'Details';
            demande1.Details__c = 'TITRE';
            demande1.Reason = 'Alerte environnement';
            demande1.Impact__c = 'Général';
            demande1.Urgence__c = 'Urgente';
            //demande1.Status = 'A Traiter';
            update demande1;

            Test.setMock(HttpCalloutMock.class, 
                new AP118_ConnecteurDACRC_Mock_TEST(200, 'OK', respondeBody, null, null));
             
            Test.stopTest();
        }
    }
    */
   

    @isTest
    static void testcreateDemande_ko() {
        User testUser = testgetenvUser();
        
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement2= testUtils.insertEmplacement('Emplacement 2', false, 'DKCode 2');       
        emplacement2.Nature_Emplacement__c = 'SIT'; 
        update emplacement2;  
         
        Contact contact2 = testUtils.insertContact('FirstName2', 'LastName2', '+33612345678', 'test2APIConDACRC@test.com');
        
        Case demande2 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact2, emplacement2, 'A Filtrer'); 
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper = new AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper();
        
        String respondeBody = '{"message": "Internal server error"}';
        
        webservicelog__c wsLog = null;
        
        System.runas(testUser) {
            Test.startTest();    
            demande2.Description = 'Details';
            demande2.Details__c = 'TITRE';
            demande2.Reason = 'Alerte environnement';
            demande2.Impact__c = 'Général';
            demande2.Urgence__c = 'Urgente';
            update demande2;    
            Test.setMock(HttpCalloutMock.class, 
                new AP118_ConnecteurDACRC_Mock_TEST(502, 'KO', respondeBody, null, null));

            Test.stopTest();
        }
    }

    @isTest
    static void testgetToken_exception()
    {
        User testUser = testgetenvUser();
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper = new AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper();
        
        System.runas(testUser) {
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, 
                new AP118_ConnecteurDACRC_Mock_TEST(502, '', '', null, 'There is a exception.'));
            String tokenSucces = AP118_ConnecteurDACRC.getToken(demande_OTWrapper);
            System.assertEquals(null, demande_OTWrapper.isErrorDemande, 'le demande_OTWrapper n a pas bien une erreur');
            //System.assertEquals( 'There is a exception.', consigneWrapper.strError, 'le consigneWrapper n a pas d erreur');
            
            Test.stopTest();
        }
    }

    @isTest
    static void testcreateDemande_exception() {
        
        User testUser = testgetenvUser();
        
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement3= testUtils.insertEmplacement('Emplacement 3', false, 'DKCode 3'); 
        emplacement3.Nature_Emplacement__c = 'SIT'; 
        update emplacement3;
          
        Contact contact3 = testUtils.insertContact('FirstName3', 'LastName3', '+33612345678', 'test3APIConDACRC@test.com');
        
        Case demande3 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact3, emplacement3, 'A Filtrer'); 
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper = new AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper();
        webservicelog__c wsLog = null;
        
        System.runas(testUser){
            Test.startTest();
            demande3.Description = 'Details';
            demande3.Details__c = 'TITRE';
            demande3.Reason = 'Alerte environnement';
            demande3.Impact__c = 'Général';
            demande3.Urgence__c = 'Urgente';
            update demande3;
            Test.setMock(HttpCalloutMock.class, 
                new AP118_ConnecteurDACRC_Mock_TEST(502, '', '', null, 'There is a exception.'));

            Test.stopTest();
        }
    }
    
    
    @isTest
    static void testcalloutDemande_ko()
    {
        User testUser = testgetenvUser();
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
                            
        Emplacement__c emplacement4= testUtils.insertEmplacement('Emplacement 4', false, 'DKCode 4');
        emplacement4.Nature_Emplacement__c = 'SIT'; 
        update emplacement4;
           
        Contact contact4 = testUtils.insertContact('FirstName4', 'LastName4', '+33612345676', 'test4APIConDACRC@test.com');
        
        Case demande4 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact4, emplacement4, 'A Filtrer'); 
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper;
        webservicelog__c wsLog = null;
        
        System.runas(testUser) {
            Test.startTest();
            demande4.Description = 'Details';
            demande4.Details__c = 'TITRE';
            demande4.Reason = 'Alerte environnement';
            demande4.Impact__c = 'Général';
            demande4.Urgence__c = 'Urgente';
            demande4.Service__c = 'S111';
            demande4.Motif_Depannage__c = 'M2111';
            update demande4;
            Test.setMock(HttpCalloutMock.class, 
                new AP118_ConnecteurDACRC_Mock_TEST(502, 'KO', '{"access_token":"NotGood"}', null, null));
            AP118_ConnecteurDACRC.sendCase(demande4.id, 'good site');

            Test.stopTest();
        }
    }
  /*  
    
    @isTest
    static void testcalloutConsigne_Multimock_exception()
    {
        User testUser = testgetenvUser();
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper
        Map<String, HttpCalloutMock> mocks = new Map<String, HttpCalloutMock>();
        webservicelog__c wsLog = null;
        HttpCalloutMock nullMock = null;
        
        HttpCalloutMock multiCalloutMock = new AP115_Consigne_MultiMocks(mocks);
        ((AP115_Consigne_MultiMocks)(multiCalloutMock)).addRequestMock('callout:WebSite', nullMock);
        
        System.runas(testUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            consigneWrapper = AP115_Consigne.calloutConsigne('good date', 'good site', 'good type');
            System.assertEquals(true, consigneWrapper.isError,
                'le consigneWrapper devrait avoir une erreur');
            
            System.assertEquals( 'There is a MultiMocks exception.',
                consigneWrapper.strError, 
                'le consigneWrapper devrait avoir un message d erreur MultiMocks');
            Test.stopTest();
        }
    }
    

    // vérifier que le weblogs a bien été créer via une requête SOQL
    
    @isTest
    static void testcalloutConsigne_ok()
    {
        User testUser = testgetenvUser();
        AP118_ConnecteurDACRC.Demande_OrdreTravailWrapper demande_OTWrapper
        webservicelog__c wsLog = null;

        System.runas(testUser) {

            WebServiceCall__mdt consigne = WebServiceCall__mdt.getInstance('consigneCall');
            String suffixeUrl = consigne.suffixeURL__c; 
            String dateDemande = 'good date';
            String site = 'good site';
            String typeDemande = 'good type';
            String respondeBody = '{"presencePlanificateur":false,"isSIU":true,"idSIA":"SIU HIVER DRGCA 1 FSR7"' 
            + ',"dateTraitementDiffere":"2022-05-02T07:59:00",' 
            + '"consignes":[{"idSIA":"SIU HIVER DRGCA 1 FSR7","numero":1,"matricule":"25793N"' 
            + ',"dkCodeRessource":"H00006189H","typeRessource":1,"denomination":"BOUSSAC PATRICK"}]}';

            Test.startTest();

            Map<String, HttpCalloutMock> mocks = new Map<String, HttpCalloutMock>();

            mocks.put('callout:WebSite', (HttpCalloutMock)(new AP118_ConnecteurDACRC_Mock_TEST(200, 'OK', '{"access_token":"unBonToken"}', null, null)));

            String endpoint = 'callout:WebSiteConsigneURL' + suffixeUrl + '?typeDemande=' 
            + typeDemande + '&dateDemande=' + dateDemande + '&site=' + site;
            
            mocks.put(endpoint, (HttpCalloutMock)(new AP118_ConnecteurDACRC_Mock_TEST(200, 'OK', respondeBody, null, null)));
            HttpCalloutMock multiCalloutMock = new AP115_Consigne_MultiMocks(mocks);

            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            consigneWrapper = AP115_Consigne.calloutConsigne(dateDemande, site, typeDemande);
            
            wsLog = [SELECT StatusCode__c, Response__c, CodeRetour__c FROM webservicelog__c WHERE CreatedById = :testUser.id LIMIT 1];
            
            System.assertEquals( false, consigneWrapper.isError,
                'le consigneWrapper ne devrait pas avoir une erreur');
            System.assertEquals( 'SIU HIVER DRGCA 1 FSR7', consigneWrapper.idSIA,
                'le consigneWrapper ne devrait pas avoir une erreur');
            System.assert(wsLog != null, 'pas de log renseigné');
            
            Test.stopTest();
        }
    }
    */
}