/**
* This class contains unit tests for validating the behavior of Apex classes AP01_Account
*/
@isTest
public class AP01_Account_Test {
   
    @isTest
    static void SireneTest() {
        Test.startTest();
        WS_endpoint__c myEndpoint= new WS_endpoint__c();
        myEndpoint.Name='Sirene';
        myEndpoint.Endpoint__c='https://data.opendatasoft.com/api/records/1.0/search/?dataset=sirene%40public';
        insert myEndpoint;
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Created_From_Lead__c=true;        
        myaccount.SIRET__c='392043';
        insert myaccount;
        
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetSireneForTestClass');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);       
        WS01_BaseSirene.DoCallout('aaaaa', myaccount.Id);
        
        Test.stopTest();
    }
}