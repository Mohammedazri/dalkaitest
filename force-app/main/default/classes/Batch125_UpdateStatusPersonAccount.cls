/**
 * @author Jimmy Khalil - Ei technologies
 * @date 18/03/2022
 * @description  Aligner les statuts des contacts sur les partenaires de types "Compte personnel" rattachés (RDD US C360-679)
 * @Test Class Batch125_UpdateStatus_Test 100%
 */
global class Batch125_UpdateStatusPersonAccount implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){

        //tous les les partenaires de types "Compte personnel"
        String query = 'select id,Statut__pc,StatutPartenaire__c  from Account where IsPersonAccount = true';

        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext bc, List<Account> listAccount){

        //Partenaire.statut = vide -> Contact.statut = vide
        //Partenaire.statut = Ouvert -> Contact.statut = Actif
        //Partenaire.statut = Fermé -> Contact.statut = Inactif
        for(Account acc : listAccount) {
            if(acc.StatutPartenaire__c == '' || acc.StatutPartenaire__c == null) {
                acc.Statut__pc = '';
            } else if(acc.StatutPartenaire__c == 'OUV') {
                acc.Statut__pc = 'Actif';
            } else if(acc.StatutPartenaire__c == 'FER') {
                acc.Statut__pc = 'Inactif';
            }
        }
        Update listAccount;
    }

    global void finish(Database.BatchableContext bc){}
}