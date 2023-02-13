/** 
* @author Jacques Akiki - Ei technologies
* @date 02/08/2022 
* @description schedular qui va MAJ les contrats fils perdus apres un renouvellement
* @Test Class AP38_OpportunityContratCadre_test
*/
global class SCHD13_updateContratsFilsPerdus implements Schedulable{
    public List<Contrat__c> ListCont;
    
    /** 
* @author Jacques Akiki  
* @date 02/08/2022
* @fonction appelée depuis AP38
* @param Cron expression pour le temps 
* @return void
*/
    global static String scheduleMe(String sched, List<Contrat__c> listContrat , String NameSCH) 
    {
        SCHD13_updateContratsFilsPerdus SC = new  SCHD13_updateContratsFilsPerdus();
        SC.ListCont = listContrat ;
        return System.schedule(NameSCH, sched, SC);
    }
    
    /** 
* @author Jacques Akiki  
* @date 04/04/2022
* @fonction faire un update
* @param
* @return void
*/
    global void execute(SchedulableContext sc) 
    {    
        update ListCont;
    }
}