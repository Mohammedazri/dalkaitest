/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EI-Technologies
Description: Historisation de l'adresse email du contact au moment de l'envoie de cette campagne dans le champ Email__c
Test Class: AP01_IndividualEmailResult_Test(100%)
History
13/04/2021 Charbel Khoury Hanna  Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP01_IndividualEmailResult {

    public static void SetEmailContact(List<et4ae5__IndividualEmailResult__c> listIndividualEmailResult)
    {
        List<et4ae5__IndividualEmailResult__c> allEmail = [SELECT et4ae5__Contact__r.Email,Email__c
                                                             FROM et4ae5__IndividualEmailResult__c
                                                            WHERE id in :listIndividualEmailResult];
        
        for(et4ae5__IndividualEmailResult__c indEmailResult : allEmail)
        {
            indEmailResult.Email__c = indEmailResult.et4ae5__Contact__r.Email;
        }
        
        if(allEmail.size() > 0)
        {
         	update allEmail;   
        }
    }
}