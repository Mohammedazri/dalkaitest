/** 
* @author Jimmy Khalil - Ei technologies
* @date 08/09/2021 
* @description schedular qui va lancer le batch Batch119_ObjectifRegional pour relier les opp a l'obejectif convenable le soir 
* @Test Class 
*/
global class SCHD10_ObjectifRegional implements Schedulable{
    public Map<String,String> mapRegionAnneIdObj = new Map<String,String>();
    public Set<String> setRegion = new Set<String>();
    public Set<String> setAnnee = new Set<String>();    
    
    
    global void execute(SchedulableContext sc) 
    {    
        //system.debug('@@@ JK setRegion ' + setRegion);
        //system.debug('@@@ JK setAnnee ' + setAnnee);
        
        Batch119_ObjectifRegional myBatch= new Batch119_ObjectifRegional();
        myBatch.mapRegionAnneIdObj = mapRegionAnneIdObj;
        myBatch.setRegion = setRegion;
        myBatch.setAnnee = setAnnee;
        ID batchprocessid = Database.executeBatch(myBatch,200);
    }
}