/** 
* @author Alain Ghoussoub - Ei technologies
* @date 15/05/2020 
* @description Batch that deletes the value of contrat d'origine on opportunite concurrente
* @Test Class 
*/
global class Batch71_DeleteOppContratOrigine implements Database.Batchable<SObject>{
	    /** 
* @author Alain Ghoussoub
* @date 15/05/2020 
* @ Select all opportunitie concurrente
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='select id,Type_pers__c,ContratOrigine__c from opportunity where Type_pers__c =\'' + Label.PV_Opp_Type_Nouveau + '\' and OpportuniteDorigine__c!=null';
        return Database.getQueryLocator(query); 
    }
    /** 
* @author Alain Ghoussoub 
* @date 15/05/2020 
* @deletes the value of contrat d'origine on opportunite concurrente
* @param Database.BatchableContext and list of Opportunities
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        for(Opportunity opp : listOpp){
            opp.ContratOrigine__c = null;
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