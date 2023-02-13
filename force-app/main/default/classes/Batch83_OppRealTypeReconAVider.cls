/** 
* @author Alain Ghoussoub - Ei technologies
* @date 09/07/2020 
* @description Batch qui vide la valeur du champ type de reconduction des opportunités n'étant pas à l'étape réalisation et ayant le champ type de reconduction renseigné.
* @Test Class 
*/
global class Batch83_OppRealTypeReconAVider implements Database.Batchable<SObject> {
/** 
    * @author Alain Ghoussoub 
    * @date 09/07/2020 
    * @chercher toutes les opportunités à l'étape réalisation et ayant le champ type de reconduction renseigné.
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String realisation = Label.PV_Realisation;
        String query='select id,TypeReconduction__c from opportunity where StageName !=:realisation and TypeReconduction__c != null and TypeReconduction__c != \'\'';
        return Database.getQueryLocator(query); 
    }
    
    /** 
    * @author Alain Ghoussoub  
    * @date 09/07/2020 
    * @renseigne la valeur pas de reconduction pour le type de reconduction sur les opportunités à l'étape réalisation
    * @param Database.BatchableContext and list of opportunities
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        for(Opportunity opp:listOpp){
            opp.TypeReconduction__c = null;
        }
        if(listOpp != null && listOpp.size()>0){
            update listOpp;
        }
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {

    }
}