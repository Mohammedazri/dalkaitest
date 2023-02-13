/** 
* @author Dona kfoury - Ei technologies
* @date 08/09/2020 
* @description schedular qui va lancer le batch Batch94_ContratsAgenceActifsDebutAnnee chaque début d'année 
* @Test Class SCHD07_test
*/
global class SCHD07_Batch94_ContratsAgenceDebutAnnee implements Schedulable{
    public static String sched = '0 30 0 1 1 ? *';  //1 janvier de chaque année
    
    /** 
    * @author Dona Kfoury  
    * @date 08/09/2020 
    * @fonction appelée depuis dev console  qui faira schedule automatique du batch94
    * @param void
    * @return void
    */
    global static String scheduleMe() 
    {
        SCHD07_Batch94_ContratsAgenceDebutAnnee SC = new  SCHD07_Batch94_ContratsAgenceDebutAnnee();
        return System.schedule('Agence_Contrats_Actifs_Debut_Année', sched, SC);
    }
    
	/** 
    * @author Dona Kfoury  
    * @date 08/09/2020 
    * @fonction execute le scheduling du batch94
    * @param schedular du type SCHD07_Batch94_ContratsAgenceDebutAnnee
    * @return void
    */
    global void execute(SchedulableContext sc) 
    {    
        Batch94_ContratsAgenceActifsDebutAnnee myBatch= new Batch94_ContratsAgenceActifsDebutAnnee();
        ID batchprocessid = Database.executeBatch(myBatch,Integer.valueOf(label.SCHD07_NumberOdRecords));
    }
}