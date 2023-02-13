/**
* @author Jimmy Khalil - EIT Mena
* @date 20/07/2022
* @description Mettre 0 sur le champ Ventes services P1 en remplacent de "vide" pour les opportunités réalisées sur toutes les années de signature ayant une FDS non renseignée (RDD US C360-717)
* @Test Class Batch129_RenseigneFDS_Test 100%
*/

global class Batch129_RenseigneFDS implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //Get All Opps with FDS non renseignée
        String query = 'select id,Name,Opportunit_commerciale__r.Amount,Opportunit_commerciale__r.MargeBruteOffre__c,Opportunit_commerciale__r.Heures_P2_Offre__c,Opportunit_commerciale__r.CAP6Offre__c,Opportunit_commerciale__r.MBP6Offre__c from Fiche_de_synthese__c where (Opportunit_commerciale__r.StageName =\'Réalisation\') And (Opportunit_commerciale__r.ZZZ_FdS_Opportunit_Completee__c = null Or Opportunit_commerciale__r.ZZZ_FdS_Opportunit_Completee__c = 0)';
        return Database.getQueryLocator(query);

    }
    
    global void execute (Database.BatchableContext bc, List<Fiche_de_synthese__c> listFDS){
        
        //Update FDS à renseignée (mettre 0 sur le champ Ventes services P1)
        for(Fiche_de_synthese__c fds:listFDS){
            fds.OffreA1P1VentesServices__c = 0;
        }
        
        Update listFDS;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}