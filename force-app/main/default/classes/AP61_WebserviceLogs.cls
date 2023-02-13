/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 01/07/2019
* @description: Class to handle the logs being inserted and filter them accordingly
* @Test Class:AP61_WebserviceLogs_test 
* @Coverage: 100%
*/
public class AP61_WebserviceLogs {
    /**
* @author: Alain Ghoussoub -EI Technologies
* @date: 01/07/2019
* @description: Method that filters out the failed ws calls and inserts them in another object where a batch will call them again.
* @inputs: List<WebserviceLog__c>
* @Outputs: -
*/
    public static void handleList(List<WebserviceLog__c> wsList)
    {
        List<TechBatchRelaunch__c> tbrList = new List<TechBatchRelaunch__c>();
        
        Set<String> setObjectIds = new Set<String>();
        Set<String> setType = new Set<String>();
        Map<String,WebserviceLog__c> keyWS = new Map<String,WebserviceLog__c>();
        for(WebserviceLog__c ws : wsList){
            if(ws.Flux__c == 'sortant'){
                if(String.isNotBlank(ws.Request__c) && ws.CodeRetour__c!=null && ws.CodeRetour__c=='ERROR' && String.isNotBlank(ws.Objectid__c) && String.isNotBlank(ws.Type__c)){
                    setObjectIds.add(ws.Objectid__c.subString(0,15));
                    setType.add(ws.Type__c);
                    keyWS.put(ws.Objectid__c.subString(0,15) + ws.Type__c,ws);
                }
            }
        }
        system.debug('setObjectIds ' + setObjectIds);
        system.debug('setType ' + setType);
        List<TechBatchRelaunch__c> tbr = new List<TechBatchRelaunch__c>();
        try{
            tbr = [SELECT id,Objectid__c,CreatedDate,Status__c,Limit__c,Type__c
                   FROM TechBatchRelaunch__c 
                   WHERE Objectid__c in :setObjectIds
                   AND Type__c in :setType
                   AND Status__c !='OK'];
        }
        Catch(Exception e){
            system.debug('No Tech batch relaunch');
        }
        
        system.debug('keyWS ' + keyWS);
        if(tbr != null && tbr.size()>0){
            for(TechBatchRelaunch__c tbrLoop : tbr){
                if(tbrLoop.Objectid__c != null && keyWs.containsKey(tbrLoop.Objectid__c.subString(0,15) + tbrLoop.Type__c) && keyWS.get(tbrLoop.Objectid__c.subString(0,15) + tbrLoop.Type__c) != null){
                    TechBatchRelaunch__c tbrToUpdate = new TechBatchRelaunch__c();
                    WebserviceLog__c ws = keyWS.get(tbrLoop.Objectid__c.subString(0,15) + tbrLoop.Type__c);
                    tbrToUpdate.id = tbrLoop.id;
                    tbrToUpdate.Request__c = ws.Request__c;
                    tbrToUpdate.Objectid__c = ws.Objectid__c.subString(0,15);
                    tbrToUpdate.Type__c = ws.Type__c;
                    tbrToUpdate.Limit__c = 0;
                    tbrList.add(tbrToUpdate);
                    keyWS.remove(tbrLoop.Objectid__c.subString(0,15) + tbrLoop.Type__c);
                }
            }
        }
        
        for(String tbrLoop : keyWS.KeySet()){
            WebserviceLog__c ws = keyWS.get(tbrLoop);
            TechBatchRelaunch__c tbrToInsert = new TechBatchRelaunch__c();
            tbrToInsert.Request__c = ws.Request__c;
            tbrToInsert.Objectid__c = ws.Objectid__c.subString(0,15);
            tbrToInsert.Type__c = ws.Type__c;
            tbrToInsert.Limit__c = 0;
            tbrList.add(tbrToInsert);
        }
        
        if(tbrList != null && tbrList.size()>0){
            upsert tbrList;
        }
    }
}