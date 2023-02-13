/**
*@author Jimmy Khalil
*@date 09/07/2021
*@description Génère une notification par cloche et par mail
*@test class: AP101_Case_Test (100%)
*/
public class AP101_Case {
    
    public static void notifyUser(Map<Id,Case> mapNewCases){
        
        // Email template
        list<EmailTemplate> listemailTemplate = [SELECT Id, Subject, HtmlValue, Body,DeveloperName 
                                                 FROM EmailTemplate 
                                                 WHERE DeveloperName ='TemplateInsatisfactionClient'];
        
        // Id du custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                   FROM CustomNotificationType 
                                                   WHERE DeveloperName='Alerte_demande'];
        
        
        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        
        // Set the contents for the notification
        notification.setTitle(Label.AP101_NotifTitle);
        notification.setBody(Label.AP101_NotifBody);
        
        // Set the notification type
        notification.setNotificationTypeId(notificationType.Id);
        
        List<Messaging.SingleEmailMessage> listToSend = new List<Messaging.SingleEmailMessage>();
        
        if(listemailTemplate<>null && listemailTemplate.size()>0){
            EmailTemplate emTemp = listemailTemplate[0];
            
            for(Case newCases: mapNewCases.values()){
                //on prend seulement les demandes cree par MC Connect-CRM
                if(newCases.CreatedById == Label.AP101_MCConnectId && newCases.ContactId != null){
                    
                    //prepare le mail a envoyer au contact associe au demande
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    
                    //destinataire
                    message.toAddresses = new List<String>{newCases.OwnerId} ;
                        
                        //contenu    
                        String htmlBody = emTemp.HtmlValue;
                    htmlBody = htmlBody.replace('{!Case.OwnerFirstName}',newCases.ZZZ_Tech_Owner_FirstName__c );
                    htmlBody = htmlBody.replace('{!Case.Contact}',newCases.ZZZ_Tech_Contact_Name__c );
                    htmlBody = htmlBody.replace('{!Case.ContactLink}',Label.Env_Link + newCases.ContactId );
                    htmlBody = htmlBody.replace('{!Case.Type_de_demande__c}',newCases.Type_de_demande__c );
                    htmlBody = htmlBody.replace('{!Case.CaseNumber}',newCases.CaseNumber ); 
                    htmlBody = htmlBody.replace('{!Case.Link}', Label.Env_Link + newCases.Id); 
                    
                    String subjectEmail = Label.AP101_Subject;
                    subjectEmail = subjectEmail.replace('{!Case.Contact}',newCases.ZZZ_Tech_Contact_Name__c);
                    subjectEmail = subjectEmail.replace('{!Case.Type_de_demande__c}',newCases.Type_de_demande__c);
                    message.setSubject(subjectEmail);
                    message.setHtmlBody(htmlBody);
                    
                    //expediteur
                    //smile@dalkia.fr
                    message.setOrgWideEmailAddressId(Label.AP101_OrgWideEmailAddressId);
                    message.setUseSignature(false);
                    
                    listToSend.add(message);
                    
                    notification.setTargetId(newCases.Id);
                    notification.send(new set<string>{newCases.OwnerId});
                }
            }
            
            //envoyer les mails
            Messaging.SendEmailResult[] results = Messaging.sendEmail(listToSend); 
            
        }
    }
}