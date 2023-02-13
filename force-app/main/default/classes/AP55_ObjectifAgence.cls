/**
* @author: Rita Bejjani -EI Technologies
* @date: 24/04/2019
* @description: Pass Objectif ids
* @Test Class: AP55_ObjectifAgence_Test  
* @Coverage: 100%
*/
public class AP55_ObjectifAgence {
    
        /**
    * @author: Rita Bejjani -EI Technologies
    * @date: 24/04/2019
    * @description:  The method call a batch and pass a set of objectifAgenceId
    * @inputs: List<Objectif__c>
    * @returns: - 
    */   
    public static void UpdateObjAgence(List<Objectif__c> listNewObj, map<id, Objectif__c> mapOldObj)
    {
        set<id> setObjAgcID = new set<id>();
        for(Objectif__c thisObjectif : listNewObj)
        {
            Objectif__c oldObjectif = mapOldObj.get(thisObjectif.Id);
            if((thisObjectif.Annee__c != oldObjectif.Annee__c || thisObjectif.Commercial__c != oldObjectif.Commercial__c || thisObjectif.ObjectifAgenceId__c != oldObjectif.ObjectifAgenceId__c
               || thisObjectif.ObjectifsenCA__c != oldObjectif.ObjectifsenCA__c || thisObjectif.ObjectifsenMB__c != oldObjectif.ObjectifsenMB__c
               || thisObjectif.SignaturesenCA__c != oldObjectif.SignaturesenCA__c || thisObjectif.SignaturesenMB__c != oldObjectif.SignaturesenMB__c
               || thisObjectif.P6enCA__c != oldObjectif.P6enCA__c || thisObjectif.P6enMB__c != oldObjectif.P6enMB__c)
                && thisObjectif.ObjectifAgenceId__c != null)
            {
                setObjAgcID.add(thisObjectif.ObjectifAgenceId__c); 
                setObjAgcID.add(oldObjectif.ObjectifAgenceId__c); 
            }
            
        }
        if(setObjAgcID.size()!=0){
            Id batchJobId  = Database.executeBatch(new Batch43_UpdateObjAgc(setObjAgcID));
        }
    }
    
    
    /**
    * @author: Rita Bejjani -EI Technologies
    * @date: 24/04/2019
    * @description:  The method call a batch and pass a set of objectifAgenceId
    * @inputs: List<Objectif__c>
    * @returns: - 
    */   
    public static void CallBatchObjAgc(List<Objectif__c> listObj)
    {
        set<id> setObjAgcID = new set<id>();
        for(Objectif__c obj : listObj)
        {
            if(obj.ObjectifAgenceId__c != null)
            {
                setObjAgcID.add(obj.ObjectifAgenceId__c); 
            }
            
        }
        if(setObjAgcID.size()!=0){
            Id batchJobId  = Database.executeBatch(new Batch43_UpdateObjAgc(setObjAgcID));
        }
    }
}