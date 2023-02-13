/** 
* @author Jacques Akiki - Ei technologies
* @date 26/05/2021 
* @description schedular qui va lancer le batch Batch94_ContratsAgenceActifsDebutAnnee chaque début d'année 
* @Test Class SCHD08_test
*/
global class SCHD08_ActiviteContratDebutAnnee implements Schedulable{
    public static String sched = '0 0 5 * * ? *';  //5 am chaque Jour
    
    /** 
    * @author Jacques Akiki  
    * @date 26/05/2021
    * @fonction appelée depuis dev console  qui faira schedule automatique du batch112
    * @param void
    * @return void
    */
    global static String scheduleMe() 
    {
        SCHD08_ActiviteContratDebutAnnee SC = new  SCHD08_ActiviteContratDebutAnnee();
        return System.schedule('Activite_Contrat_Actifs', sched, SC);
    }
    
	/** 
    * @author Jacques Akiki  
    * @date 26/05/2021
    * @fonction execute le scheduling du batch112
    * @param schedular du type SCHD08_ActiviteContratDebutAnnee
    * @return void
    */
    global void execute(SchedulableContext sc) 
    {    
        Batch112_UpdateActiviteContrat myBatch= new Batch112_UpdateActiviteContrat();
        ID batchprocessid = Database.executeBatch(myBatch,200);
    }
}