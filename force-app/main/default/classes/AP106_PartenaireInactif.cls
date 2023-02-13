/**
*@author Charbel Khoury Hanna
*@date 04/14/2022
*@description Envoyer automatiquement une notification par email depuis C360 au pilote du contrat et à l'ADV de la region du pilote du contrat dès qu'un contrat est associé à un partenaire inactif
*@test class: AP106_PartenaireInactif_Test (100%)
*/

public class AP106_PartenaireInactif {
    
    public static void sendEmail(List<Account> listAccounts){
        
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : listAccounts)
        {
            accountIds.add(acc.Id);
        }
        
        Map<Id,List<Contrat__c>> mapPiloteContrats = new Map<Id,List<Contrat__c>>();
        Map<Id,String> mapPilotRegion = new Map<Id,String>();
        Map<String,List<String>> mapRegionADV = new Map<String,List<String>>();
        Map<Id,List<String>> mapPiloteADV = new Map<Id,List<String>>();
        Map<Id,String> mapPiloteEmail = new Map<Id, String>();
        
        // Email template
        List<EmailTemplate> templatePlusieursContrats = [SELECT Id, Subject, HtmlValue, Body,DeveloperName 
                                                         FROM EmailTemplate 
                                                         WHERE DeveloperName ='Template_plusieurs_contrats'];
        // Email template
        List<EmailTemplate> templateUnSeulContrat = [SELECT Id, Subject, HtmlValue, Body,DeveloperName 
                                                     FROM EmailTemplate 
                                                     WHERE DeveloperName ='Template_un_seul_contrat'];
        
        // Contrats non fermé attachés aux Partenaires actifs
        List<Contrat__c> listContrats = [SELECT Id, Name , NomPartenaire__r.Name, NomPartenaire__r.DKCodeSurPartenaire__c, PiloteDuContrat__c, PiloteDuContrat__r.Email,
                                         PiloteDuContrat__r.Nom_region__c
                                         FROM Contrat__c
                                         WHERE NomPartenaire__c in :accountIds
                                           AND Statut__c != :Label.ContratFerme
                                           AND PiloteDuContrat__r.IsActive = true];
        
        if(listContrats.size() > 0)
        {
            Set<String> setRegion = new Set<String>();
            
            for(Contrat__c cont : listContrats)
            {
                if(!mapPiloteContrats.containsKey(cont.PiloteDuContrat__c))
                {
                    mapPiloteContrats.put(cont.PiloteDuContrat__c, new List<Contrat__c>());
                }
                mapPiloteContrats.get(cont.PiloteDuContrat__c).add(cont);
                
                if(!mapPilotRegion.containsKey(cont.PiloteDuContrat__c))
                {
                    mapPilotRegion.put(cont.PiloteDuContrat__c, cont.PiloteDuContrat__r.Nom_region__c);
                }
                
                if(!mapPiloteEmail.containsKey(cont.PiloteDuContrat__c))
                {
                    mapPiloteEmail.put(cont.PiloteDuContrat__c, cont.PiloteDuContrat__r.Email);
                }
                
                setRegion.add(cont.PiloteDuContrat__r.Nom_region__c);
            }
            
            // ADV de la region du Pilote
            List<User> listADV = [SELECT Id, Email, Nom_region__c
                                 FROM User
                                 WHERE IsActive = true
                                 AND Profile.name =: Label.ProfilADV
                                 AND Nom_region__c in : setRegion];
            
            for(User usr : listADV)
            {
                if(!mapRegionADV.containsKey(usr.Nom_region__c))
                {
                    mapRegionADV.put(usr.Nom_region__c, new List<String>());
                }
                mapRegionADV.get(usr.Nom_region__c).add(usr.Email);
            }
            
            for (Id pilote : mapPilotRegion.keySet())
            {
                if(mapRegionADV.containsKey(mapPilotRegion.get(pilote)))
                {
                    mapPiloteADV.put(pilote, mapRegionADV.get(mapPilotRegion.get(pilote)));
                }
            }
            
            List<Messaging.SingleEmailMessage> listToSend = new List<Messaging.SingleEmailMessage>();
            
            for(Id pilote : mapPiloteContrats.keySet())
            {
                if(mapPiloteContrats.get(pilote).size() > 1)
                {
                    if(templatePlusieursContrats <> null && templatePlusieursContrats.size() > 0)
                    {
                        EmailTemplate emTemp = templatePlusieursContrats[0];
                        
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new List<String>{mapPiloteEmail.get(pilote)};
                            //contenu
                            String htmlBody = emTemp.HtmlValue;
                        
                        List<String> contratName = new List<String>();
                        for(Contrat__c cont : mapPiloteContrats.get(pilote))
                        {
                            contratName.add('<li>"' + cont.Name + '"</li>' );
                        }
                        
                        htmlBody = htmlBody.replace('{!listContrats}', String.join(contratName , ''));
                        htmlBody = htmlBody.replace('{!Partenaire.Name}', mapPiloteContrats.get(pilote)[0].NomPartenaire__r.Name );
                        
                        message.setCcAddresses(mapPiloteADV.get(pilote));
                        message.setHtmlBody(htmlBody);
                        
                        String subjectEmail = Label.AP106_Subject;
                        subjectEmail = subjectEmail.replace('{!Account.DKcode}',mapPiloteContrats.get(pilote)[0].NomPartenaire__r.DKCodeSurPartenaire__c);
                        message.setSubject(subjectEmail);
                        message.setHtmlBody(htmlBody);
                        
                        //expediteur
                        //c360@dalkia.fr
                        message.setOrgWideEmailAddressId(Label.AP106_OrgWideEmailId);
                        
                        message.setUseSignature(false);
                        
                        listToSend.add(message);
                    }
                }
                else if(mapPiloteContrats.get(pilote).size() == 1)
                {
                    if(templateUnSeulContrat <> null && templateUnSeulContrat.size() > 0)
                    {
                        EmailTemplate emTemp = templateUnSeulContrat[0];
                        
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new List<String>{mapPiloteEmail.get(pilote)};
                            //contenu
                            String htmlBody = emTemp.HtmlValue;
                        
                        htmlBody = htmlBody.replace('{!Contrat.Name}', mapPiloteContrats.get(pilote)[0].Name);
                        htmlBody = htmlBody.replace('{!Partenaire.Name}', mapPiloteContrats.get(pilote)[0].NomPartenaire__r.Name );
                        
                        message.setCcAddresses(mapPiloteADV.get(pilote));
                        message.setHtmlBody(htmlBody);
                        
                        String subjectEmail = Label.AP106_Subject;
                        subjectEmail = subjectEmail.replace('{!Account.DKcode}',mapPiloteContrats.get(pilote)[0].NomPartenaire__r.DKCodeSurPartenaire__c);
                        message.setSubject(subjectEmail);
                        message.setHtmlBody(htmlBody);
                        
                        //expediteur
                        //c360@dalkia.fr
                        message.setOrgWideEmailAddressId(Label.AP106_OrgWideEmailId);
                        message.setUseSignature(false);
                        
                        listToSend.add(message);
                    }
                }
            }
            
            //envoyer les mails
            if(listToSend.size() > 0)
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(listToSend);    
            }
        }
        
    }
}