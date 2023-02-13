/** 
* @author Alain Ghoussoub - Ei technologies
* @date 27/08/2020 
* @description Batch qui met a jour les document contractuels qui n'ont pas un numéro de pièce vers le type d'enregistrement document contractuel
* @Test Class 
*/
global class Batch89_DocumentContractuelNonSyncRT implements Database.Batchable<SObject>{
/** 
    * @author Alain Ghoussoub
    * @date 27/07/2020   
    * @chercher les documents contractuels qui ont un numero piece
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='select id,RecordTypeId, NumeroPiece__c from Document_Contractuel__c where NumeroPiece__c = null OR NumeroPiece__c = \'\'';
        return Database.getQueryLocator(query); 
    }
    
    /** 
    * @author Alain Ghoussoub
    * @date 27/07/2020  
    * @met a jour les document contractuels qui ont un numéro de pièce vers le type d'enregistrement document contractuel synchronisé
    * @param Database.BatchableContext and list of Document_Contractuel__c
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<Document_Contractuel__c> listDoc)
    {
        List<RecordType> recTypeList = [select Id from RecordType where DeveloperName= :Label.DocumentContractuelNonSync];
        if(recTypeList != null && recTypeList.size()>0){
            String RecTypeId= recTypeList[0].id;
            for(Document_Contractuel__c doc : listDoc){
                doc.recordtypeId=RecTypeId;
            }
            if(listDoc != null && listDoc.size()>0){
                update listDoc;
            }
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}