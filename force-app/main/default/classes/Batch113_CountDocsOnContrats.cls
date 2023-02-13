/** 
* @author Jimmy Khalil - Ei technologies
* @date 09/06/2021 
* @description  Batch To Fill the field NumeroIncrementeDocumentGenere__c on Document_Contractuel__c (RDD)
* @Test Class Batch113_CountDocsOnContrats_Test 100%
*/
global class Batch113_CountDocsOnContrats implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //Get Contrats with Doc Contractuels not synced
        String query='SELECT id,(select id from Documents_Contractuels__r WHERE NumeroPiece__c = null) FROM Contrat__c where ID in (select Contrat__c  from Document_Contractuel__c WHERE NumeroPiece__c = null)';
        return Database.getQueryLocator(query); 
    }
    global void execute (Database.BatchableContext bc , List<Contrat__c> listContrats)
    {
        List<Document_Contractuel__c> listRelatedDoc = new List<Document_Contractuel__c>();
        Integer count = 1;
        for(Contrat__c cont:listContrats){
            if(cont.Documents_Contractuels__r != null && cont.Documents_Contractuels__r.size()>0){
                count = 1;
                //set NumeroIncrementeDocumentGenere__c for docs for each contrat
                for(Document_Contractuel__c docs:cont.Documents_Contractuels__r){
                    docs.NumeroIncrementeDocumentGenere__c = count;
                    listRelatedDoc.add(docs);
                    count ++;
                }
            }
        }
        if(listRelatedDoc.size()>0){
            update listRelatedDoc;
        }
    }
    
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}