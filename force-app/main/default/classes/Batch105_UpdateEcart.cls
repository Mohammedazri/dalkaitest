/** 
* @author Jacques Akiki - Ei technologies
* @date 02/12/2020 
* @description 
* @Test Class Batch105_UpdateEcart_test 
*/
global class Batch105_UpdateEcart implements Database.Batchable<SObject>{

	global Database.QueryLocator start(Database.BatchableContext bc)
    {
		String query = 'SELECT id,Opportunit_commerciale__c, Opportunit_commerciale__r.Tech_CA_Ecart__c , Opportunit_commerciale__r.Tech_Marge_Brute_Ecart__c,BudgetNSousTotP1234CaEcart__c,BudgetNSousTotP1234MbEcart__c  FROM Fiche_de_synthese__c WHERE Opportunit_commerciale__c in ( SELECT id FROM Opportunity WHERE Nb_de_fiches_synthese__c !=0 and Tech_CdtRefSelectionnee__c = NULL ) and Budget__c !=NULL ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c> ListFDS)
    {
       List<Opportunity> listOppUpdate = new List<Opportunity>();
       for(Fiche_de_synthese__c fds :ListFDS)
       {
           Opportunity opp = new Opportunity(id = fds.Opportunit_commerciale__c);
           opp.Tech_CA_Ecart__c = fds.BudgetNSousTotP1234CaEcart__c;
           opp.Tech_Marge_Brute_Ecart__c = fds.BudgetNSousTotP1234MbEcart__c;
           opp.Tech_CdtRefSelectionnee__c = Label.LC12_Budget;
           listOppUpdate.add(opp);
       }
        if (listOppUpdate!=NULL && listOppUpdate.size()>0)
        {
            update listOppUpdate;
        }
        
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
}