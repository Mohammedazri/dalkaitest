/** 
* @author Jimmy Khalil - Ei technologies
* @date 15/11/2021 
* @description Batch pour calculer les champs CA P6 (Offre) et MB P6 (Offre) sur opportunity depuis les fds C360-560
* @Test Class Batch121_MAJCaMbP6Opp_Test 100%
*/

global class Batch121_MAJCaMbP6Opp implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        String query = 'SELECT id,CAP6Offre__c,MBP6Offre__c  '
            +' FROM Opportunity';
        system.debug('** query = '+query);
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> listOpp)
    {
        Set<String> setOppIds = new Set<String>();
        //CA P6 (Offre) = somme Ventes services P6 (Offre A1)
        Map<String,Decimal> mapOppIdCA = new Map<String,Decimal>();
        //MB P6 (Offre) = somme Marge brute P6 (Offre A1)
        Map<String,Decimal> mapOppIdMB = new Map<String,Decimal>();
        
        //get all opps IDs
        for(Opportunity opp: listOpp)
        {
            setOppIds.add(opp.Id);
        }
        
        //get related fds
        List<Fiche_de_synthese__c> listRelatedFDS = [Select Id,OffreA1P6VentesServices__c,OffreA1P6MargeBrute__c,Opportunit_commerciale__c
                                                     From Fiche_de_synthese__c
                                                     Where Opportunit_commerciale__c in :setOppIds];
        
        if(listRelatedFDS != null && listRelatedFDS.size()>0){
            for(Fiche_de_synthese__c fds:listRelatedFDS){
                //CA P6 (Offre) = somme Ventes services P6 (Offre A1)
                if(!mapOppIdCA.containsKey(fds.Opportunit_commerciale__c)){
                    mapOppIdCA.put(fds.Opportunit_commerciale__c,0);
                }
                if(fds.OffreA1P6VentesServices__c != null){
                    mapOppIdCA.put(fds.Opportunit_commerciale__c,mapOppIdCA.get(fds.Opportunit_commerciale__c) + fds.OffreA1P6VentesServices__c);
                }
                
                
                //MB P6 (Offre) = somme Marge brute P6 (Offre A1)
                if(!mapOppIdMB.containsKey(fds.Opportunit_commerciale__c)){
                    mapOppIdMB.put(fds.Opportunit_commerciale__c,0);
                }
                if(fds.OffreA1P6MargeBrute__c != null){
                    mapOppIdMB.put(fds.Opportunit_commerciale__c,mapOppIdMB.get(fds.Opportunit_commerciale__c) + fds.OffreA1P6MargeBrute__c);
                }
            }
        }
        
        for(Opportunity opp: listOpp)
        {
            //if the opp has related fds, we get the value from the maps
            //if not, we empty the fields
            
            if(mapOppIdCA.containsKey(opp.Id)){
                opp.CAP6Offre__c = mapOppIdCA.get(opp.Id);
            }else{
                opp.CAP6Offre__c = 0;
            }
            
            if(mapOppIdMB.containsKey(opp.Id)){
                opp.MBP6Offre__c = mapOppIdMB.get(opp.Id);
            }else{
                opp.MBP6Offre__c = 0; 
            }
        }
        update listOpp;
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext BC) 
    {
    }
}