/** 
* @author Alain Ghoussoub - Ei technologies
* @date 15/10/2020 
* @description Batch qui met vide tout les contrat qui ont duree prolongation totale 0
* @Test Class Batch98_ProlongationContrat_TEST
*/
global class Batch98_ProlongationContrat implements Database.Batchable<SObject>{
 /** 
    * @author Alain Ghoussoub
    * @date 15/10/2020  
    * @chercher tous les contrats ayant duree prolongation totale = 0 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='Select id,DureeProlongationTotale__c from contrat__c where DureeProlongationTotale__c = 0';
        return Database.getQueryLocator(query);
    }

    /** 
* @author Alain Ghoussoub  
* @date 15/10/2020
* @mettre duree prolongation totale null
* @param Database.BatchableContext and list of contrat__c
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Contrat__c> listCont)
    {
        for(contrat__c cont : listCont){
            cont.DureeProlongationTotale__c = null;
        }
        update listCont;
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
        
    }
}