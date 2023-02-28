/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Class used to call the class Utils_Objectifs when inserting and updating an objectif and it updates the list 
of opportunity that was returned
Test Class: AP10_Objectif_Test 
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class AP06_Objectif {
    public static boolean isFirstTime = false;
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-technologies
Description: function used when an Objectif is added. It calls the class Utils_Objectifs to fill the objectifs reference field on 
the related opportunity 
Inputs: objectif list
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateObjectifInsert(List<Objectif__c> ObjectifList)
    {
        List<Opportunity> ListOppForUpdate = new List<Opportunity>();
        if(ObjectifList != null && ObjectifList.size()>0){
            ListOppForUpdate.addAll(Utils_Objectifs.UpdateLookupOfOpportunityCommercial(ObjectifList, null, true));
        }
        
        if(ListOppForUpdate!= null && ListOppForUpdate.size()>0)
        {
            Utils_Objectifs.bypassUser();
            update ListOppForUpdate;
            Utils_Objectifs.removeBypassUser();
        }
        
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-technologies
Description: function used when an Objectif is edited. It calls the class Utils_Objectifs to fill or empty the objectifs reference field on the related opportunity 
Inputs: new objectif list, old objectif list
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateObjectifUpdate(List<Objectif__c> ObjectifList, map<Id,Objectif__c> oldObjectifMap)
    {
        //when the after update is finished a workflow is launched and reentering the trigger because the bypasses are removed
        if(!isFirstTime){
            isFirstTime = true;
            List<Opportunity> ListOppForUpdate= new List<Opportunity>();
            
            
            List<Objectif__c>ListObjectifsCommercial=new List<Objectif__c>();
            List<Objectif__c>ListOldObjectifsCommercial=new List<Objectif__c>();
            
            for(Objectif__c thisObjectif:ObjectifList)
            {
                objectif__c oldObjectif=oldObjectifMap.get(thisObjectif.Id);
                if(thisObjectif.Commercial__c !=oldObjectif.Commercial__c || 
                   thisObjectif.Annee__c !=oldObjectif.Annee__c ||
                   thisObjectif.AgenceDeObjectif__c!=oldObjectif.AgenceDeObjectif__c) 
                {
                    ListObjectifsCommercial.add(thisObjectif);
                    ListOldObjectifsCommercial.add(oldObjectif);
                }
            }
            
            //Added by Jimmy: grant all bypasses to user
            
            if(ListObjectifsCommercial != null && ListObjectifsCommercial.size()>0){
                ListOppForUpdate.addAll(Utils_Objectifs.UpdateLookupOfOpportunityCommercial(ListObjectifsCommercial, null, true));
            }
            
            if(ListOldObjectifsCommercial != null && ListOldObjectifsCommercial.size()>0){
                ListOppForUpdate.addAll(Utils_Objectifs.RemoveLookupOfOpportunityCommercial(ListOldObjectifsCommercial));
            }
            
            if(ListOppForUpdate!= null && ListOppForUpdate.size()>0)
            {
                Utils_Objectifs.bypassUser();
                update ListOppForUpdate;
                Utils_Objectifs.removeBypassUser();
            }
        }
    }
}