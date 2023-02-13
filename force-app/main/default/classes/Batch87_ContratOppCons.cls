/** 
* @author Alain Ghoussoub - Ei technologies
* @date 12/08/2020 
* @description Batch qui met a jour les champs de puissance et consomation sur le contrat selon les valeurs de l'opportunite
* @Test Class Batch87_ContratOppCons_TEST
*/
global class Batch87_ContratOppCons implements Database.Batchable<SObject> {
/** 
    * @author Alain Ghoussoub
    * @date 12/08/2020   
    * @chercher les contrats dont les opportunite ont des valeurs dans puissance et consomation
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='select id,OpportuniteCommerciale__r.ConsommationChaud__c,OpportuniteCommerciale__r.ConsommationFroid__c,OpportuniteCommerciale__r.PuissanceChaud__c,OpportuniteCommerciale__r.PuissanceFroid__c from contrat__c where OpportuniteCommerciale__r.ConsommationChaud__c != null OR OpportuniteCommerciale__r.ConsommationFroid__c!= null OR OpportuniteCommerciale__r.PuissanceChaud__c!= null OR OpportuniteCommerciale__r.PuissanceFroid__c != null';
        return Database.getQueryLocator(query); 
    }
    
    /** 
    * @author Alain Ghoussoub
    * @date 12/08/2020  
    * @met a jour les champs de puissance et consomation sur le contrat selon les valeurs de l'opportunite
    * @param Database.BatchableContext and list of Document_Contractuel__c
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<Contrat__c> listCont)
    {
        for(Contrat__c cont : listCont){
            cont.ConsommationChaud__c=cont.OpportuniteCommerciale__r.ConsommationChaud__c;
            cont.ConsommationFroid__c=cont.OpportuniteCommerciale__r.ConsommationFroid__c;
            cont.PuissanceChaud__c=cont.OpportuniteCommerciale__r.PuissanceChaud__c;
            cont.PuissanceFroid__c=cont.OpportuniteCommerciale__r.PuissanceFroid__c;
        }
        if(listCont != null && listCont.size()>0){
            update listCont;
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}