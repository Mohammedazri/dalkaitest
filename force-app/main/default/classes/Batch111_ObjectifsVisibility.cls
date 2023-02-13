/** 
* @author Jacques Akiki - Ei technologies
* @date 06/04/2021 
* @description  Batch That gives Commercial access to their objectifs
* @Test Class Batch111_ObjectifsVisibility_test 96%
*/
global class Batch111_ObjectifsVisibility implements Database.Batchable<SObject>
{

    global String annee='';
     global Batch111_ObjectifsVisibility(string annee_Input) 
    {
        if(annee_Input<>'' && annee_Input<>null)
        {
            annee = annee_Input;
        }
    }
    /** 
* @author Jacques AKiki 
* @date 06/04/2021
* @ Query the Objectif
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id,commercial__c,OwnerId, commercial__r.isActive from Objectif__c';
        if (annee!='' && annee!=NULL)
        {
            query= query + ' WHERE Annee__c=:annee';
        }
        return Database.getQueryLocator(query); 
    }
    /** 
* @author Jacques AKiki 
* @date 06/04/2021
* @ Check if no access is given give access to commercials.
* @List of queried objectifs
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Objectif__c> listObj)
    {
        set <id> setObjId = new set<id>();
        set <id> setObjShared = new set<id>();
        List<Objectif__share> ListObjectifShareObj= new  List<Objectif__share>();
        for(Objectif__c thisObj: listObj)
        {
            setObjId.add(thisObj.id);
        }
        
        List<Objectif__Share> listObjSh = [SELECT id, parentId , parent.commercial__c , userOrGroupId ,parent.commercial__r.isActive
                                           FROM Objectif__Share 
                                           WHERE RowCause ='Manual' AND parentId in:setObjId];
        if (listObjSh<>NULL && listObjSh.size()>0)
        {
            for (Objectif__Share objSh:listObjSh)
            {
                if (objSh.parent.commercial__c == objSh.userOrGroupId)
                {
                   setObjShared.add(objSh.parentId); 
                }
            }
        }
        for (Objectif__c obj : listObj)
        {
            if (!setObjShared.contains(obj.id))
            {
                if(obj.OwnerId<>obj.commercial__c && obj.commercial__r.isActive)
                {
                    Objectif__share objShr  = new Objectif__share();
                    objShr.ParentId=obj.Id;
                    objShr.UserOrGroupId=obj.Commercial__c;
                    objShr.AccessLevel = 'Read';
                    objShr.RowCause = Schema.Objectif__share.RowCause.Manual;
                    ListObjectifShareObj.add(objShr);
                }
            }
        }
         if(ListObjectifShareObj!= null && ListObjectifShareObj.size()>0)
        {
            insert ListObjectifShareObj;
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}