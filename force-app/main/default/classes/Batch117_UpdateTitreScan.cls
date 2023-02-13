/**
* @author Charbel Khoury Hanna
* @date  04/02/2022
* @description MAJ du Titre scan sur le document contractuel
*/

global class Batch117_UpdateTitreScan implements Database.Batchable<ContentDocumentLink>{
    
    String query;
    
    global Batch117_UpdateTitreScan() {
    }
    
    global Iterable<ContentDocumentLink> start(Database.BatchableContext BC) 
    {
        System.debug('Batch117_UpdateTitreScan Starting...');
        System.debug('query == '+query);
        return new CustomIterableExample();
    }
    
    global void execute(Database.BatchableContext BC, List<ContentDocumentLink> scope) 
    {
        System.debug('Batch117_UpdateTitreScan started executing');
        
        if (scope.size()>0)
        {
            AP100_IdScan.updateIdScan(scope);
        }
        
        System.debug('Batch117_UpdateTitreScan Ended Executing');
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch117_UpdateTitreScan Finishing...');
    }
}