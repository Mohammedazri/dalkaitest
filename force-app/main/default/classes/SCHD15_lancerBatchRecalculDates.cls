/** 
* @author Charbel Khoury Hanna - Ei technologies
* @date 20/12/2022 
* @description schedular qui va lancer le batch 135 pour recalculer les dates chaque nuit
* @Test Class SCHD11_test
*/
global without sharing class SCHD15_lancerBatchRecalculDates implements Schedulable{
    public static String sched = '0 30 23 30 DEC ? 2022/1';  //30 decembre de chaque année à 11H30 du soir 
    
    /** 
    * @author Charbel Khoury Hanna  
    * @date 20/12/2022
    * @fonction appelée depuis dev console  qui faira schedule automatique du batch135
    * @param void
    * @return void
    */
    global static String scheduleMe() 
    {
        SCHD15_lancerBatchRecalculDates SC = new  SCHD15_lancerBatchRecalculDates();
        return System.schedule('Recalculer_chantier_date', sched, SC);
    }
    
	/** 
    * @author Charbel Khoury Hanna  
    * @date 20/12/2022 
    * @fonction execute le scheduling du batch135
    * @param schedular du type SCHD15_lancerBatchRecalculDates
    * @return void
    */
    global void execute(SchedulableContext sc) 
    {    
        Batch135_RecalculDesDates myBatch= new Batch135_RecalculDesDates();
        ID batchprocessid = Database.executeBatch(myBatch);
    }
}