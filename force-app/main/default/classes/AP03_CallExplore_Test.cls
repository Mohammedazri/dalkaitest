/*** The aim of this class is to test the functionality of the class AP03_CallExplore ***/
@isTest
public class AP03_CallExplore_Test {
    
    @isTest
    static void testExplore(){
        List<WS_endpoint__c> ListEndpoint= new List<WS_endpoint__c>();
        WS_endpoint__c myEndpoint1= new WS_endpoint__c();
        myEndpoint1.Name='Explore Marchés Publics';
        myEndpoint1.Cle_Client__c='E4A3A4D8-3F95-4533-9C38-E0237B4AE63E';   
        myEndpoint1.Endpoint__c='https://extranet.explore.fr/exploreapi/api/DALKIA/GetMarchesPublics';
        myEndpoint1.Lien_explore__c='http://extranet.explore.fr/dotnet/AccessByWebservice.aspx?page=AffichageMarchePublic.aspx?projet=';
        myEndpoint1.Nombre_de_jours__c=1;
        ListEndpoint.add(myEndpoint1);
        WS_endpoint__c myEndpoint2= new WS_endpoint__c();
        myEndpoint2.Name='Explore Mouvements utilisateurs';
        myEndpoint2.Cle_Client__c='E4A3A4D8-3F95-4533-9C38-E0237B4AE63E';   
        myEndpoint2.Endpoint__c='https://extranet.explore.fr/exploreapi/api/DALKIA/GetMouvements';
        myEndpoint2.Lien_explore__c='http://extranet.explore.fr/dotnet/AccessByWebservice.aspx?page=AffichageMarchePublic.aspx?projet=';
        myEndpoint2.Nombre_de_jours__c=1;
        ListEndpoint.add(myEndpoint2);
        WS_endpoint__c myEndpoint3= new WS_endpoint__c();
        myEndpoint3.Name='Explore Projet des promoteurs';
        myEndpoint3.Cle_Client__c='E4A3A4D8-3F95-4533-9C38-E0237B4AE63E';   
        myEndpoint3.Endpoint__c='https://extranet.explore.fr/exploreapi/api/DALKIA/GetPromotions';
        myEndpoint3.Lien_explore__c='http://extranet.explore.fr/dotnet/AccessByWebservice.aspx?page=AffichageMarchePublic.aspx?projet=';
        myEndpoint3.Nombre_de_jours__c=1;
        ListEndpoint.add(myEndpoint3);
        insert ListEndpoint; 
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId]; 
        List<User> NewUsersList= New List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        NewUsersList.add(u1);
        User u2 = testUtils.CreateUser('standt13', 'standardusereee@testorg2.com', 'Testing', p.Id, 'standarduser2343r@testorg.com');
        NewUsersList.add(u2);
        User u3 = testUtils.CreateUser('standt11', 'standardusereee@testorg13.com', 'Testing', p.Id, 'standarduser1erwer@testorg.com');
        NewUsersList.add(u3);
        insert NewUsersList;
        SCHD03_AP03_CallExplore sh1 = new SCHD03_AP03_CallExplore();
        String sch = '0 0 23 * * ?'; 
        //DataBase.executeBatch(testBatch);
        system.schedule('testJob', sch, sh1);
        Test.startTest();
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetMarcheForTestClass');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock); 
        // Call method to test
        //AP03_CallExplore AP03  = new AP03_CallExplore();
        AP03_CallExplore.CallExploreMarchePublic(u1.Id, u2.Id, u3.Id);
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock2 = new StaticResourceCalloutMock();
        mock2.setStaticResource('GetPromotionForTestClass');
        mock2.setStatusCode(200);
        mock2.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock2); 
        // Call method to test
        AP03_CallExplore.CallExplorePromotion(u1.Id, u2.Id, u3.Id);
        //  Create the mock response based on a static resource
        StaticResourceCalloutMock mock3 = new StaticResourceCalloutMock();
        mock3.setStaticResource('GetMouvementForTestClass');
        mock3.setStatusCode(200);
        mock3.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock3); 
        // Call method to test
        AP03_CallExplore.CallExploreMouvement(u1.Id, u2.Id, u3.Id);
        Test.stopTest();
    }
}