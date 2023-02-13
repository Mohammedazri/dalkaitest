/** 
* @author Jacques Akiki - Ei technologies
* @date 02/03/2020 
* @description Batch that gives visibility according to the user hierarchy 
* @Test Class Batch67_ShareObjectif_test
*/
global class Batch67_ShareObjectif implements Database.Batchable<SObject>
{
/** 
* @author Jacques AKiki 
* @date 02/03/2020 
* @ Query the Objectif
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id,commercial__c,OwnerId from Objectif__c';
        return Database.getQueryLocator(query); 
    }
    /** 
* @author Jacques AKiki 
* @date 25/03/2020 
* @Delete for old Objectif share and create new ones
* @List of queried objectifs
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Objectif__c> listObj)
    {
        set<id> setCommercialId = new set<id>();
        set <id> setObjId = new set<id>();
        for(Objectif__c thisObj: listObj)
        {
            SetCommercialId.add(thisObj.Commercial__c);
            setObjId.add(thisObj.id);
        }
        
        List<Objectif__Share> listObjSh = [SELECT id, parentId 
                                           FROM Objectif__Share 
                                           WHERE RowCause ='Manual' AND parentId in:setObjId 
                                           AND UserOrGroupId in (SELECT id
                                                                 FROM User
                                                                 WHERE ( ManagerId in: setCommercialId 
                                                                        or Manager.ManagerId in: setCommercialId 
                                                                        or Manager.Manager.ManagerId in: setCommercialId
                                                                        or Manager.Manager.Manager.ManagerId in: setCommercialId) AND isActive = true)];
        if (listObjSh<>NULL && listObjSh.size()>0)
        {
            delete listObjSh;
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}