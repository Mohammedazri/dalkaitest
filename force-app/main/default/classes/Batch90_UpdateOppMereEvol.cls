/** 
* @author Jacques Akiki 
* @date 31/08/2020 
* @description Batch qui decoche la case est opp mère sur les opp de type Evolution
* @Test Class Batch90_UpdateOppMereEvol_test 100%
*/
global class Batch90_UpdateOppMereEvol implements Database.Batchable<SObject> {
/** 
* @author Jacques Akiki
* @date 31/08/2020   
* @chercher les opportunités concernées de type evolution avec la coche Est Opp mère cochée
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='SELECT id,EstOpportuniteMere__c,NatureOpportunitMere__c FROM Opportunity WHERE EstOpportuniteMere__c=true and Type_pers__c=\''+Label.Evolution+'\'';
        return Database.getQueryLocator(query); 
    }
    
/** 
* @author Jacques Akiki
* @date 31/08/2020  
* @Set the checkBox EstOpportuniteMere__c to false
* @param Database.BatchableContext and list of Opportunities
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        for(Opportunity opp : listOpp)
        {
            opp.EstOpportuniteMere__c = false;
            opp.NatureOpportunitMere__c = NULL;
        }
        update listOpp;
    }
    
/*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}