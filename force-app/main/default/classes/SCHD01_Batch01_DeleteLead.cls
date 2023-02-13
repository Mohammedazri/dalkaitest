/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Apex Scheduler used for the batch Batch01_DeleteLead
Test Class: Batch01_DeleteLead_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class SCHD01_Batch01_DeleteLead implements Schedulable{
    public static String sched = '0 0 21 * * ?	';  //Every day at 9:00 PM 
    global static String scheduleMe() 
    {
        SCHD01_Batch01_DeleteLead SC = new  SCHD01_Batch01_DeleteLead();
        return System.schedule('Delete_Leads_after_3Months', sched, SC);
    }
    global void execute(SchedulableContext sc) 
    {    
        Batch01_DeleteLead myBatch= new Batch01_DeleteLead();
        ID batchprocessid = Database.executeBatch(myBatch,50);
    }
}