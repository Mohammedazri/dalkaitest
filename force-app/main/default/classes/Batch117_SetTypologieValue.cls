/** 
* @author Jimmy Khalil - Ei technologies
* @date 02/08/2021
* @description Batch qui met a jour le champ typologie de l'objet 'Contact Satisfaction' (RDD US C360-482)
* @Test Class Batch117_SetTypologieValue_Test 100%
*/

global class Batch117_SetTypologieValue implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'SELECT id,Name,Typologie__c FROM Contact_Satisfaction__c ';
        
        system.debug('*** Batch117_SetTypologieValue query='+query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact_Satisfaction__c> lstContactSat)
    {
        
        for(Contact_Satisfaction__c contSat : lstContactSat)
        {
            // Enregistrements commençant par "SMILE", valeur de "Typologie" = 'Enquête annuelle'
            if(contSat.Name.startsWith(Label.EnqSMILE)){
                contSat.Typologie__c = Label.EnqTypeEnqueteAnnuelle;
            }else{
                //Pour les autres enregistrements,  valeur de "Typologie" = 'Enquête Premium'
                contSat.Typologie__c = Label.EnqTypeEnquetePremium;
            }
        }
        
        if(lstContactSat.size() > 0)
        {
            update lstContactSat;   
        }
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}