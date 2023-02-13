/** 
* @author Jacques Akiki - Ei technologies
* @date 10/08/2021 
* @description Batch qui gère les champs commentaire et description sur Opportunité
* @Test Class Batch119_MAJCommentaire_test 100%
*/

global class Batch119_MAJCommentaire implements Database.Batchable<sObject> {
    
    /** 
* @author Jacques Akiki
* @date 10/08/2021 
* @chercher les Opportunités
*/    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'SELECT id, description, Commentaire__c FROM Opportunity';
        
        return Database.getQueryLocator(query);
    }
    
    /** 
* @author Jacques Akiki
* @date 10/08/2021
* @vide rle champ description et le mettre dans le champ commentaire 
*/
    global void execute(Database.BatchableContext BC, List<Opportunity> listOpp)
    {
        list<Opportunity> listOppUpdate = new list<Opportunity>();
        for(Opportunity opp: listOpp)
        {
            if(opp.description!=NULL)
            {
                opp.Commentaire__c = (opp.Commentaire__c!=NULL?'Commentaire: '+opp.Commentaire__c+'<br>':'')+'<p>Description: '+opp.description+'</p>';
                opp.description = '';
                listOppUpdate.add(opp);
            }
        }
        if (listOppUpdate!=NULL && listOppUpdate.size()>0)
        {
            update listOppUpdate;
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}