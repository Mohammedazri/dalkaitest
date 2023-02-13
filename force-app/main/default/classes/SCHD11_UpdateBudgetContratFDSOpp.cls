/** 
* @author Jacques Akiki - Ei technologies
* @date 17/03/2022 
* @description schedular qui va lancer les batch 122 et 123 pour remonter les budgets sur les contrats et les vides des opp et fds 
* @Test Class SCHD11_test
*/
global without sharing class SCHD11_UpdateBudgetContratFDSOpp implements Schedulable{
    public static String sched = '0 30 23 30 DEC ? 2022/1';  //30 decembre de chaque année à 11H30 du soir 
    
    /** 
    * @author Jacques Akiki  
    * @date 17/03/2022
    * @fonction appelée depuis dev console  qui faira schedule automatique du batch122
    * @param void
    * @return void
    */
    global static String scheduleMe() 
    {
        SCHD11_UpdateBudgetContratFDSOpp SC = new  SCHD11_UpdateBudgetContratFDSOpp();
        return System.schedule('Update_Budget_Contrat_FDS_Opp', sched, SC);
    }
    
	/** 
    * @author Jacques Akiki  
    * @date 17/03/2022
    * @fonction execute le scheduling du batch122
    * @param schedular du type SCHD11_UpdateBudgetContratFDSOpp
    * @return void
    */
    global void execute(SchedulableContext sc) 
    {    
        Batch122_UpdateBudgetContrat myBatch= new Batch122_UpdateBudgetContrat(true);
        ID batchprocessid = Database.executeBatch(myBatch,10);
    }
}