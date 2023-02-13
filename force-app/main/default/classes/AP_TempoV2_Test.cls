@isTest
public class AP_TempoV2_Test {
    
    private static final String TEST_TOKEN = 'test_token';
    private static final String TEST_DATE_DEMANDE = '2022-01-01';
    private static final String TEST_SITE = 'test_site';
    private static final String TEST_TYPE_DEMANDE = 'test_type';
    private static final String TEST_CASE_ID = '500300000001234';
    
    private static Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_depannage').getRecordTypeId();
    private static Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');   
    private static Contact contact1 = testUtils.insertContact('FirstName1', 'LastName1', '0612345678', 'test1APIConDACRC@test.com');
    private static Case demande1 = testUtils.insertDemande('Subject', RT_DemandeDepannage, contact1, emplacement1, 'A Filtrer');

    @isTest
    static void test_parse() {
        // Arrange
        String json = '{"isError":false,"strError":"","presencePlanificateur":true,"isSIU":false,"idSIA":"123","dateTraitementDiffere":"2022-01-01T00:00:00","consignes":[{"idSIA":"123","numero":1,"matricule":"ABC123","dkCodeRessource":"12345","typeRessource":1,"denomination":"John Smith","isRemplacant":false,"delai":30,"moyenContact":"email","numeroAppel":"555-555-5555"}]}';

        // Act
        AP_TempoV2.ConsigneWrapper result = AP_TempoV2.parse(json);

        // Assert
        System.assertNotEquals(null, result);
        System.assertEquals(false, result.isError);
        System.assertEquals('', result.strError);
        System.assertEquals(true, result.presencePlanificateur);
        System.assertEquals(false, result.isSIU);
        System.assertEquals('123', result.idSIA);
        System.assertEquals(DateTime.newInstance(2022, 01, 01, 1, 0, 0), result.dateTraitementDiffere);
        System.assertEquals(1, result.consignes.size());
        System.assertEquals('123', result.consignes[0].idSIA);
        System.assertEquals(1, result.consignes[0].numero);
        System.assertEquals('ABC123', result.consignes[0].matricule);
        System.assertEquals('12345', result.consignes[0].dkCodeRessource);
        System.assertEquals(1, result.consignes[0].typeRessource);
        System.assertEquals('John Smith', result.consignes[0].denomination);
        System.assertEquals(false, result.consignes[0].isRemplacant);
        System.assertEquals(30, result.consignes[0].delai);
        System.assertEquals('email', result.consignes[0].moyenContact);
        System.assertEquals('555-555-5555', result.consignes[0].numeroAppel);
    }

    @isTest
    static void test_getToken() {
        // Arrange
        AP_TempoV2.ConsigneWrapper consigneWrapper = new AP_TempoV2.ConsigneWrapper();
        Test.setMock(HttpCalloutMock.class, new AP_TempoV2_TestHttpCalloutMock());

        // Act
        String result = AP_TempoV2.getToken(consigneWrapper);

        // Assert
        System.assertEquals('test_access_token', result);
        System.assertEquals(false, consigneWrapper.isError);
        System.assertEquals('', consigneWrapper.strError);
  }
    
    @isTest
    static void testGetDemande() {
        
        demande1.PlanificateurPresent__c = true;
        //demande1.idsia__c = 'test_id';
        update demande1;
        /*Case testCase = new Case();
        testCase.Id = TEST_CASE_ID;
        demande1.PlanificateurPresent__c = true;
        demande1.idsia__c = 'test_id';
        insert testCase;*/
    
        Case result = AP_TempoV2.getDemande(demande1.id);
        System.assertEquals(demande1.id, result.Id, 'Id should be equal to ' + demande1.id);
        System.assertEquals(true, result.PlanificateurPresent__c, 'PlanificateurPresent__c should be true');
        //System.assertEquals('test_id', result.idsia__c, 'idsia__c should be test_id');
    }
    
    
    static void test_getConsigne() {
        // create test data
        

        // test the getConsigne method
        AP_TempoV2.ConsigneWrapper consigneWrapper = AP_TempoV2.getConsigne('test access token', demande1, '2022-01-01', 'Test Site', RT_DemandeDepannage);

        // assert the returned values
        System.assertEquals(false, consigneWrapper.isError);
        System.assertEquals('', consigneWrapper.strError);
        System.assertEquals(false, consigneWrapper.presencePlanificateur);
        System.assertEquals(false, consigneWrapper.isSIU);
        System.assertEquals('', consigneWrapper.idSIA);
        System.assertEquals(null, consigneWrapper.dateTraitementDiffere);
        System.assertNotEquals(null, consigneWrapper.consignes);

        // delete test data
        //delete testCase;
    }



    private class AP_TempoV2_TestHttpCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"access_token":"test_access_token"}');
            return response;
        }
    }
}