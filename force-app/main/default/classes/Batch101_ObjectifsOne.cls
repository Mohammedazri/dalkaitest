/** 
* @author Dona kfoury - Ei technologies
* @date 30/10/2020 
* @description Batch qui renseigne le type d'enregistrement "Commercial Agence One" pour les objectifs déjà créés et assignés au commerciaux first
* @Test Class Batch101_ObjectifsOne_Test
*/
global class Batch101_ObjectifsOne implements Database.Batchable<SObject>{
    /** 
    * @author Dona Kfoury 
    * @date 30/10/2020  
    * @chercher tous lesobjectifs déjà créés et assignés au commerciaux first 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string profiledToInclude = label.Profils_First;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        String query = 'Select Id, Commercial__r.Profile.name,recordtypeid from objectif__c where Commercial__r.Profile.name in:setProfileNames';
        return Database.getQueryLocator(query); 
    }
    
    /** 
    * @author Dona Kfoury  
    * @date 30/10/2020
    * @pour chaque objectif first mettre le recordtype: "Commercial Agence One"
    * @param Database.BatchableContext and list of objectifs
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<Objectif__c> listObjectifs)
    {
        Id ObjFirstRTId = Schema.SObjectType.objectif__c.getRecordTypeInfosByDeveloperName().get(Label.RT_Objectif_CommercialOne).getRecordTypeId();
        for(objectif__c myObj:listObjectifs){
            myObj.recordtypeid = ObjFirstRTId;
        }
        update listObjectifs;
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {

    }

}