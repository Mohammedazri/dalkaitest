/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description:test class for Batch01_DeleteLead
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch01_DeleteLead_Test {
    @isTest
    static  void testBatch_DeleteLead(){
        lead myLead = new Lead();
        myLead.LastName='testAccount';
        myLead.City='aaaa';
        myLead.Country='bbbbb';
        myLead.PostalCode='aaa';
        myLead.State='aaa';
        myLead.Street='aaa';
        myLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(Label.RT_LeadMouvement).getRecordTypeId();
        myLead.Lien_Explore__c = 'test';
        insert myLead;
        Test.setCreatedDate(myLead.Id, DateTime.newInstance(2017,2,15));
        
        Test.startTest();
        SCHD01_Batch01_DeleteLead.scheduleMe();
        Test.stopTest();
    }
}