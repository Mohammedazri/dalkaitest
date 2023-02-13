global class SCHD04_Batch03_DeleteWebserviceLog implements Schedulable{
        public static String sched = '0 0 6 ? * MON';  //Monday on 6 am 
    
    
    global static String scheduleMe() 
    {
        SCHD04_Batch03_DeleteWebserviceLog SC = new  SCHD04_Batch03_DeleteWebserviceLog();
        return System.schedule('Del_WS_Log_Job', sched, SC);
    }

    global void execute(SchedulableContext sc) 
    {    
        system.debug('execute me');
        Batch03_DeleteWebserviceLog myBatch= new Batch03_DeleteWebserviceLog();
        ID batchprocessid = Database.executeBatch(myBatch,50);
    }

}