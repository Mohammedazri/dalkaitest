/**
 * @author Jimmy Khalil - EIT Mena
 * @date 01/12/2022
 * @description Update RelaisDatePassageGagnee__c field on Opp (RDD US C360-179)
 * @Test Class Batch133_UpdateDateRealise_Test 93%
 */

global class Batch133_UpdateDateRealise implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){
        String fieldStageName = 'StageName';
        String anneeSignature = '2022';
        //Get All opps of Annee signature 2022 with the latest history on the StageName field
        String query = 'select id,name,StageName, Statut__c, DateDePassageEnRealisation__c, RelaisDatePassageGagnee__c,' +
        '(Select id,OldValue, NewValue, CreatedDate from Histories where Field =:fieldStageName' +
        '  order by CreatedDate desc limit 1) ' +
        'from Opportunity where Annee_de_signature__c =:anneeSignature';

        return Database.getQueryLocator(query);
    }

    global void execute (Database.BatchableContext bc, List<Opportunity> listOpportunity){

        for(Opportunity opp : listOpportunity) {
            //pour une opp realisé, verifier la date de creation de la derniere historique sur StageName = 'Réalisation'
            if(opp.StageName == Label.PV_Realisation) {
                if(opp.Histories != null && opp.Histories.size() > 0) {
                    if(opp.Histories[0].NewValue == Label.PV_Realisation) {
                        opp.RelaisDatePassageGagnee__c = opp.Histories[0].CreatedDate.format('yyyy-MM-dd');
                    }
                }
            } else {
                //pour une opp non realisé, vider le champ
                opp.RelaisDatePassageGagnee__c = null;
            }

        }

        Update listOpportunity;
    }

    global void finish(Database.BatchableContext bc){}
}