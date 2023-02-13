/** 
* @author Alain Ghoussoub 
* @date 01/09/2020 
* @description Batch qui met a jour le champ unique sur le documents contractuels qui ont le champ vide
* @Test Class Batch91_DocumentUnique_test
*/
global class Batch91_DocumentUnique implements Database.Batchable<SObject> {
    /** 
* @author Alain Ghoussoub
* @date 01/09/2020   
* @chercher les documetns contactuels qui ont le champ unique vide
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query= 'select id,DocUniqueText__c from Document_Contractuel__c';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Alain Ghoussoub 
* @date 02/09/2020  
* @Met a jour le champ unique
* @param Database.BatchableContext and list of Document contractuel
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Document_Contractuel__c> listDoc)
    {
        if(listDoc != null && listDoc.size()>0){
            update listDoc;
        }
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}