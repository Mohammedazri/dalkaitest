/**
* @author Jimmy Khalil - EIT Mena
* @date 20/07/2022
* @description Créer des FdS non renseignées (Offre A1 non renseignées) pour les opportunités à l'étape Piste et Etude en cours sans fiche de synthèse (RDD US C360-717)
* @Test Class Batch128_CreateFDS_Test 100%
*/

global class Batch128_CreateFDS implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //Get All Opps at Etude or Piste wihtout FDS
        String query = 'select id,Name,Amount,MargeBruteOffre__c,Heures_P2_Offre__c,CAP6Offre__c,MBP6Offre__c from Opportunity where (StageName =\'Etude\' or StageName =\'Piste\') And Statut__c =\'En cours\' And Id not in (Select Opportunit_commerciale__c from Fiche_de_synthese__c)';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc, List<Opportunity> listOpps){
        
        List<Fiche_de_synthese__c> listFDSToInsert = new List<Fiche_de_synthese__c>();
        
        //Create FDS + Commentaire
        for(Opportunity opp:listOpps){
            Fiche_de_synthese__c newFDS = new Fiche_de_synthese__c();
            String fdsName = Label.AP116_FDSName + ' ' + opp.Name;
            if(fdsName.length() > 80){
                fdsName = fdsName.substring(0,74);
            }
            newFDS.Name = fdsName;
            newFDS.Opportunit_commerciale__c = opp.Id;
            newFDS.ConditionsDeReference__c = Label.AP16_ConditionsDeReference;
            newFDS.CommentairesValorisationOffre__c = Label.Batch128_FDSCommentaire;
            listFDSToInsert.add(newFDS);
        }
        
        Insert listFDSToInsert;
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}