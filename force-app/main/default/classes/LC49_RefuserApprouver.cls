/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: Controller of lightning component that takes care of approval and rejection  
* @Test Class:LC49_RefuserApprouver_test  
* @Coverage: 96%
*/
public without sharing class LC49_RefuserApprouver {
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description:  The method is used to check if the current user has approval right on the record
* @inputs: id  
* @returns: - 
*/   
    @AuraEnabled
    public static Boolean load(Id recordId)
    {
        List<Approbation__c> listApp = [SELECT id,tech_Attribue__c 
                                        FROM Approbation__c 
                                        WHERE id=:recordid];
        if (listApp<> null && listApp[0].tech_Attribue__c==UserInfo.getUserId()) // check if approver is the connected user
        {
            return true;
        }
        else
        {
            return false;
        }
        
    } 
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description:  Method used to approve a FDS.  
* @inputs: id , String 
* @returns: Boolean 
*/ 
    @AuraEnabled
    public static boolean approuver(Id recordId , String comm)
    {
        List<Approbation__c> listApp = [SELECT id,name,statut__c , CommentaireA__c,RecordTypeId ,Date_d_approbation__c,tech_Attribue__r.name,
                                        Approbateur_actuel__c , tech_Attribue__c, tech_FicheDeSynthese__c, tech_FicheDeSynthese__r.name,
                                        Approbateur_actuel__r.name
                                        FROM Approbation__c 
                                        WHERE id=:recordid];
        if(listApp<> null && listApp.size()>0)
        {
            Approbation__c app = listApp[0];
            app.statut__c = Label.AP50_Approuvee;
            app.Date_d_approbation__c = DateTime.now();
            app.CommentaireA__c = comm;
            app.RecordTypeId = Schema.SObjectType.Approbation__c.getRecordTypeInfosByName().get(Label.LC48_RTName_ap).getRecordTypeId();
            try{
                update app;
            }
            catch(DmlException e)
            {
                system.debug('Exception...'+e.getmessage());
            }
            list<String> us = new List<String>();
            us.add(app.Approbateur_actuel__c);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            list<EmailTemplate> listemailTemplate = [select Id, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName ='TemplateReponseApprobation'];
            message.toAddresses = us ;
            message.optOutPolicy = 'FILTER';
            EmailTemplate emTemp = new EmailTemplate();
            if(listemailTemplate<>null && listemailTemplate.size()>0)
            {
                emTemp = listemailTemplate[0];
            }
            if (emTemp<>null)
            {
                String htmlBody = emTemp.HtmlValue;
                htmlBody = htmlBody.replace('{!User.LastName}',app.Approbateur_actuel__r.name );
                htmlBody = htmlBody.replace('{!User.FirstName}',app.tech_Attribue__r.name );
                htmlBody = htmlBody.replace('{!Fiche_de_synthese__c.Name}',app.tech_FicheDeSynthese__r.name );
                htmlBody = htmlBody.replace('{!statut}','approuvé');
                htmlBody = htmlBody.replace('{!Link}', Label.Env_Link + app.tech_FicheDeSynthese__c); 
                
                String plainBody = emTemp.Body;
                plainBody = plainBody.replace('{!User.LastName}',app.Approbateur_actuel__r.name );
                plainBody = plainBody.replace('{!User.FirstName}',app.tech_Attribue__r.name );
                plainBody = plainBody.replace('{!Fiche_de_synthese__c.Name}',app.tech_FicheDeSynthese__r.name );
                plainBody = plainBody.replace('{!statut}','approuvé');
                plainBody = plainBody.replace('{!Link}', Label.Env_Link + app.tech_FicheDeSynthese__c);
                message.setSubject('Réponse à la demande d\'approbation de la Fiche de synthèse');
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);  
            }
            
        }
        return true;
        
    }
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description:  Method used to disapprove a FDS.  
* @inputs: id , String 
* @returns: Boolean 
*/  
    @AuraEnabled
    public static boolean refuser(Id recordId, String comm)
    {
        List<Approbation__c> listApp = [SELECT id,name,statut__c , CommentaireA__c,RecordTypeId ,Date_d_approbation__c,tech_Attribue__r.name,
                                        Approbateur_actuel__c , tech_Attribue__c, tech_FicheDeSynthese__c, tech_FicheDeSynthese__r.name,
                                        Approbateur_actuel__r.name
                                        FROM Approbation__c 
                                        WHERE id=:recordid];
        if(listApp<> null && listApp.size()>0)
        {
            Approbation__c app = listApp[0];
            app.statut__c = Label.Statut_refusee;
            app.Date_d_approbation__c = DateTime.now();
            app.commentaireA__c = comm;
            app.RecordTypeId = Schema.SObjectType.Approbation__c.getRecordTypeInfosByName().get(Label.LC48_RTName_ap).getRecordTypeId();
            try{
                update app;
            }
            catch(DmlException e)
            {
                system.debug('Exception...'+e.getmessage());
            }
           list<String> us = new List<String>();
            us.add(app.Approbateur_actuel__c);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            list<EmailTemplate> listemailTemplate = [select Id, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName ='TemplateReponseApprobation'];
            message.toAddresses = us ;
            message.optOutPolicy = 'FILTER';
            EmailTemplate emTemp = new EmailTemplate();
            if(listemailTemplate<>null && listemailTemplate.size()>0)
            {
                emTemp = listemailTemplate[0];
            }
            if (emTemp<>null)
            {
                String htmlBody = emTemp.HtmlValue;
                htmlBody = htmlBody.replace('{!User.LastName}',app.Approbateur_actuel__r.name );
                htmlBody = htmlBody.replace('{!User.FirstName}',app.tech_Attribue__r.name );
                htmlBody = htmlBody.replace('{!Fiche_de_synthese__c.Name}',app.tech_FicheDeSynthese__r.name );
                htmlBody = htmlBody.replace('{!statut}','refusé');
                htmlBody = htmlBody.replace('{!Link}', Label.Env_Link + app.tech_FicheDeSynthese__c); 
                
                String plainBody = emTemp.Body;
                plainBody = plainBody.replace('{!User.LastName}',app.Approbateur_actuel__r.name );
                plainBody = plainBody.replace('{!User.FirstName}',app.tech_Attribue__r.name );
                plainBody = plainBody.replace('{!Fiche_de_synthese__c.Name}',app.tech_FicheDeSynthese__r.name );
                plainBody = plainBody.replace('{!statut}','refusé');
                plainBody = plainBody.replace('{!Link}', Label.Env_Link + app.tech_FicheDeSynthese__c);
                message.setSubject('Réponse à la demande d\'approbation de la Fiche de synthèse');
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);  
            }
            
        }
        return true;
    }
    
}