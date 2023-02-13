/*
   @Author : Jacques Akiki
   @CreatedDate : 15/11/2022
   @Description : Class to notify User when a task is Created through API.
 */
public without sharing class AP119_Task {
    public static void notifyUser(list<Task> listTask){
        set<task> setTasks = new set<task>();
        for(Task tk : listTask) {
            if(tk.CreatedById == Label.AP101_MCConnectId && tk.WhoId.getSObjectType().getDescribe().getName() == 'Contact' && tk.Subject == Label.AP119_NotifyBody) {
                setTasks.add(tk);
            }
        }
        if(setTasks != NULL && setTasks.size() > 0) {
            map<id, list<task>> mapContactTask = new map<id, list<Task>>();
            map<id, list<task>> mapUserTask = new map<id, list<Task>>();
            for(Task tk : setTasks) {
                if(!mapContactTask.containskey(tk.WhoId)) {
                    mapContactTask.put(tk.WhoId, new list<Task>());
                }
                mapContactTask.get(tk.WhoId).add(tk);

                if(!mapUserTask.containskey(tk.OwnerId)) {
                    mapUserTask.put(tk.OwnerId, new list<Task>());
                }
                mapUserTask.get(tk.OwnerId).add(tk);
            }
            list<Contact> listContact = [SELECT id, Name FROM Contact WHERE id in:mapContactTask.keyset()];
            list<User> listUser = [SELECT id, Name FROM USER WHERE id in:mapUserTask.keyset()];

            map<id, WrapperTask> mapWrapperTask = new map<id, WrapperTask>();
            for(Contact cont : listContact) {
                for(Task t : mapContactTask.get(cont.Id)) {
                    WrapperTask wt = new WrapperTask();
                    wt.ContactName = cont.Name;
                    wt.TaskId = t.Id;
                    wt.Subject = t.Subject;
                    wt.Description = t.Description;
                    wt.Link = Label.Env_Link + t.id;
                    wt.ContactLink = Label.Env_Link + cont.Id;
                    wt.ActivityDate = String.valueOf(t.ActivityDate.day() + '/' + t.ActivityDate.month() + '/' + t.ActivityDate.year());
                    mapWrapperTask.put(wt.TaskId, wt);
                }
            }
            for(User us : listUser) {
                for(Task t : mapUserTask.get(us.id)) {
                    WrapperTask wt = mapWrapperTask.get(t.id);
                    wt.UserName = us.Name;
                    wt.UserId = us.Id;
                }
            }

            // Email template
            list<EmailTemplate> listemailTemplate = [SELECT Id, Subject, HtmlValue, Body, DeveloperName
                                                     FROM EmailTemplate
                                                     WHERE DeveloperName = 'TemplateNewTaskEmailEronee'];

            // Id du custom notification type
            CustomNotificationType notificationType = [SELECT Id, DeveloperName
                                                       FROM CustomNotificationType
                                                       WHERE DeveloperName = 'Alerte_tache'];

            // Create a new custom notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();

            // Set the contents for the notification
            notification.setTitle(Label.AP119_NotifTitle);
            notification.setBody(Label.AP119_NotifyBody);

            // Set the notification type
            notification.setNotificationTypeId(notificationType.Id);

            List<Messaging.SingleEmailMessage> listToSend = new List<Messaging.SingleEmailMessage>();

            if(listemailTemplate<> null && listemailTemplate.size() > 0) {
                EmailTemplate emTemp = listemailTemplate[0];

                for(WrapperTask wt : mapWrapperTask.values()) {
                    //prepare le mail a envoyer au contact associe au demande
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

                    //destinataire
                    message.toAddresses = new List<String> {wt.UserId};

                    //contenu
                    String htmlBody = emTemp.HtmlValue;
                    htmlBody = htmlBody.replace('{!Task.OwnerId}', wt.UserName );
                    htmlBody = htmlBody.replace('{!Task.Who}', wt.ContactName );
                    htmlBody = htmlBody.replace('{!Task.ContactLink}', wt.ContactLink);
                    htmlBody = htmlBody.replace('{!Task.Subject}', wt.Subject );
                    htmlBody = htmlBody.replace('{!Task.ActivityDate}', wt.ActivityDate );
                    htmlBody = htmlBody.replace('{!Task.Description}', wt.Description );
                    htmlBody = htmlBody.replace('{!Task.Link}', wt.Link);

                    message.setSubject(Label.AP119_SubjectMail);
                    message.setHtmlBody(htmlBody);

                    //expediteur
                    //smile@dalkia.fr
                    message.setOrgWideEmailAddressId(Label.AP101_OrgWideEmailAddressId);
                    message.setUseSignature(false);

                    listToSend.add(message);

                    notification.setTargetId(wt.TaskId);
                    notification.send(new set<string> {wt.UserId});

                }

                //envoyer les mails
                Messaging.SendEmailResult[] results = Messaging.sendEmail(listToSend);
            }

        }

    }
    public class WrapperTask {
        public Id TaskId;
        public String ContactName;
        public String UserName;
        public String Subject;
        public String Description;
        public String ActivityDate;
        public String Link;
        public String UserId;
        public String ContactLink;
    }
}