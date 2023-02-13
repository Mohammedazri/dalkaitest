/*--------------------------------------------------------------------------------------------------------------------------
Company: EI-Technologies
Description: Apex Scheduler used for the batch Batch123_DeleteConsigne
Test Class: Batch123_DeleteConsigne_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class SCHD123_Batch123_DeletedConsigne implements Schedulable{
    //public static String sched = '0 30 2 ? * MON	';  //Every week Mon at 9:00 PM 
    //global static String scheduleMe() 
    //{
    //    SCHD123_Batch123_DeletedConsigne SC = new  SCHD123_Batch123_DeletedConsigne();
    //    return System.schedule('Delete_Consignes_after_1Week', sched, SC);
    //}
    global void execute(SchedulableContext sc) 
    {    
        Batch123_DeleteConsigne myBatch= new Batch123_DeleteConsigne();
        ID batchprocessid = Database.executeBatch(myBatch,50);
    }
}