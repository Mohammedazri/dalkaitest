/** 
* @author Jimmy Khalil - Ei technologies
* @date 10/06/2021 
* @description  Batch To update DocUniqueText on contrats  (RDD)
* @Test Class Batch114_UpdateDocUniqueText_Test 100%
*/
global class Batch114_UpdateDocUniqueText implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //Get Contrats with Doc Contractuels not synced
        String query='select id,DocUnique__c from Document_Contractuel__c WHERE NumeroPiece__c = null';
        return Database.getQueryLocator(query); 
    }
    global void execute (Database.BatchableContext bc , List<Document_Contractuel__c> listDocs)
    {
        for(Document_Contractuel__c docs:listDocs){
            docs.DocUniqueText__c = docs.DocUnique__c;
        }
        update listDocs;
    }
    
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}