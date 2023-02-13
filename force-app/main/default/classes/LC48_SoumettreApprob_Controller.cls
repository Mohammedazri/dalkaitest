/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: Class that handles Approval 
* @Test Class:LC48_SoumettreApprob_Cont_test  
* @Coverage: 93% 
*/
public without sharing class LC48_SoumettreApprob_Controller {
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description:  The method creates to each user an instance of the Object Approbation__c and handles a notification system and email alert.  
* @inputs: id , Fiche_de_synthese__c , String 
* @returns: - 
*/   
    @AuraEnabled
    public static String lunchApprove(Id recordId , Fiche_de_synthese__c FDS , String ApprobComm)
    {
        
        list<Fiche_de_synthese__c> listFDS1 = [SELECT id, name,Date_derniere_soumission__c 
                                               FROM Fiche_de_synthese__c 
                                               WHERE id =:recordId];
        Fiche_de_synthese__c FDS1 = new Fiche_de_synthese__c();
        if(listFDS1<>null && listFDS1.size()>0)
        {
            FDS1 = listFDS1[0];
        }
        List<id> listUser = new List<Id>(); // add all approbateurs to this list
        String appr1 =FDS.Approbateur1__c;
        String appr2 =FDS.Approbateur2__c; 
        String appr3 =FDS.Approbateur3__c;
        String appr4 =FDS.Approbateur4__c;
        
        id userID = UserInfo.getUserId();
        String result;
        
        if(FDS.Approbateur1__c == userID || FDS.Approbateur2__c == userID || FDS.Approbateur3__c == userID || FDS.Approbateur4__c == userID)
        {
            result = 'Veuillez choisir un approbateur autre que l\' utilisateur actif';
            return result;
        }
        
        if (appr1.left(3)=='005') // check if a user is placed in the field
        {
            listUser.add(FDS.Approbateur1__c); // add approbateur 1 
        }
        if (appr2.left(3)=='005')
        {
            listUser.add(FDS.Approbateur2__c); // add approbateur 2
        }
        if (appr3.left(3)=='005')
        {
            listUser.add(FDS.Approbateur3__c);  // add approbateur 3
        }
        
        if (appr4.left(3)=='005')
        {
            listUser.add(FDS.Approbateur4__c); // add approbateur 4
        }
        
        Id recrdApres = Schema.SObjectType.Approbation__c.getRecordTypeInfosByName().get(Label.LC48_RTName_ap).getRecordTypeId();
        Id recrdAvnt = Schema.SObjectType.Approbation__c.getRecordTypeInfosByName().get(Label.LC48_RTName_av).getRecordTypeId();
        
        List<Approbation__c> listApp = new List<Approbation__c>();
        
        Approbation__c app1 = new Approbation__c(); // create new approbtion for submitting
        app1.CommentaireS__c = ApprobComm;
        app1.Date_de_soumission__c = DateTime.now();
        app1.tech_FicheDeSynthese__c = recordId;
        app1.tech_Attribue__c = UserInfo.getUserId();
        app1.Statut__c=Label.LC48_Soumis;
        app1.Name=Label.LC48_Nom_Demande;
        app1.RecordTypeId=recrdApres; // to hide buttons
        listApp.add(app1);
        
        for (Id usId:listUser)
        {
            Approbation__c app = new Approbation__c(); // create a new approbation for approver
            app.CommentaireS__c = ApprobComm;
            app.Date_de_soumission__c = DateTime.now();
            app.tech_FicheDeSynthese__c = recordId;
            app.tech_Attribue__c = usId;
            app.Approbateur_actuel__c = UserInfo.getUserId(); 
            app.Statut__c=Label.LC48_SansReponse;
            app.name=Label.LC48_Nom_Validation;
            app.RecordTypeId=recrdAvnt;// to show buttons Approuver et rejetter
            listApp.add(app);
        }
        try{
            insert listApp;
        }
        catch(DmlException e){
            system.debug('Exception ...'+e.getMessage());
            return e.getMessage();
        }
        
        Set<Id> setId = new Set<Id>(listUser);
        List<User> listUsr = [SELECT id,name 
                              FROM User 
                              WHERE id in:setId];
        Map<id,Approbation__c> mapUserApp = new Map<id,Approbation__c>();
       
        for(Approbation__c app:listApp)
        {
            mapUserApp.put(app.tech_Attribue__c , app);   
        }
            
        
        list<EmailTemplate> listemailTemplate = [select Id, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName ='TemplateApprobation'];
        for(User usr:listUsr)
        {
            list<String> us = new List<String>();
            us.add(usr.id);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
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
                htmlBody = htmlBody.replace('{!User.LastName}',usr.Name );
                htmlBody = htmlBody.replace('{!User.FirstName}',UserInfo.getName() );
                htmlBody = htmlBody.replace('{!Fiche_de_synthese__c.Name}',FDS1.name ); 
                htmlBody = htmlBody.replace('{!Link}', Label.Env_Link + mapUserApp.get(usr.id).Id); 
                
                String plainBody = emTemp.Body;
                plainBody = plainBody.replace('{!User.LastName}',usr.Name );
                plainBody = plainBody.replace('{!User.FirstName}',UserInfo.getName() );
                plainBody = plainBody.replace('{!Fiche_de_synthese__c.Name}',FDS1.name ); 
                plainBody = plainBody.replace('{!Link}', Label.Env_Link + mapUserApp.get(usr.id).Id);
                message.setSubject('Approbation de la fiche de synthèse');
                message.setHtmlBody(htmlBody);
                message.setPlainTextBody(plainBody);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);  
            }
            
        }
        
        //mettre a jour le champ date de derniere soumission
        FDS1.Date_derniere_soumission__c = DateTime.now();
        List<User> lstusr=[SELECT id,Name,BypassValidationRules__c 
                           FROM User 
                           WHERE Id =:UserInfo.getUserId() LIMIT 1]; // query current user
        if(lstusr<>null && lstusr.size()>0)
        {
            User usr =  lstusr[0];
            Boolean state = usr.BypassValidationRules__c; // save bypass VR state
            if (!state)
            {
                usr.BypassValidationRules__c = true; // Bypass Validation rules
                update usr;
            }
            try{
                update FDS1;
                
                if (usr.BypassValidationRules__c !=state)
                {
                    usr.BypassValidationRules__c = state; // return Bypass to initial state
                    update usr;
                }
                
            }
            catch(Exception e)
            {
                if (usr.BypassValidationRules__c !=state)
                {
                    usr.BypassValidationRules__c = state;
                    update usr;
                }
                return e.getMessage();
            }
        }
        return 'OK';
        
    }
}