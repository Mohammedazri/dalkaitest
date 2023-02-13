/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Class used to check if the field SIRET__c is diffrent than null and call the webservice class WS01_BaseSirene
Test Class: AP01_Account_Test
--------------------------------------------------------------------------------------------------------------------------*/
public class AP01_Account {
    public static void CallBaseSirene(List<account> accountList)
    {
        for(account myaccount:accountList)
        {
            if(myaccount.SIRET__c!= null)
            {
                WS01_BaseSirene.DoCallout(string.valueof(myaccount.SIRET__c), myaccount.Id);
            }
        }
    }
    
}