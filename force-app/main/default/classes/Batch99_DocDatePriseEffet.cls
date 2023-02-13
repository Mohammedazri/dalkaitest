/** 
* @author Alain Ghoussoub - Ei technologies
* @date 27/10/2020 
* @description Batch qui met a jour le champ date prise effet des documents contractuels
* @Test Class 
*/
global class Batch99_DocDatePriseEffet implements Database.Batchable<SObject>{
/** 
    * @author Alain Ghoussoub
    * @date 27/10/2020  
    * @chercher les doccuments avenant et lettres avenataires non synchronise 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String lettre = Label.LettreAvenatire;
        String contrat = Label.Avenant;
        String query='SELECT id,DatePriseEffet__c,OpportuniteRattachee__c,OpportuniteRattachee__r.CloseDate from Document_Contractuel__c where NumeroPiece__c = null and OpportuniteRattachee__c != null and NatureDocument__c = \'DOC05\'';
        return Database.getQueryLocator(query);
    }

    /** 
* @author Alain Ghoussoub  
* @date 27/10/2020
* @mettre a jour le champ date prise effet
* @param Database.BatchableContext and list of contrat__c
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Document_Contractuel__c> docList)
    {
        Set<Id> oppIds = new Set<Id>();
        Set<Id> docIds = new Set<Id>();
        Map<Id,Date> oppDates = new Map<Id,Date>();
        Map<Id,Date> docDates = new Map<Id,Date>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(Document_Contractuel__c doc:docList){
            if(doc.DatePriseEffet__c != null && doc.DatePriseEffet__c != doc.OpportuniteRattachee__r.CloseDate){
                oppDates.put(doc.OpportuniteRattachee__c,doc.DatePriseEffet__c);
            }
        }
        for(id oppId : oppDates.keySet()){
            Opportunity opp = new Opportunity();
            opp.closedate = oppDates.get(oppId);
            opp.id=oppId;
            oppList.add(opp);
        }
        update oppList;
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
        
    }
}