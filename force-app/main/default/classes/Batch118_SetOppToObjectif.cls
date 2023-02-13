/** 
* @author Jimmy Khalil - Ei technologies
* @date 08/08/2021
* @description Batch qui alimente le champ TECH_Objectif__c des opp selon l'objectif convenable (RDD US C360-464)
* @Test Class Batch118_SetOppToObjectif_Test 100%
*/

global class Batch118_SetOppToObjectif implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'select id,Annee__c ,Commercial__r.Name from Objectif__c where Annee__c =\'2021\' ';
        
        system.debug('*** Batch118_SetOppToObjectif query='+query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Objectif__c> lstObj)
    {
        //appeller la methode AP06_Objectif qui recupere la list de opportunites selon l'annee et le responsable et MAJ le champ TECH_Objectif__c
        AP06_Objectif.UpdateObjectifInsert(lstObj);


    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}