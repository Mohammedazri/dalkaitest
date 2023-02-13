/**
* @author Jacques Akiki -EI Technologies
* @date 30/01/2018
* @description Batch that sets the field Avenant__c 
* @Test Class: Batch32_UpdateAvenant_test 
*/
global class Batch32_UpdateAvenant implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query ='select id, Avenant__c, (Select id from OpportuniteCommerciale__r where type_pers__c =\'Evolution\' AND Statut__c =\'Gagnée\' limit 1) from Contrat__c ';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<contrat__c> listCont)
    {
        for (contrat__c cont : listCont)
        {
            if (cont.OpportuniteCommerciale__r.size()>0)
            {
                cont.Avenant__c = 'Oui'; 
            }
            else
            {
                cont.Avenant__c = 'Non';
            }
        }
        update listCont;
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
}