/**
* @author Alain Ghoussoub
* @date 10/06/2020
* @description Batch qui recopie le sous-segment du contrat d'origine vers les opportunités générées, si vides.
* @Test Class: Batch75_UpdateContOffre_TEST
*/
global class Batch76_SousSegmentOpp implements Database.Batchable<SObject> {
    /** 
* @author Alain Ghoussoub
* @date 10/6/2020 
* @ Select all opportunities that have contrat d'origine and sous segment empty
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='select id,ContratOrigine__c,ContratOrigine__r.SousSegmentMarche__c,SousSegmentMarche__c  from opportunity where (SousSegmentMarche__c = null or SousSegmentMarche__c = \'\') and (ContratOrigine__r.SousSegmentMarche__c != null and ContratOrigine__r.SousSegmentMarche__c != \'\')';
        return Database.getQueryLocator(query); 
    }
    /** 
* @author Alain Ghoussoub 
* @date 10/6/2020 
* @Renseigne le sous segment des opportunite
* @param Database.BatchableContext and list of opportunities
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        for(Opportunity opp : listOpp){
            if(opp.ContratOrigine__c != null && String.isNotBlank(opp.ContratOrigine__r.SousSegmentMarche__c)){
                opp.SousSegmentMarche__c = opp.ContratOrigine__r.SousSegmentMarche__c;
            }
        }
        if(listOpp != null && listOpp.size()>0){
            database.update(listOpp, false);
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}