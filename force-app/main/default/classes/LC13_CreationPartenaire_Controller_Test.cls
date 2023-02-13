@isTest
public class LC13_CreationPartenaire_Controller_Test {
    @isTest
    static void CreationPartenaire() {
        Pays__c pay = new Pays__c();
        pay.Abreviation__c = 'DZ';
        pay.Nom__c = 'ALGERIE';
        pay.Name  = 'ALGERIE';
        insert pay;
        //create user and add bypass
        User u2 = testUtilsC360.CreateUser('standt18', 'user21111@testorg2.com', 'Testing2', Label.AdminProfileId, 'user2rrr@testorg2.com');
        u2 = testUtilsC360.bypassUser(u2);
        insert u2;
        //run test as user
        System.runAs(u2){
            Account acc = testUtilsC360.createAccount('testAccount', 'ALGERIE', 'Public', Label.WS11_OUV, false, 'EDF', '50896193500022', 'abcdef123');
            String accStr = JSON.serialize(acc);
            Test.startTest();
            WS_endpoint__c myEndpoint = new WS_endpoint__c();
            myEndpoint.Name = 'Sirene';
            myEndpoint.Endpoint__c = 'https://data.opendatasoft.com/api/records/1.0/search/?dataset=sirene%40public';
            insert myEndpoint;
            LC13_CreationPartenaire_Controller.getIfSiretExists('39204446700034');
            LC13_CreationPartenaire_Controller.getAccountInfos('39204446700034');
            LC13_CreationPartenaire_Controller.canCreateAcc();
            LC13_CreationPartenaire_Controller.getRecordTypes();
            LC13_CreationPartenaire_Controller.insertAccounts(accStr);
            LC13_CreationPartenaire_Controller.getEffectifValues();
            LC13_CreationPartenaire_Controller.getSegmentValues();
            LC13_CreationPartenaire_Controller.getSousSegmentValues();
            LC13_CreationPartenaire_Controller.base64ToBits('200');
            LC13_CreationPartenaire_Controller.getMapSS('a', 'b', 'c');
            LC13_CreationPartenaire_Controller.checkIfModeMaintenance();
            Mode_Maintenance__c mm = new Mode_Maintenance__c();
            mm.En_mode_maintenance__c = true;
            insert mm;
            LC13_CreationPartenaire_Controller.checkIfModeMaintenance();

            Test.stopTest();
        }
    }
    @isTest
    static void BaseSireneInfos(){
        //create user and add bypass
        User u2 = testUtilsC360.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', Label.AdminProfileId, 'user2rrr@testorg2.com');
        u2 = testUtilsC360.bypassUser(u2);
        insert u2;
        //run test as user
        System.runAs(u2){
            CodeActiviteLocalSegment__c CALS = new CodeActiviteLocalSegment__c();
            CALS.CodeActiviteLocal__c = '7022Z';
            CALS.Libelle__c = 'b';
            CALS.Segment__c = 'c';
            CALS.SousSegment__c = 'd';
            CALS.name = 'test';
            insert CALS;

            Pays__c pay = new Pays__c();
            pay.Abreviation__c = 'DZ';
            pay.Nom__c = 'ALGERIE';
            pay.Name  = 'ALGERIE';
            insert pay;

            Account acc = testUtilsC360.createAccount('testAccount', 'ALGERIE', 'Public', Label.WS11_OUV, false, 'EDF', '50896193500022', 'abcdef123');
            Test.setMock(WebServiceMock.class, new wwwDalkiaFrReferentielPartenaireMockImpl());
            insert acc;

            Test.startTest();
            // Create the mock response based on a static resource

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetSireneForTestClass');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);
            WS01_BaseSirene.DoCalloutAndRteurnInfos('39204446700034');
            WS01_BaseSirene.DoCallout('39204446700034', acc.id);

            Test.stopTest();
        }
    }

}