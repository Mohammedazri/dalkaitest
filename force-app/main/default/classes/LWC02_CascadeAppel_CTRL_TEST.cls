@isTest
public class LWC02_CascadeAppel_CTRL_TEST {
    
    @testSetup
    static void setup(){
        
        Id RT_DemandeSTI = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_STI').getRecordTypeId();
        
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_de_depannage').getRecordTypeId();
        
        Id RT_DemandeEncadrement = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                            .get('Demande_d_encadrement').getRecordTypeId();
        
        Id RT_ConsigneAuto = Schema.SObjectType.Consigne__c.getRecordTypeInfosByDeveloperName()
                            .get('Consignes_Automatique').getRecordTypeId();
        
        Id RT_ConsigneManuelle = Schema.SObjectType.Consigne__c.getRecordTypeInfosByDeveloperName()
                            .get('Consignes_Manuelle').getRecordTypeId();

        Id profileId = [SELECT Id FROM Profile WHERE Name='Téléopérateur' LIMIT 1].Id;
        
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        Emplacement__c emplacement2 = testUtils.insertEmplacement('Emplacement 2', false, 'DKCode 2');

        Contact contact = testUtils.insertContact('FirstName', 'LastName', '06123456789', 'test@test.com');
        
        User user1 = testUtils.insertUser('Alias 1', 'testUser1@dalkiadarc.com', 'LastName 1', profileId, 'testUser1@dalkiadarc.com', 'DkCode1');
        User user2 = testUtils.insertUser('Alias 2', 'testUser2@dalkiadarc.com', 'LastName 2', profileId, 'testUser2@dalkiadarc.com', 'DkCode2');

        Case demande1 = testUtils.insertDemande('Subject 1', RT_DemandeSTI, contact, emplacement1, 'En cours de traitement');
        Case demande2 = testUtils.insertDemande('Subject 2', RT_DemandeDepannage, contact, emplacement2, 'En cours de traitement');
        Case demande3 = testUtils.insertDemandeDureeGlobal('Subject 3', RT_DemandeSTI, contact, emplacement2, 'En cours de traitement');

        testUtils.insertConsigne(demande1, RT_ConsigneManuelle, 'Matricule 1', 'Nom Technicien 1', '06123456789', null, 'Non Contacté', false);
        testUtils.insertConsigne(demande1, RT_ConsigneManuelle, 'Matricule 2', 'Nom Technicien 2', '06123456788', null, 'Non Contacté', false);
        testUtils.insertConsigne(demande1, RT_ConsigneManuelle, 'Matricule 3', 'Nom Technicien 3', '06123456787', null, 'Différé', false);
        testUtils.insertConsigne(demande1, RT_ConsigneManuelle, 'Matricule 4', 'Nom Technicien 4', '06123456786', 1, 'Non Contacté', false);

        testUtils.insertConsigne(demande2, RT_ConsigneManuelle, 'Matricule 5', 'Nom Technicien 5', '06123456789', null, 'Non Contacté', false);
        //testUtils.insertConsigne(demande2, RT_ConsigneManuelle, 'Matricule 7', 'Nom Technicien 7', '06123456787', null, 'Attribué', false);

        testUtils.insertConsigne(demande3, RT_ConsigneManuelle, 'Matricule 8', 'Nom Technicien 8', '06123456788', null, 'Non Contacté', false);
    }

    @isTest
    static void getData_Test() {
        List<Case> listeDemandes = testUtils.getAllDemande();

        Test.startTest();
            LWC02_CascadeAppel_CTRL.CascadeAppelWrapperResponse response = LWC02_CascadeAppel_CTRL.getData(listeDemandes[0].Id);
        Test.stopTest();

        System.assertNotEquals(response, null);
        System.assertEquals(response.listConsignes.size(), 3);
        //System.assertEquals(response.isReadOnly, /*false*/ true);
    }

    @isTest
    static void saveConsignes_Test() {
        List<Consigne__c> listeConsignes = testUtils.getAllConsignes();
        listeConsignes[0].Reponse__c = 'Attribué';

        Test.startTest();
            Boolean response = LWC02_CascadeAppel_CTRL.saveConsignes(listeConsignes);
        Test.stopTest();        
        System.assertEquals(response, true);

        listeConsignes = new List<Consigne__c>();
    
        response = LWC02_CascadeAppel_CTRL.saveConsignes(listeConsignes);

        System.assertEquals(response, false);
    }

    @isTest
    static void getDemande_Test() {
        List<Case> listeDemandes = testUtils.getAllDemande();
        Test.startTest();
            Case demande = LWC02_CascadeAppel_CTRL.getDemande(listeDemandes[0]?.Id);
        Test.stopTest();

        System.assertNotEquals(demande, null);
    }

    @isTest
    static void getConsigneUsers_Test() {
        List<Consigne__c> listConsignes = testUtils.getAllConsignes();

        Map<String, List<Consigne__c>> mapDKConsignes = new Map<String, List<Consigne__c>>();
        mapDKConsignes.put('DkCode1', listConsignes);

        List<User> listUsers = [SELECT Id, DkCode__c FROM User WHERE DkCode__c = 'DkCode1'];

        Test.startTest();
            List<Consigne__c> resultatConsignes = LWC02_CascadeAppel_CTRL.getConsigneUsers(mapDKConsignes);
        Test.stopTest();

        System.assertNotEquals(resultatConsignes, null);
        System.assertEquals(resultatConsignes[0].User__c, listUsers[0].Id);
    }

    @isTest
    static void getLayoutMetadata_Test(){
        String metadata = '';
        Test.startTest();
            metadata = LWC02_CascadeAppel_CTRL.getLayoutMetadata();
        Test.stopTest();

        System.assertNotEquals(metadata, '');
    }

    @isTest
    static void calloutConsigne_Test()
    {
        User testUser = testUtils.getUserByEmail('testUser1@dalkiadarc.com')[0];
        //testUser.BypassValidationRules__c = true;
        //update testUser;
        AP115_Consigne.ConsigneWrapper consigneWrapper;

        List<Case> listeDemandes = testUtils.getAllDemande();
        listeDemandes[0].OwnerId = testUser.Id;
        update listeDemandes;

        System.runas(testUser) {

            WebServiceCall__mdt consigne = WebServiceCall__mdt.getInstance('consigneCall');
            String suffixeUrl = consigne.suffixeURL__c; 

            String site = 'DKSource';
            String typeDemande = 'sti';
            String dateDemande = 'testDate';
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
            Boolean result = LWC02_CascadeAppel_CTRL.callWebServiceCascadeAppel(listeDemandes[0].Id);
            System.AssertEquals(true, result, 'Test d\'insertion des consignes');
            Test.stopTest();
        }
    }
}