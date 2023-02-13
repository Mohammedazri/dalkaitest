/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Apex controller for the lightning component LC25_CreateOpportunity 
Test Class: LC25_CreateOpportunity_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC25_CreateOpportunity_Controller {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: method that checks whether profile can create opp or not, if can -> show button on lightning page 
Inputs: -
Returns: boolean
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static boolean canCreateOpp(){
        Schema.DescribeSObjectResult objectDescribe  = Opportunity.SObjectType.getDescribe();
        boolean retVal = false;
        if(objectDescribe.isCreateable()){
            retVal = true;
        }
        return retVal;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: method that returns the list of record types for the connected user
Inputs: -
Returns:  list of RecordTypeObj
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static list<RecordTypeObj> getRecordTypes(){
        list<RecordTypeObj> retVal = new list<RecordTypeObj>();
        
        String str= Label.LC25_RecType;
        
        for (String plist :str.split(';') ) 
        { 
            retVal.add(new RecordTypeObj(plist));
        }
        return retVal;
    }
    
    
}