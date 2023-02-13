/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: The aim of this class is to update the commercial project name when the name of the related opportunity is changed
Test Class: AP21_Opportunity_Test
--------------------------------------------------------------------------------------------------------------------------*/
public class AP21_Opportunity {
    /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
	 Company: EI-technologies
	 Description: Update the commercial project name when the name of the related opportunity is changed(if the project is only related to one opportunity)
     Inputs: list of the modified opportunities
	 Returns: -
	----------------------------------------------------------------------------------------------------------------------------*/
    public static void opportunityProjetCommercial(list<Opportunity> listOpportunity, map<id,opportunity> oldMapOpp){       
        set<id> setProjetCommercial = new set<id>();
        map<id,list<Opportunity>> mapProjetOpportunities = new map<id,list<Opportunity>>();
        for(Opportunity opp : listOpportunity){
            if((opp.ProjetCommercial__c != NULL && opp.Name != oldMapOpp.get(opp.id).name) || opp.ProjetCommercial__c != oldMapOpp.get(opp.id).ProjetCommercial__c) {
                setProjetCommercial.add(opp.ProjetCommercial__c); 
            }
        }
        if(setProjetCommercial!=NULL)
        {
        list<opportunity> listOpportunity2 = [select id,name , ProjetCommercial__r.name 
                                              from opportunity 
                                              where ProjetCommercial__c in:setProjetCommercial];
        
        for(Opportunity opp : listOpportunity2){
            if(! mapProjetOpportunities.containsKey(opp.ProjetCommercial__c)){
                mapProjetOpportunities.put(opp.ProjetCommercial__c, new list<Opportunity>());
            }
            mapProjetOpportunities.get(opp.ProjetCommercial__c).add(opp);
            
        }
        
        list<ProjetCommercial__c> listProjetToUpdate = new list<ProjetCommercial__c>();
        for(id projet : mapProjetOpportunities.keySet()){
            list<Opportunity> listOpportunities = mapProjetOpportunities.get(projet);
            if(listOpportunities.size() == 1){
                mapProjetOpportunities.get(projet)[0].ProjetCommercial__r.name = listOpportunities[0].name;
                listProjetToUpdate.add(listOpportunities[0].ProjetCommercial__r);
            }}
        
        update listProjetToUpdate;        
        }
    }    
}