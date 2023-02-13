/**
 * @author Jacques Akiki - Ei technologies
 * @date 16/03/2022
 * @description  Batch pour la MAJ du Budget de reference 
 * @Test Class Batch123_UpdateBudgetOppFDS_Test 100%
 */
global class Batch123_UpdateBudgetOppFDS implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){

        BudgetCourant__c BudgetCourant = BudgetCourant__c.getValues('BudgetCourant');
        String AnneeBudget = BudgetCourant.Annee__c;
        String statOpp = Label.LC29_newStat;
        String query = 'SELECT id,tech_Budget__c,(SELECT id FROM FicheSynthese__r) FROM Opportunity WHERE Statut__c =:statOpp AND ';
        String query2 = 'tech_Budget__c!=NULL AND tech_Budget__r.AnneeBudget__c!=:AnneeBudget AND Annee_de_signature__c =:AnneeBudget';
        return Database.getQueryLocator(query + query2);
    }
    global void execute (Database.BatchableContext bc, List<Opportunity> listOpp){
        List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        for (Opportunity opp:listOpp){
            opp.tech_Budget__c = null;
            if (opp.FicheSynthese__r!=NULL && opp.FicheSynthese__r.size()>0){
                listFDS.add(new Fiche_de_synthese__c(id=opp.FicheSynthese__r[0].id,Budget__c=null,Budget_Realise__c=null)); 
            }

        }
        if(listOpp!=NULL && listOpp.size()>0){
            update listOpp;
        }
        if(listFDS!=NULL && listFDS.size()>0){
            update listFDS;
        }
    }

    global void finish(Database.BatchableContext bc){   
        Utils_Objectifs.removeBypassUser();
    }
}