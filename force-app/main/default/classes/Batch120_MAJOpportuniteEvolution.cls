/** 
* @author Charbel Khoury Hanna - Ei technologies
* @date 25/08/2021 
* @description Batch pour mettre à jour les champs "Est Opportunité Mère" et "Nature Opportunité Mère"
* @Test Class Batch120_MAJOpportuniteEvolution_Test 100%
*/

global class Batch120_MAJOpportuniteEvolution implements Database.Batchable<sObject>{
    
/** 
* @author Charbel Khoury Hanna
* @date 25/08/2021
* @chercher les Opportunités
*/    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'SELECT id, EstOpportuniteMere__c, ContratOrigine__r.NatureContratCadre__c, NatureOpportunitMere__c '
            	       +' FROM Opportunity WHERE Type_pers__c = \''+Label.Opp_type_Evolution+'\' AND EstOpportuniteMere__c = true ';
        system.debug('** query = '+query);
        return Database.getQueryLocator(query);
    }
    
/** 
* @author Charbel Khoury Hanna
* @date 25/08/2021
* @vider le champ Vider le champ "Est opportunité mère" et renseigner "Nature opportunité mère" depuis "Nature contrat cadre" du contrat d'origine
*/  
    global void execute(Database.BatchableContext BC, List<Opportunity> listOpp)
    {
        list<Opportunity> listOppUpdate = new list<Opportunity>();
        for(Opportunity opp: listOpp)
        {
            opp.EstOpportuniteMere__c = false;
            opp.NatureOpportunitMere__c = opp.ContratOrigine__r.NatureContratCadre__c;
			listOppUpdate.add(opp);
            
        }
        if (listOppUpdate!=NULL && listOppUpdate.size()>0)
        {
            update listOppUpdate;
        }
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}