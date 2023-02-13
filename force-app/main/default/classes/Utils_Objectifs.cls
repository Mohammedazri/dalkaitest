/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description:  Class used to get the value of the fields TECH_Objectif__c on Opportunity 
Test Class: Utils_Objectifs_test 88%
--------------------------------------------------------------------------------------------------------------------------*/
public class Utils_Objectifs {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author:  Dona Kfoury
Company: EI-technologies
Description:  function used to get the objectifs reference field on the opportunity when an opportunity is created or edited and when an "objectif" is created or edited
Inputs: List of "Objectif" , Opportunity List and a boolean that indicates if it's a before or an after trigger
Returns: an opportunity List 
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static list<Opportunity> UpdateLookupOfOpportunityCommercial(list<Objectif__c> ObjectifList, list<Opportunity> listOpportunity, boolean ifAfter)
    {
        if(listOpportunity == null)
        {
            set<Id>SetCommercialsId= new set<Id>();
            set<String>SetAnnee= new set<String>();
            for(Objectif__c thisObj: ObjectifList)
            {
                SetCommercialsId.add(thisObj.Commercial__c);
                SetAnnee.add(thisObj.Annee__c);
            }
            
            listOpportunity = [SELECT id, Type_pers__c, Amount, Segment_client__c, Annee_de_signature__c, OwnerId, TECH_Objectif__c  /*add other filters and MB*/
                               FROM Opportunity
                               WHERE OwnerId in:SetCommercialsId And Annee_de_signature__c in:SetAnnee];            
        }
        
        map<string, list<Opportunity>> mapUnique_Opportunity = new map<string, list<Opportunity>>();
        
        for(Opportunity opp : listOpportunity)
        {
            string newUniqueKey = opp.OwnerId + '_' + opp.Annee_de_signature__c;
            if(!mapUnique_Opportunity.containskey(newUniqueKey)){
                mapUnique_Opportunity.put(newUniqueKey, new list<Opportunity>());
            }  
            mapUnique_Opportunity.get(newUniqueKey).add(opp);
        }
        
        list<Opportunity> listOpportunity_ToUpdate = new list<Opportunity>();
        Set<Id> SetOpportunity_Changed = new Set<Id>();
        if(ObjectifList== null || ObjectifList.size() == 0)
        {
            for(Opportunity thisOpp :listOpportunity)
            {
                thisOpp.TECH_Objectif__c =null;
                if(ifAfter)
                {
                    listOpportunity_ToUpdate.add(thisOpp);
                }
            }
        }
        else
        {
            for(Objectif__c thisObj: ObjectifList)
            {
                string newUniqueKey = thisObj.Commercial__c + '_' + thisObj.Annee__c;
                
                if(mapUnique_Opportunity.containskey(newUniqueKey))
                {
                    for(Opportunity thisOpp : mapUnique_Opportunity.get(newUniqueKey))
                    {
                        SetOpportunity_Changed.add(thisOpp.Id);
                        if(thisOpp.TECH_Objectif__c != thisObj.Id)
                        {
                            thisOpp.TECH_Objectif__c = thisObj.Id;
                            if(ifAfter)
                            {
                                listOpportunity_ToUpdate.add(thisOpp);
                            }
                        }
                    }
                }
            }
            for(Opportunity thisOpp :listOpportunity)
            {
                if(!SetOpportunity_Changed.contains(thisOpp.Id))
                {
                    thisOpp.TECH_Objectif__c =null;
                    if(ifAfter)
                    {
                        listOpportunity_ToUpdate.add(thisOpp);
                    }
                }
            }
        }
        
        return listOpportunity_ToUpdate;
        
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author:  Dona Kfoury
Company: EI-technologies
Description:  class used to empty the objectif reference field on an opportunity when an objectif is edited and is no longer related to the opportunity 
Inputs: List of "Objectif"  
Returns: an opportunity List 
----------------------------------------------------------------------------------------------------------------------------*/   
    public static list<Opportunity> RemoveLookupOfOpportunityCommercial(list<Objectif__c> oldObjectifList)
    {
        list<Opportunity> listOpportunity = [SELECT id, Type_pers__c, Amount, Segment_client__c, CloseDate, OwnerId, TECH_Objectif__c  /*add other filters and MB*/
                                             FROM Opportunity
                                             WHERE TECH_Objectif__c IN :oldObjectifList];           
        
        
        for(Opportunity opp : listOpportunity)
        {
            opp.TECH_Objectif__c = null;
        }     
        
        return listOpportunity;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author:  Jimmy Khalil
Company: EI-technologies
Description:  Bypass for User 
Inputs:   
Returns: 
----------------------------------------------------------------------------------------------------------------------------*/ 
    public static void bypassUser()
    {
        Schema.DescribeSObjectResult objSchema = User.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
        List<Schema.Picklistentry>fld =fieldmap.get('Bypass_Triggers__c').getDescribe().getpicklistValues();
        //System.debug('fld'+fld);
        List<String> pickList = new List<String>();
        
        for(Schema.Picklistentry pl : fld)
        {
            pickList.add(pl.getValue()) ;
        }
        User currentUser = [SELECT id,Bypass_Triggers__c,Bypass_Workflow__c,BypassDuplicateRules__c,BypassFilters__c,
                            BypassProcessBuilder__c,BypassValidationRules__c
                            FROM User
                            WHERE id =:userInfo.getUserId() limit 1];
        currentUser.techBypassTriggers__c =currentUser.Bypass_Triggers__c;
        currentUser.TechBypassWorkFlow__c =currentUser.Bypass_Workflow__c ;
        currentUser.TechBypassDuplicateRules__c =currentUser.BypassDuplicateRules__c ;
        currentUser.TechBypassFilters__c =currentUser.BypassFilters__c ;
        currentUser.TechBypassProcessBuilder__c =currentUser.BypassProcessBuilder__c ;
        currentUser.TechBypassValidationRules__c=currentUser.BypassValidationRules__c;
        
        currentUser.Bypass_Triggers__c = String.join(pickList, ';');
        currentUser.Bypass_Workflow__c = true;
        currentUser.BypassDuplicateRules__c = true;
        currentUser.BypassFilters__c = true;
        currentUser.BypassProcessBuilder__c = true;
        currentUser.BypassValidationRules__c = true;
        
        update currentUser;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author:  Jimmy Khalil
Company: EI-technologies
Description:  remove Bypass for User 
Inputs:   
Returns: 
----------------------------------------------------------------------------------------------------------------------------*/ 
    public static void removeBypassUser()
    {
        User currentUser = [SELECT id,techBypassTriggers__c,TechBypassWorkFlow__c,TechBypassDuplicateRules__c,TechBypassFilters__c,
                            TechBypassProcessBuilder__c,TechBypassValidationRules__c
                            FROM User
                            WHERE id =:userInfo.getUserId() limit 1];
        currentUser.Bypass_Triggers__c = currentUser.techBypassTriggers__c;
        currentUser.Bypass_Workflow__c = currentUser.TechBypassWorkFlow__c;
        currentUser.BypassDuplicateRules__c = currentUser.TechBypassDuplicateRules__c;
        currentUser.BypassFilters__c = currentUser.TechBypassFilters__c;
        currentUser.BypassProcessBuilder__c = currentUser.TechBypassProcessBuilder__c;
        currentUser.BypassValidationRules__c = currentUser.TechBypassValidationRules__c;
        currentUser.techBypassTriggers__c =null;
        currentUser.TechBypassWorkFlow__c =false ;
        currentUser.TechBypassDuplicateRules__c =false ;
        currentUser.TechBypassFilters__c =false ;
        currentUser.TechBypassProcessBuilder__c =false ;
        currentUser.TechBypassValidationRules__c=false;
        
        update currentUser;
    }
}