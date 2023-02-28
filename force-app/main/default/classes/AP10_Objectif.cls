/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description:  Class Responsible of creating Objectif__share and deleting the old ones when an objectif is inserted or when the
lookup field Commercial__c on Objectif__c is modified 
Test Class: AP10_Objectif_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class AP10_Objectif {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: The following function delete the Objectif__share related to the old Objectif__c and insert new ones
Inputs: List of new Objectif and list of old Objectif
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/   
    public static void manualShareObjectifRead(List<Objectif__c> NewListObjectifsToShare, List<Objectif__c> OldListObjectifsToShare){
        
        if(OldListObjectifsToShare!= null && OldListObjectifsToShare.size()>0)
        {
            Set<Id> SetOldObjId= new Set<Id>();
            for(Objectif__c thisObj: OldListObjectifsToShare)
            {
                SetOldObjId.add(thisObj.Id);
            }
            List<Objectif__share> ListObjectifTodeleteShare=[SELECT Id 
                                                             FROM Objectif__share 
                                                             WHERE ParentId IN :SetOldObjId AND RowCause = 'Manual'];
            
            if(!ListObjectifTodeleteShare.isEmpty()){
                Database.Delete(ListObjectifTodeleteShare, false);
            }
        }
        Set<Id> SetCommercialId= new Set<Id>();
        for(Objectif__c thisObj: NewListObjectifsToShare)
        {
            SetCommercialId.add(thisObj.Commercial__c);
        }
        List<Objectif__share> ListObjectifShareObj= new  List<Objectif__share>();
        for(Objectif__c thisObj: NewListObjectifsToShare)
        {
            if(thisObj.OwnerId<>thisObj.commercial__c)
            {
                Objectif__share objShr  = new Objectif__share();
                objShr.ParentId=thisObj.Id;
                objShr.UserOrGroupId=thisObj.Commercial__c;
                objShr.AccessLevel = 'Read';
                objShr.RowCause = Schema.Objectif__share.RowCause.Manual;
                ListObjectifShareObj.add(objShr);
            }
        }
        
        system.debug('##ListObjectifShareObj ' + ListObjectifShareObj);
        if(ListObjectifShareObj!= null && ListObjectifShareObj.size()>0)
        {
            Database.SaveResult[] sr = Database.insert(ListObjectifShareObj,false);
        }
    }
/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Description: The following function aligns the owner of the Objectif with the manager de l'Objectif
Inputs: List of new Objectif and map of old Objectif
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/  
public static void copyManagertoOwner(List<Objectif__c> listObjectifs, map<id,Objectif__c> mapObjectif){
    Id RT_regional = Schema.SObjectType.Objectif__c.getRecordTypeInfosByDeveloperName().get('Objectif_regional').getRecordTypeId();
    for(Objectif__c obj:listObjectifs){
        if(obj.RecordTypeId!=RT_regional){
            if(mapObjectif?.get(obj.id).ManagerDeObjectif__c!=obj.ManagerDeObjectif__c){
                obj.OwnerId = obj.ManagerDeObjectif__c;
            }
        }
    }
}
}