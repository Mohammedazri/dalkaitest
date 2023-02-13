/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Apex Scheduler used for the batch AP03_CallExplore
Test Class: AP03_CallExplore_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class SCHD03_AP03_CallExplore implements Schedulable{
    global void execute(SchedulableContext SC) { 
        AP03_CallExplore.CallExplore();
    }
}