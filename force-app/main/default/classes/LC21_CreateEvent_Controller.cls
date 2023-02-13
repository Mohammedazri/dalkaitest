/*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: Apex controller for the lightning component LC21_CreateEvent 
Test Class: LC21_CreateEvent_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC21_CreateEvent_Controller {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: method that inserts the new event and returns an error if the insert failed
Inputs: Event
Returns: String
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static string SaveEvent(Event newEvent)
    {
        
        string result;
        try{
            insert newEvent;
            result='SUCCESS';
            return result;
        }
        catch(exception e)
        {
            result=System.Label.CmpCreateEventErreur;
            return result;
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: method that returns the values of the picklist field Type of the object event as a list of strings
Inputs: -
Returns: List of Strings
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled 
    public static List<String> getpickvalType() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Event.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: method that returns the values of the picklist field genre_comite__c of the object event as a list of strings
Inputs: -
Returns: List of Strings
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled 
    public static List<String> getpickvalTypeActivity() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Event.genre_comite__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
}