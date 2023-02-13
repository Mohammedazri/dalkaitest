public without sharing class LC56_RelatedListEcoOnPart_Controller {
    
 public Static Integer numb=0;// variable used to store the number of EcosystemePartenaire__c 
 
    @AuraEnabled
    public static List<EcosystemePartenaire__c> getEcoSystems(Id AccId)
    {
        Map<String, Schema.SObjectField> fieldMap = EcosystemePartenaire__c.sObjectType.getDescribe().fields.getMap();// map that contains all the fields of the EcosystemePartenaire__c
        List<String> fieldNames= new List<String>();// list used to store the API name of all the fields of the EcosystemePartenaire__c
        fieldNames.addall(fieldMap.keySet());// use the key set of the map to fill the list 
        // query all the EcosystemePartenaire__c related to the Opportunity or the contract 
        List<EcosystemePartenaire__c> ecoSystems = Database.query('select ' + string.join(fieldNames, ',') + ', Partenaire__r.name ,PartenaireLie__r.name,Contrat__r.Name, Opportunite__r.Name,ContactDuPartenaireLie__r.Name  from EcosystemePartenaire__c where (Partenaire__c = \''+AccId+'\' or ContactDuPartenaire__c = \''+AccId+'\') order by CreatedDate desc');
        numb=ecoSystems.size();// set the variable numb
        return ecoSystems;// return the list 
        
    }
        
    @AuraEnabled
    public static List<String> deleteEco(Id ecoID)
    { // query the EcosystemePartenaire__c that will be deleted 
        EcosystemePartenaire__c eco=[SELECT  ID,name
                                     FROM EcosystemePartenaire__c 
                                     WHERE id =:ecoID Limit 1];
        List<String> strlist= new List<String>();// list of strings that contains the Name of the EcosystemePartenaire__c and OK if the deletion was succecful or the error
        strlist.add(eco.Name );// add the EcosystemePartenaire__c name to the List 
        try
        {
            delete  eco; // delete the EcosystemePartenaire__c
            strlist.add('OK');// Add 'OK' to the List if the EcosystemePartenaire__c is deleted
            return strlist;// return the list
        }
        catch( system.DMLException e)
        {
            String msg=  e.getmessage();// if the EcosystemePartenaire__c was not deleted: get the message of the error and store it in this variable 
            strlist.add( msg.remove('</b>').remove('<b>').remove(': []').replaceAll('<br>', '. '));// add the error message to the list
            return strlist; //return the list 
        }
    }
    
    @AuraEnabled
    public static List<EcosystemePartenaire__c> getEcoSystemsContact(Id AccId)
    {
        Map<String, Schema.SObjectField> fieldMap = EcosystemePartenaire__c.sObjectType.getDescribe().fields.getMap();// map that contains all the fields of the EcosystemePartenaire__c
        List<String> fieldNames= new List<String>();// list used to store the API name of all the fields of the EcosystemePartenaire__c
        fieldNames.addall(fieldMap.keySet());// use the key set of the map to fill the list 
        // query all the EcosystemePartenaire__c related to the Opportunity or the contract 
        List<EcosystemePartenaire__c> ecoSystems = Database.query('select ' + string.join(fieldNames, ',') + ', Partenaire__r.name ,PartenaireLie__r.name,Contrat__r.Name, Opportunite__r.Name,ContactDuPartenaireLie__r.Name, ContactDuPartenaire__r.Name  from EcosystemePartenaire__c where (Partenaire__c = \''+AccId+'\' or ContactDuPartenaireLie__c = \''+AccId+'\' ) order by CreatedDate desc');
        numb=ecoSystems.size();// set the variable numb
        return ecoSystems;// return the list 
    }
        
}