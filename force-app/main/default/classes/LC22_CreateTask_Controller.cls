/*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: Apex controller for the lightning component LC22_CreateTask 
Test Class: LC22_CreateTask_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC22_CreateTask_Controller {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: method that inserts the new Task and returns an error if the insert failed
Inputs: Task
Returns: String
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static string SaveTask(Task newTask)
    {
        system.debug('##newTask '+ newTask);
        string result;
        try{
            insert newTask;
            result='SUCCESS';
            system.debug('result '+ result);
            return result;
        }
        catch(exception e)
        {
            system.debug('e.getMessage '+ e.getMessage());
            result=System.Label.CmpCreateTaskErreur;
            return result;
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: method that returns the values of the picklist field Priority of the object Task as a list of strings
Inputs: -
Returns: List of Strings
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled 
    public static List<String> getpickvalPriority() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Priority.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: method that returns the values of the picklist field Status of the object Task as a list of strings
Inputs: -
Returns: List of Strings
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled 
    public static List<String> getpickvalStatus() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: method that returns the values of the picklist field genre_comite__c of the object Task as a list of strings
Inputs: -
Returns: List of Strings
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled 
    public static List<String> getpickvalActivityType() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.genre_comite__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
}