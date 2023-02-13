@isTest
public with sharing class AP115_Consigne_TEST {


    static public User testgetenvUser()
    {
        // mettre en région français
        Profile p = [SELECT Id FROM Profile WHERE Name='Téléopérateur'];
        User u = new User(Alias = 'tele', Email='teleoperateuruser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='teleTesting', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='teleoperateuruser@testorg.com');
        return u;
    }

    @isTest
    static void testgetToken_ok()
    {
        User testUser = testgetenvUser();
        AP115_Consigne.ConsigneWrapper consigneWrapper = new AP115_Consigne.ConsigneWrapper();
        
        System.runas(testUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, 
                         new AP115_Consigne_Mock_TEST(200, 'OK', '{"access_token":"unBonToken"}', null, null));
            String tokenSucces = AP115_Consigne.getToken(consigneWrapper);
            System.assertEquals('unBonToken', tokenSucces , 'token invalide');
            Test.stopTest();
        }
        
    }

    @isTest
    static void testgetToken_ko()
    {
        User testUser = testgetenvUser();
        AP115_Consigne.ConsigneWrapper consigneWrapper = new AP115_Consigne.ConsigneWrapper();
        System.runas(testUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, 
                new AP115_Consigne_Mock_TEST(400, 'KO', '{"access_token":"NotGood"}', null, null));
            String tokenSucces = AP115_Consigne.getToken(consigneWrapper);
            System.assertEquals( '', tokenSucces, 'le token retourné n est pas vide');
            System.assertEquals( true, consigneWrapper.isError,  'le consigneWrapper n a pas d erreur');
            System.assertNotEquals( '', consigneWrapper.strError, 'le consigneWrapper n a pas de message d erreur');
            Test.stopTest();
        }
    }

    @isTest
    static void testgetConsigne_ok() {
        
        User testUser = testgetenvUser();
        AP115_Consigne.ConsigneWrapper consigneWrapper;
        String respondeBody = '{"presencePlanificateur":false,"isSIU":true,"idSIA":"SIU HIVER DRGCA 1 FSR7"' 
            + ',"dateTraitementDiffere":"2022-05-02T07:59:00",' 
            + '"consignes":[{"idSIA":"SIU HIVER DRGCA 1 FSR7","numero":1,"matricule":"25793N"' 
            + ',"dkCodeRessource":"H00006189H","typeRessource":1,"denomination":"BOUSSAC PATRICK"}]}';
        webservicelog__c wsLog = null;
        
        System.runas(testUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, 
                new AP115_Consigne_Mock_TEST(200, 'OK', respondeBody, null, null));
            consigneWrapper = AP115_Consigne.getConsigne('good token', 'good date', 'good site', 'good type');
            wsLog = [SELECT StatusCode__c, Response__c, CodeRetour__c FROM webservicelog__c WHERE CreatedById = :testUser.id LIMIT 1];
            
            System.assertEquals(false, consigneWrapper.isError, 
                'le consigneWrapper ne doit pas avoir d erreur');
            System.assert(wsLog != null, 'pas de log renseigné');
            Test.stopTest();
        }
    }

    @isTest
    static void testgetConsigne_ko() {
        User testUser = testgetenvUser();
        string respondeBody = '{"code":400,"message":"Le format de dateDemande n\'est pas reconnu"}';
        AP115_Consigne.ConsigneWrapper consigneWrapper = new AP115_Consigne.ConsigneWrapper();
        webservicelog__c wsLog = null;
        
        System.runas(testUser) {
            Test.startTest();        
            Test.setMock(HttpCalloutMock.class, 
                new AP115_Consigne_Mock_TEST(400, 'KO', respondeBody, null, null));
            consigneWrapper = AP115_Consigne.getConsigne('good token', 'wrong date', 'good site', 'good type');
            wsLog = [SELECT StatusCode__c, Response__c, CodeRetour__c FROM webservicelog__c WHERE CreatedById = :testUser.id LIMIT 1];
            
            System.assertEquals(true, consigneWrapper.isError, 
                'le consigneWrapper devrait avoir une erreur');
            System.assertEquals('{"code":400,"message":"Le format de dateDemande n\'est pas reconnu"}', 
                consigneWrapper.strError, 
                'le consigneWrapper devrait avoir un message d erreur');
            System.assert(wsLog != null, 'pas de log renseigné');
            Test.stopTest();
        }
    }

    @isTest
    static void testgetToken_exception()
    {
        User testUser = testgetenvUser();
        AP115_Consigne.ConsigneWrapper consigneWrapper = new AP115_Consigne.ConsigneWrapper();
        System.runas(testUser) {
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, 
                new AP115_Consigne_Mock_TEST(400, '', '', null, 'There is a exception.'));
            String tokenSucces = AP115_Consigne.getToken(consigneWrapper);
            System.assertEquals( true, consigneWrapper.isError, 'le consigneWrapper n a pas bien une erreur');
            System.assertEquals( 'There is a exception.', consigneWrapper.strError, 'le consigneWrapper n a pas d erreur');
            
            Test.stopTest();
        }
    }

    @isTest
    static void testgetConsigne_exception() {
        
        User testUser = testgetenvUser();
        AP115_Consigne.ConsigneWrapper consigneWrapper = new AP115_Consigne.ConsigneWrapper();
        webservicelog__c wsLog = null;
        
        System.runas(testUser){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, 
                new AP115_Consigne_Mock_TEST(400, '', '', null, 'There is a exception.'));
            consigneWrapper = AP115_Consigne.getConsigne('good token', 'good date', 'good site', 'good type');
            
            wsLog = [SELECT StatusCode__c, Response__c, CodeRetour__c FROM webservicelog__c WHERE CreatedById = :testUser.id LIMIT 1];
            
            System.assertEquals( true, consigneWrapper.isError, 'le consigneWrapper n a pas bien une erreur');
            System.assertEquals( 'There is a exception.', consigneWrapper.strError, 
                'le consigneWrapper n a pas d erreur');
            System.assert(wsLog != null, 'pas de log renseigné');
            Test.stopTest();
        }
    }
    
    
    @isTest
    static void testcalloutConsigne_ko()
    {
        User testUser = testgetenvUser();
        AP115_Consigne.ConsigneWrapper consigneWrapper;
        webservicelog__c wsLog = null;
        
        System.runas(testUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, 
                new AP115_Consigne_Mock_TEST(400, 'KO', '{"access_token":"NotGood"}', null, null));
            consigneWrapper = AP115_Consigne.calloutConsigne('good date', 'good site', 'good type');
            System.assertEquals(true, consigneWrapper.isError, 
                'le consigneWrapper devrait avoir une erreur');
            
            System.assertEquals( '{"access_token":"NotGood"}',
                consigneWrapper.strError, 
                'le consigneWrapper devrait avoir un message d erreur');
            Test.stopTest();
        }
    }
    
    
    @isTest
    static void testcalloutConsigne_Multimock_exception()
    {
        User testUser = testgetenvUser();
        AP115_Consigne.ConsigneWrapper consigneWrapper;
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
        AP115_Consigne.ConsigneWrapper consigneWrapper;
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

            mocks.put('callout:WebSite', (HttpCalloutMock)(new AP115_Consigne_Mock_TEST(200, 'OK', '{"access_token":"unBonToken"}', null, null)));

            String endpoint = 'callout:WebSiteConsigneURL' + suffixeUrl + '?typeDemande=' 
			+ typeDemande + '&dateDemande=' + dateDemande + '&site=' + site;
            
            mocks.put(endpoint, (HttpCalloutMock)(new AP115_Consigne_Mock_TEST(200, 'OK', respondeBody, null, null)));
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
    
}