/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Class used by opportunity triggers OpportunityBeforeInsert and OpportunityBeforeUpdate to update the the lookup fields
             TECH_Objectif__c on Opportunity by calling the function Utils_Objectifs.UpdateLookupOfOpportunityCommercial
Test Class: AP07_Opportunity_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/

public without sharing class AP07_Opportunity 
{
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function is used by OpportunityBeforeInsert and it calls the function UpdateLookupOfOpportunityCommercial from the class
             Utils_Objectifs after getting the related List of objectifs using the field TECH_Unique__c on Objectif__c
Inputs: list of Opportunities
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static void UpdateOpportunityBeforeInsert(list<Opportunity> listOpportunities)
    {
        
        set<string> setUniqueIds = new set<string>();
        
        set<Id> setOwnerId = new set<Id>();
        for(Opportunity opp : listOpportunities)
        {
            setUniqueIds.add('C' + opp.Annee_de_signature__c + '_' + string.valueof(opp.OwnerId).left(15)+'_'+(opp.Libelle_Agence__c!=NULL?string.valueof(opp.Libelle_Agence__c).left(15):''));
            
            setOwnerId.add(opp.OwnerId);
        }
        system.debug('!!setUniqueIds  ' + setUniqueIds);
        list<Objectif__c> listObjectifs = [SELECT Id, Annee__c, Commercial__c,AgenceDeObjectif__c ,Region__c, Siege__c, recordType.developerName, Siege__r.Code_Siege__c, Region__r.Code_Region__c
                                           FROM Objectif__c
                                           WHERE TECH_Unique__c IN :setUniqueIds
                                           AND RecordType.DeveloperName !=:Label.Objectif_regional];
        
        Utils_Objectifs.UpdateLookupOfOpportunityCommercial(listObjectifs, listOpportunities, false);
        
    }
    
    
    
       /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description:this function is used by OpportunityBeforeUpdate and it calls the function UpdateLookupOfOpportunityCommercial from 
            the class Utils_Objectifs after getting the related List of objectifs using the field TECH_Unique__c on Objectif__c
Inputs: list of Opportunities
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static List<Opportunity> UpdateOpportunityBeforeUpdate(list<Opportunity> listOpportunities)
    { 
        
        set<string> setUniqueIds = new set<string>();
        
        set<Id> setOwnerId = new set<Id>();
        
        for(Opportunity opp : listOpportunities)
        {
            setUniqueIds.add('C' + opp.Annee_de_signature__c + '_' + string.valueof(opp.OwnerId).left(15)+'_'+(opp.Libelle_Agence__c!=NULL?string.valueof(opp.Libelle_Agence__c).left(15):''));
            
            setOwnerId.add(opp.OwnerId);
        }
        
        
        list<Objectif__c> listObjectifs = [SELECT Id, Annee__c, Commercial__c, AgenceDeObjectif__c,Region__c, Siege__c, recordType.developerName, Siege__r.Code_Siege__c, Region__r.Code_Region__c
                                           FROM Objectif__c
                                           WHERE TECH_Unique__c IN :setUniqueIds
                                           AND RecordType.DeveloperName !=:Label.Objectif_regional];
        
        Utils_Objectifs.UpdateLookupOfOpportunityCommercial(listObjectifs, listOpportunities, false); 
        
        
        return null;
    }
    
    
    
}