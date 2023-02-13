/*--------------------------------------------------------------------------------------------------------------------------
Author: Serouj Jamijian 
Company: EI-Technologies
Description: Class used as an apex controller for the lightning component LC15_ExploreIframe
Test Class: LC15_ExploreIframe_Controller_TEST
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC15_ExploreIframe_Controller {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Serouj Jamijian 
Company: EI-Technologies
Description: method that use the accountID to return the URL for the iframe 
Inputs: String 
Returns: String
----------------------------------------------------------------------------------------------------------------------------*/  
    @AuraEnabled
    public static string getAccountSIRET(string AccountId){
        WS_endpoint__c myWSEndpoint = WS_endpoint__c.getValues('Explore_Iframe');
        
        string returnValue;
        list<Account> listAccounts = [SELECT Id, SIRET__c FROM Account WHERE Id=:AccountId];
        if(listAccounts.size() > 0){
            returnValue = string.format(myWSEndpoint.Lien_explore__c, new List<String> {string.valueof(listAccounts.get(0).SIRET__c), myWSEndpoint.Cle_Client__c});
        }
        return returnValue; 
    }
}