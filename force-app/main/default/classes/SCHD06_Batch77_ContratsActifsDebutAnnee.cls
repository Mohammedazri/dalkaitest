/** 
* @author Dona kfoury - Ei technologies
* @date 15/06/2020 
* @description schedular qui va lancer le batch Batch77_ContratsActifsDebutAnnee chaque début d'année 
* @Test Class SCHD06_test
*/
global class SCHD06_Batch77_ContratsActifsDebutAnnee implements Schedulable{
    public static String sched = '0 0 0 1 1 ? *';  //1 janvier de chaque année
    
    /** 
    * @author Dona Kfoury  
    * @date 15/06/2020
    * @fonction appelée depuis dev console  qui faira schedule automatique du batch77
    * @param void
    * @return void
    */
    global static String scheduleMe() 
    {
        SCHD06_Batch77_ContratsActifsDebutAnnee SC = new  SCHD06_Batch77_ContratsActifsDebutAnnee();
        return System.schedule('Contrats_Actifs_Debut_Année', sched, SC);
    }
    
	/** 
    * @author Dona Kfoury  
    * @date 15/06/2020
    * @fonction execute le scheduling du batch77
    * @param schedular du type SCHD06_Batch77_ContratsActifsDebutAnnee
    * @return void
    */
    global void execute(SchedulableContext sc) 
    {    
        Batch77_ContratsActifsDebutAnnee myBatch= new Batch77_ContratsActifsDebutAnnee();
        ID batchprocessid = Database.executeBatch(myBatch,Integer.valueOf(label.SCHD06_NumberOdRecords));
    }
}