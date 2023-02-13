@isTest
public class AP02_ContentDocumentLink_test 
{
    static testMethod void testEvent()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        insert u2;
        
        System.runAs(u2) 
        {
            event testEvent = new event(subject ='test',compteRendu__c = '',DurationInMinutes =360,ActivityDateTime=date.Today());
            insert testEvent;
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
            ContentVersion cv = new ContentVersion();
            cv.title = 'test content';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;          
            insert cv;
            
            test.startTest();
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=testEvent.id;
            contentlink.ShareType= 'V';
            contentlink.LinkedEntityId=testEvent.id;
            contentlink.ContentDocumentId=documents[0].Id;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink;
            test.stopTest();
        }
    }
}