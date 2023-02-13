/** 
* @author Charbel Khoury Hanna - Ei technologies
* @date 16/02/2021
* @description Batch qui met a jour le champ Volume d'activité (CA Contrats) et Volume d'activité (CA Contrats) hors PDA sur Partenaire
* @Test Class Batch109_MajCAPartenaire_Test 100%
*/

global class Batch109_MajCAPartenaire implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'SELECT id, TotalCABudgetP1P2P3P4__c, ContratCadre__c, NomPartenaire__c FROM Contrat__c'+
            		   ' WHERE Statut__c != \''+Label.ContratFerme+'\' AND TotalCABudgetP1P2P3P4__c != null AND NomPartenaire__c != null';
        
        system.debug('*** query='+query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contrat__c> lstContrats)
    {
        system.debug('*** lstContrats size = '+lstContrats.size());
        AP94_Contrat.majCAPartenaire(null, lstContrats);
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}