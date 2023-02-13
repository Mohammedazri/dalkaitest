/**
 * @author Charbel Khoury Hanna - EIT Mena
 * @date 28/03/2022
 * @description MAJ Type PDA Reseaux sur les Opportunités
 * @Test Class Batch126_UpdatePDAResauxOpp_Test 81%
 */

global class Batch126_UpdatePDAResauxOpp implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){

        String query = 'SELECT id, Type_pers__c, Type_de_PdA_reseaux__c, Qualification__c FROM Opportunity WHERE NatureOpportunitMere__c = \'Réseau\' and Qualification__c in (\'Renouvellement Fille / PDA\' , \'Avenant Fille / PDA\')';
        return Database.getQueryLocator(query);
    }

    global void execute (Database.BatchableContext bc, List<Opportunity> listOpportunity){

        for(Opportunity opp : listOpportunity) {
            if(opp.Qualification__c == 'Renouvellement Fille / PDA'){
                opp.Type_de_PdA_reseaux__c = 'Renouvellement PDA';
            }
            else if(opp.Qualification__c == 'Avenant Fille / PDA'){
                opp.Type_de_PdA_reseaux__c = 'Densification';
            }
        }
        update listOpportunity;
    }
    
    global void finish(Database.BatchableContext bc){
        system.debug('** finish Batch126_UpdatePDAResauxOpp ***');
    }
}