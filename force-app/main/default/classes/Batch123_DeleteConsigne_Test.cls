/*--------------------------------------------------------------------------------------------------------------------------
Company: EI-Technologies
Description:test class for Batch123_DeleteConsigne
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch123_DeleteConsigne_Test { 
    @isTest
    static  void testBatch_DeleteConsigne(){
        
        Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_depannage').getRecordTypeId();
        
        Id RT_ConsigneAuto = Schema.SObjectType.Consigne__c.getRecordTypeInfosByDeveloperName().get('Consignes_Automatique').getRecordTypeId();
        
        Id profileId = [SELECT Id FROM Profile WHERE Name='Téléopérateur' LIMIT 1].Id;
        
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        Emplacement__c emplacement2 = testUtils.insertEmplacement('Emplacement 2', false, 'DKCode 2');

        Contact contact = testUtils.insertContact('FirstName', 'LastName', '06123456789', 'test@test.com');
        
        User user1 = testUtils.insertUser('Alias 1', 'testUser1@dalkiadarc.com', 'LastName 1', profileId, 'testUser1@dalkiadarc.com', 'DkCode1');
        User user2 = testUtils.insertUser('Alias 2', 'testUser2@dalkiadarc.com', 'LastName 2', profileId, 'testUser2@dalkiadarc.com', 'DkCode2');

        Case demande1 = testUtils.insertDemande('Subject 1', RT_DemandeDepannage, contact, emplacement1, 'En cours de traitement');
        LWC02_CascadeAppel_CTRL.CascadeAppelWrapperResponse response = LWC02_CascadeAppel_CTRL.getData(demande1.Id);
        
        Test.startTest();
        //SCHD123_Batch123_DeletedConsigne.scheduleMe();
        Batch123_DeleteConsigne myBatch= new Batch123_DeleteConsigne();
        ID batchprocessid = Database.executeBatch(myBatch,50);
        Test.stopTest();
    }
}