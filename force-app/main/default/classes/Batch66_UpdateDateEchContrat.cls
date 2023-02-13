/** 
* @author Jacques Akiki - Ei technologies
* @date 20/02/2020 
* @description Batch qui renseigne la signature de tous les utilisateurs actifs de l'environnement
* @Test Class Batch66_UpdateDateEchContrat_test
*/
global class Batch66_UpdateDateEchContrat implements Database.Batchable<SObject>
{
    
     /** 
    * @author Jacques AKiki 
    * @date 20/02/2020 
    * @Select all contrats with empty dk codes and date d'echeance not empty 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id, DateProchaineEcheance__c from contrat__c where  DKCodeSurContrat__c=NULL AND DateProchaineEcheance__c!=NULL ';
        return Database.getQueryLocator(query); 
    }
     /** 
    * @author Jacques AKiki 
    * @date 20/02/2020 
    * @remove the value from field DateProchaineEcheance__c on contrat
    * @param Database.BatchableContext and list of contrat
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<Contrat__c> listCont)
    {
        for (Contrat__c cont:listCont)
        {
            cont.DateProchaineEcheance__c = NULL;
        }
        update listCont;
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}