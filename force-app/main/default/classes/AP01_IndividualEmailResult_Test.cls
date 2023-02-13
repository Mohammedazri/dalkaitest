/**
* @author: Charbel Khoury Hanna
* @date: 13/04/2021
* @description: Test Class for "AP01_IndividualEmailResult" 
*/
@isTest
public class AP01_IndividualEmailResult_Test {
    
    static testMethod void test1()
    {
        Account acc = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        insert acc;
        
        Contact cont = testUtils.createContact('test 1', acc.Id, null);
        cont.Phone ='45245';
		insert cont;
        
        /*
        et4ae5__Automated_Send__c autoSend = [SELECT id
                                                FROM et4ae5__Automated_Send__c
                                               WHERE id = 'a1K1n000008Uoq0EAC'];
        */
        
        et4ae5__Automated_Send__c autoSend = new et4ae5__Automated_Send__c();
        autoSend.Name = 'test';
        autoSend.et4ae5__Subject__c = 'test';
        autoSend.et4ae5__EmailName__c = 'Email_Enquete_Satisfaction';
        insert autoSend;
        
        et4ae5__IndividualEmailResult__c indEmailRes = new et4ae5__IndividualEmailResult__c();
        indEmailRes.Name = 'Email_Enquete_Satisfaction';
        indEmailRes.et4ae5__Contact__c = cont.id;
        indEmailRes.et4ae5__Email_ID__c = '10998';
        indEmailRes.et4ae5__FromAddress__c = 'relations.clients@email.dalkia.fr';
        indEmailRes.et4ae5__FromName__c = 'DALKIA, Direction Relations Clients';
        indEmailRes.et4ae5__HardBounce__c = false;
        indEmailRes.et4ae5__Opened__c = false;
        indEmailRes.et4ae5__SoftBounce__c = false;
        indEmailRes.et4ae5__SubjectLine__c = 'Etes-vous satisfait(e) des services de Dalkia ? Dites-nous tout !';
        indEmailRes.et4ae5__TriggeredSendDefinition__c = autoSend.id;
        
        insert indEmailRes;
    }
}