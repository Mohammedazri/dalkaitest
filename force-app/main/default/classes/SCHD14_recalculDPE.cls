/** 
* @author Charbel Khoury Hanna - Ei technologies
* @date 12/16/2022 
* @description schedular qui va lancer appel ModifierContrat2
* @Test Class AP120_ContratDates_Test
*/
global class SCHD14_recalculDPE implements Schedulable{
    public List<Contrat__c> ListCont;
    
    /** 
* @author Jacques Akiki  
* @date 06/04/2021
* @fonction appelée depuis AP40
* @param Cron expression pour le temps 
* @return void
*/
    global static String scheduleMe(String sched, List<Contrat__c> listContrat , String NameSCH) 
    {
        SCHD14_recalculDPE SC = new  SCHD14_recalculDPE();
        SC.ListCont = listContrat ;
        return System.schedule(NameSCH, sched, SC);
    }
    
    /** 
* @author Jacques Akiki  
* @date 04/04/2022
* @fonction Lancer appels ModifierContrat2 
* @param schedular du type SCHD12_updateContratsFils
* @return void
*/
    global void execute(SchedulableContext sc) 
    {    
        DescribeSObjectResult describeResult = Contrat__c.getSObjectType().getDescribe();  // get Describe of the type from the id
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap(); // Map API name to Fields
        Map<String, Schema.SObjectField> fieldMapnonF = new Map<String, Schema.SObjectField>(); // Map with no formula fields
        for(String fieldNm : fieldMap.keySet()) {
            if(!fieldMap.get(fieldNm).getDescribe().isCalculated()) { // check if field is not formula to added to the map for querying
                fieldMapnonF.put(fieldNm, fieldMap.get(fieldNm)); // add to non formula map
            }
        }
        set<id> setContratId = new set<id>();
        for(Contrat__c cont:ListCont)
        {
            setContratId.add(cont.id);
        }
        Set<String> fieldName = fieldMapnonF.keySet();// API names of all non formulas fields
        List<String> fieldNames = new List<String>(fieldName);
        String soqlQuery = ' SELECT ' + string.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE Id in:setContratId';
        List<Contrat__c> listContrat = Database.query(soqlQuery);
        for(Contrat__c cont:ListContrat)
        {
            string contratSerial = Json.serialize(new list<Contrat__c>{cont});
            AP48_ContractCallouts.ModifierContrat2(contratSerial);
        }
    }
}