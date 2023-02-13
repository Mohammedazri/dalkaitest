/** 
* @author Jimmy Khalil
* @date 08/09/2021 
* @description Batch qui met à jour le lien entre les opportunites et les objectif regional 
* @Test Class 
*/

global class Batch119_ObjectifRegional implements Database.Batchable<SObject>{
    
    public Map<String,String> mapRegionAnneIdObj = new Map<String,String>();
    public Set<String> setRegion = new Set<String>();
    public Set<String> setAnnee = new Set<String>();
    String agenceE2S = '%'+Label.Opp_E2S+'%'; 
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //system.debug('@@@ JK setRegion ' + setRegion);
        //system.debug('@@@ JK setAnnee ' + setAnnee);
        
        String query='SELECT id,Libelle_Region__c,Annee_de_signature__c '+
            'FROM Opportunity '+
            'WHERE (Libelle_Region__c in:setRegion AND Annee_de_signature__c in :setAnnee) AND (NOT (Libelle_Agence__r.Name like :agenceE2S))';
        //system.debug('@@@ JK query: ' + query);
        return Database.getQueryLocator(query); 
    }
    
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpportunity)
    {
        //grant all bypasses to user
        Utils_Objectifs.bypassUser();
        
        for(Opportunity opp:listOpportunity){
            //system.debug('@@@ JK match : ' + opp.Libelle_Region__c + '_' + opp.Annee_de_signature__c);
            if(mapRegionAnneIdObj.containsKey(opp.Libelle_Region__c + '_' + opp.Annee_de_signature__c)){
                opp.TECH_Objectif_Regional__c = mapRegionAnneIdObj.get(opp.Libelle_Region__c + '_' + opp.Annee_de_signature__c);
            }
        }
        
        update listOpportunity;
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        //remove all bypasses from user
        Utils_Objectifs.removeBypassUser();
    }
}