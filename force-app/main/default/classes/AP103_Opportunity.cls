/*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: Class used by opportunity triggers OpportunityBeforeInsert and OpportunityBeforeUpdate to update the the lookup fields
ZZZ TECH_Objectif_Regional on Opportunity
Test Class: 
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/

public without sharing class AP103_Opportunity 
{
    
    public static void updateTechObjectifRegional(list<Opportunity> listOpportunities)
    {
        Set<String> agenceIDSet = new Set<String>();
        for(Opportunity opp : listOpportunities)
        {
            if(opp.Libelle_Agence__c!=null){
                agenceIDSet.add(opp.Libelle_Agence__c);
            }
        }
        
        if(agenceIDSet.size()>0){
            Map <ID,Agence__c> mapAgenceIdAgence = new Map<ID, Agence__c>([Select Id,Name,Region__c  From Agence__c Where Id in:agenceIDSet]);
            
            if(mapAgenceIdAgence != null && mapAgenceIdAgence.size()>0){
                Map<string,List<Opportunity>> mapUniqueOpp = new Map<string,List<Opportunity>>();
                
                for(Opportunity opp : listOpportunities)
                {
                    if(opp.Libelle_Agence__c!=null &&
                       mapAgenceIdAgence.containsKey(opp.Libelle_Agence__c) &&
                       !mapAgenceIdAgence.get(opp.Libelle_Agence__c).Name.contains(Label.Opp_E2S) 
                       && opp.Annee_de_signature__c != null){
                           if(mapAgenceIdAgence.get(opp.Libelle_Agence__c).Region__c != null){
                               //get unique key
                               String unique = 'C' + opp.Annee_de_signature__c + '_' + string.valueof(mapAgenceIdAgence.get(opp.Libelle_Agence__c).Region__c).left(15);
                               system.debug('@@@ JK unique ' + unique);
                               if(!mapUniqueOpp.containsKey(unique)){
                                   mapUniqueOpp.put(unique,new List<Opportunity>());
                               }
                               mapUniqueOpp.get(unique).add(opp);
                           }
                       }
                    
                    
                    
                    //clear TECH_Objectif_Regional__c to put the new corresponding value
                    opp.TECH_Objectif_Regional__c = null;
                    
                }
                //get objectif regional by unique key
                list<Objectif__c> listObjectifs = [SELECT Id, TECH_Unique__c
                                                   FROM Objectif__c
                                                   WHERE TECH_Unique__c IN :mapUniqueOpp.keySet()
                                                   AND RecordType.DeveloperName = :Label.Objectif_regional];
                
                if(listObjectifs != null && listObjectifs.size()>0){
                    for(Objectif__c obj:listObjectifs){
                        //if unique key found, we match, if not, it is already cleared
                        if(mapUniqueOpp.containsKey(obj.TECH_Unique__c)){
                            for(Opportunity opp:mapUniqueOpp.get(obj.TECH_Unique__c)){
                                opp.TECH_Objectif_Regional__c = obj.Id;
                            }
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    
}