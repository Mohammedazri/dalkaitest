/**
* @author Jimmy Khalil - EIT Mena
* @date 20/07/2022
* @description Créer des FdS renseignées (mettre 0 sur le champ Ventes services P1) pour les opportunités en proposition/réalisation sur toutes les années de signature n'ayant pas de FDS (RDD US C360-717)
* @Test Class Batch130_CreateFDSRenseigne_Test 100%
*/

global class Batch130_CreateFDSRenseigne implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //Get All Opps at Proposition or Réalisation wihtout FDS
        String query = 'select id,Name,Amount,MargeBruteOffre__c,Heures_P2_Offre__c,CAP6Offre__c,MBP6Offre__c from Opportunity where (StageName =\'Proposition\' or StageName =\'Réalisation\') And Id not in (Select Opportunit_commerciale__c from Fiche_de_synthese__c)';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc, List<Opportunity> listOpps){
        
        List<Fiche_de_synthese__c> listFDSToInsert = new List<Fiche_de_synthese__c>();
        
        //Create FDS renseignée (mettre 0 sur le champ Ventes services P1) + Commentaire
        for(Opportunity opp:listOpps){
            Fiche_de_synthese__c newFDS = new Fiche_de_synthese__c();
            String fdsName = Label.AP116_FDSName + ' ' + opp.Name;
            if(fdsName.length() > 80){
                fdsName = fdsName.substring(0,74);
            }
            newFDS.Name = fdsName;
            newFDS.Opportunit_commerciale__c = opp.Id;
            newFDS.ConditionsDeReference__c = Label.AP16_ConditionsDeReference;
            newFDS.OffreA1P1VentesServices__c = 0;
            newFDS.CommentairesValorisationOffre__c = Label.Batch128_FDSCommentaire;
            listFDSToInsert.add(newFDS);
        }
        
        Insert listFDSToInsert;
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}