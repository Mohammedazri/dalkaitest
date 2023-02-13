/**
* @author Charbel Khoury Hanna - EIT Mena
* @date 01/04/2022
* @description MAJ Type PDA Reseaux sur les contrats issus de renouvellement fille
* @Test Class Batch127_UpdatePDAReseauxContrat_Test 100%
*/

global class Batch127_UpdatePDAReseauxContrat implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'select id, Type_de_PdA_reseaux__c, OpportuniteCommerciale__r.Type_de_PdA_reseaux__c from Contrat__c where OpportuniteCommerciale__r.Qualification__c = \'Renouvellement Fille / PDA\' and OpportuniteCommerciale__r.NatureOpportunitMere__c  = \'Réseau\' ';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc, List<Contrat__c> listContrat){
        
        for(Contrat__c con : listContrat) {
            
            con.Type_de_PdA_reseaux__c = con.OpportuniteCommerciale__r.Type_de_PdA_reseaux__c;
        }
        
        update listContrat;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}