@isTest
class LC15_ExploreIframe_Controller_TEST {
     
    public static testMethod void testgetAccountSIRET(){
        WS_endpoint__c myWSEndpoint = new WS_endpoint__c();
        myWSEndpoint.Name = 'Explore_Iframe';
        myWSEndpoint.Lien_explore__c = 'E4A3A4D8-3F95-4533-9C38-E0237B4AE63E';
        myWSEndpoint.Cle_Client__c = 'https://extranet.explore.fr/exploreapi/Iframes/EXPLORE/GetTousFluxParSIREN.aspx?Siren={0}&CleClient={1}&UrlDetail=true&NbLignes=5';
        insert myWSEndpoint;
        
        Account acc = testUtils.createAccount('testAccount1', 'France', 'Public');
        acc.SIRET__c = '123456789';
        acc.NaturePartenaire__c = 'ETAB';
        insert acc;
        LC15_ExploreIframe_Controller.getAccountSIRET(acc.Id);
    }

}