/**
 * @author Jimmy Khalil - Ei technologies
 * @date 03/02/2022
 * @description  US C360-588: Batch To update the FDS of the Opp Concurrentes (RDD)
 * @Test Class Batch114_UpdateOppConcurrentes_Test 100%
 */
global class Batch114_UpdateOppConcurrentes implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){

        Date year2022 = Date.valueOf('2022-01-01');
        //Get FDS of Opp concurrente white Annee realisation > 2022
        String query = 'select id,Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c from Fiche_de_synthese__c where Opportunit_commerciale__r.OpportuniteDorigine__c !=null And Opportunit_commerciale__r.Tech_AnneeDeSignaturePrevue__c >= :year2022 ';

        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext bc, List<Fiche_de_synthese__c> listFDS){
        //Vider la colonne "budget corrigé" sur le verso
        //query all the records of the custom setting CS02_FDS_ValorisationRecto__c that contains the Saisie__c fields and are editable
        List<CS02_FDS_ValorisationRecto__c> allWrap = [SELECT Saisie__c, editable__c
                                                       FROM CS02_FDS_ValorisationRecto__c
                                                       WHERE Saisie__c != null AND editable__c = true];

        List<Opportunity> listOppUpdate = new List<Opportunity>();

        for(Fiche_de_synthese__c myFDS : listFDS) {
            //la colonne "budget corrigé" sur le verso est base sur le champ Saisie__c du custom setting CS02_FDS_ValorisationRecto__c (LC34_RectoValorisation_Controller)
            for(CS02_FDS_ValorisationRecto__c cust : allWrap) {
                if(cust.Saisie__c != null && cust.editable__c) {
                    myFDS.put(cust.Saisie__c, null);
                }
            }

            //avoir les conditions de référence à "Budget"
            myFDS.ConditionsDeReference__c = Label.LC12_Budget;
            myFDS.Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c = Label.LC12_Budget;

            listOppUpdate.add(myFDS.Opportunit_commerciale__r);

            //ne plus avoir de budget de référence
            myFDS.Budget__c = null;
            myFDS.Budget_Realise__c = null;
        }

        update listFDS;
        update listOppUpdate;

    }

    global void finish(Database.BatchableContext bc){}
}