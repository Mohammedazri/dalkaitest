/**
* @author Charbel Khoury Hanna - EIT Mena
* @date 12/14/2022
* @description Recalculer les dates lorsque la date du jour depasse la date de prochaine echeance
* @Test Class AP120_ContratDates_Test 100%
*/

global class Batch135_RecalculDesDates implements Database.Batchable<SObject>, Database.Stateful{
    
    global String treatedContrats = '';
    
    global Batch135_RecalculDesDates(){
        User usr = new User(id = userInfo.getUserId());
        usr.Bypass_Triggers__c = ';AP52_DocumentContractuel;';
        usr.BypassValidationRules__c = true;
        usr.BypassDuplicateRules__c = true;
        usr.BypassFilters__c = true;
        update usr;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        String statutFER = Label.ContratFerme;
        String query = 'select id, TypeReconduction__c,DatePriseEffet__c,DureeInitialeContrat__c,DureeProlongationTotale__c,NombreReconductionsPassees__c,DureeReconduction__c,'
            +'NombreReconductionsAutorisees__c, ZZZTodayBiggerEcheance__c, DKCodeSurContrat__c, LibelleRegion__c, Nom_d_Agence__c, techOwner__c from Contrat__c '
            +'where Statut__c != :statutFER and ZZZTodayBiggerEcheance__c = true and DKCodeSurContrat__c != null ';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc, List<Contrat__c> listContrat){
        
        for(Contrat__C cont : listContrat)
        {
            treatedContrats += cont.id + ',';
        }
        
        AP120_ContratDates.recalculerDPE(listContrat);
    }
    
    global void finish(Database.BatchableContext bc){
        
        treatedContrats = treatedContrats.removeEnd(',');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Set the recipient
        mail.setToAddresses(new String[] {'charbel.hanna@eit-mena.com'});
        
        // Set the subject
        mail.setSubject('Batch135_RecalculDesDates result');
        
        // Set the body
        mail.setPlainTextBody('The batch \'Batch135_RecalculDesDates\' was run on the following contrat ids: '+treatedContrats);
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        User usr = new User(id = userInfo.getUserId());
        usr.Bypass_Triggers__c = '';
        usr.BypassValidationRules__c = false;
        usr.BypassDuplicateRules__c = false;
        usr.BypassFilters__c = false;
        update usr;
    }
}