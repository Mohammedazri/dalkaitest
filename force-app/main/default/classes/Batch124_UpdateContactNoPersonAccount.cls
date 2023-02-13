/**
 * @author Jimmy Khalil - Ei technologies
 * @date 18/03/2022
 * @description  Rendre actif tous les contacts sans statuts, non reliés à des comptes personnel (RDD US C360-679)
 * @Test Class Batch124_UpdateContact_Test 100%
 */
global class Batch124_UpdateContactNoPersonAccount implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){

        //tous les contacts sans statuts, non reliés à des comptes personnel
        String query = 'select id,Statut__c from Contact where IsPersonAccount = false and Statut__c =null ';

        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext bc, List<Contact> listContact){

        //Rendre actif
        for(Contact con : listContact) {
            con.Statut__c = 'Actif';
        }
        Update listContact;
    }

    global void finish(Database.BatchableContext bc){}
}