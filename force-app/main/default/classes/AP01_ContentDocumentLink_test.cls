/*** The aim of this class is to test the functionality of the class AP01 ContentDocumentLink ***/
@isTest
public class AP01_ContentDocumentLink_test {
    
    @isTest
    static  void testVerificationRevueOffre()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            Opportunity opp1 = testUtils.createOpportunity('testOpportunity',date.Today().addDays(1850),label.OpportunityStatusEnCours, label.OpportunityStagePiste);
            opp1.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            opp1.Type_pers__c=Label.PV_Opp_Type_Nouveau;
            insert opp1;
            event testEvent = new event(subject ='test',compteRendu__c = '',DurationInMinutes =360,ActivityDateTime=date.Today());
            insert testEvent;
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body'); 
            ContentVersion cv1 = new ContentVersion();
            cv1.title =  Label.Revue_Offre +' test';      
            cv1.PathOnClient ='test';           
            cv1.VersionData =beforeblob;          
            
            ContentVersion cv2 = new ContentVersion();
            cv2.title =  Label.Revue_Offre +' test2';      
            cv2.PathOnClient ='test2';           
            cv2.VersionData =beforeblob;  
            
            list<ContentVersion> listContentVersion = new list<ContentVersion>();
            listContentVersion.add(cv1);
            listContentVersion.add(cv2);
            insert listContentVersion; 
            
            test.startTest();
            list<ContentVersion> testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id in(:cv1.Id,:cv2.Id)];
            list<id> listContentDocument = new list<id>();
            
            ContentDocumentLink contentlink1=new ContentDocumentLink();
            contentlink1.ShareType= 'V';
            contentlink1.LinkedEntityId = opp1.Id;            
            contentlink1.Visibility = 'AllUsers';
            
            ContentDocumentLink contentlink2=new ContentDocumentLink();
            contentlink2.ShareType= 'V';
            contentlink2.LinkedEntityId = testEvent.Id; 
            contentlink2.Visibility = 'AllUsers';
            
            for(ContentVersion content :testContent){
                listContentDocument.add(content.ContentDocumentId);  
                if(content.id == cv1.Id){
                    contentlink1.ContentDocumentId=content.ContentDocumentId;}
                else if(content.id == cv2.Id){
                    contentlink2.ContentDocumentId=content.ContentDocumentId;}}
            list<ContentDocumentLink> listContentDocumentLink = new list<ContentDocumentLink>();
            listContentDocumentLink.add(contentlink1);
            listContentDocumentLink.add(contentlink2);
            list<ContentDocument> testContentDocument = [SELECT id FROM ContentDocument where Id in :listContentDocument]; 
            insert listContentDocumentLink;
            cv1.Title = 'test';
            update cv1;
            delete testContentDocument;
            test.stopTest();   
        }
    }
}