/** 
* @author Jacques Akiki - Ei technologies
* @date 21/01/2020 
* @description Batch qui met a jour le champ Ecart nb heure P2 sur Opp par la valeur du champ Ecart nb heure P2 sur fiche de synthèse
* @Test Class Batch108_UpdateOppEcartP2_test 100%
*/

global class Batch108_UpdateOppEcartP2 implements Database.Batchable<sObject> {
   
/** 
* @author Jacques Akiki
* @date 21/01/2021
* @chercher les fiche de synthèses
*/    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'SELECT id, Opportunit_commerciale__c ,EcartNbHP2SelonConditionReference__c FROM Fiche_de_synthese__c'+
            ' WHERE ConditionsDeReference__c = \'Budget Corrigé\'  AND SaisieRefMainOeuvreDontNbHeureP2__c =NULL'+ 
            ' AND (Opportunit_commerciale__r.ZZZ_Tech_Heures_P2_Ecart__c !=NULL OR Opportunit_commerciale__r.ZZZ_Tech_Heures_P2_Ecart__c !=0)';
        
        return Database.getQueryLocator(query);
    }
    
    /** 
* @author Jacques Akiki
* @date 21/01/2020
* @mettre à jour le champ Heures P2 (écart) au niveau de l'opportunité
*/
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c> listFDS)
    {
        List<Opportunity> listOpp = new List<Opportunity>();
        
        for(Fiche_de_synthese__c fds : listFDS)
        {
            if(FDS.Opportunit_commerciale__c != null)
            {
                Opportunity opp = new Opportunity();
                opp.id = fds.Opportunit_commerciale__c;
                opp.ZZZ_Tech_Heures_P2_Ecart__c = FDS.EcartNbHP2SelonConditionReference__c;
                listOpp.add(opp);   
            }
        }
        
        if(listOpp.size() > 0)
        {
            update listOpp;
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}