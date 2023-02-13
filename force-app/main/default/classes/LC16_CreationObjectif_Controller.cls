/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Class used as an apex controller for the lightning component LC16_CreationObjectif
Test Class: LC16_CreationObjectif_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public with sharing class LC16_CreationObjectif_Controller {
    
   /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: method that checks whether profile can create opp or not, if can -> show button on lightning page
Inputs: - 
Returns: boolean
----------------------------------------------------------------------------------------------------------------------------*/  
    @AuraEnabled
    public static boolean canCreateObjectif(){
        Schema.DescribeSObjectResult objectDescribe  = Objectif__c.SObjectType.getDescribe();
        boolean retVal = false;
        if(objectDescribe.isCreateable()){
            retVal = true;
        }
        return retVal;
    }
}