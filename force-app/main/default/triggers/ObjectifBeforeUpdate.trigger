/*--------------------------------------------------------------------------------------------------------------------------
Company: EI-Technologies
Description: trigger on Objectif Before Update
Test Class: AP36_UperCase_test
History
<Date>      <Authors Name>   <Brief Description of Change>
11/10/2018	Jacques Akiki	Creation
24/04/2018  Rita Bejjani    Add AP54_UpdateObjectif
--------------------------------------------------------------------------------------------------------------------------*/

trigger ObjectifBeforeUpdate on Objectif__c (before update) {

    AP10_Objectif.copyManagertoOwner(Trigger.new, Trigger.oldmap);
   
    if(PAD.CanTrigger('AP54_UpdateObjectif') ) 
    {
        List<Objectif__c> lstAP54 = new List<Objectif__c>();
        String objRegionalRTId = Schema.getGlobalDescribe().get('Objectif__c').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.Objectif_regional).getRecordTypeId();
        for(Objectif__c obj : trigger.new)
        {
            if(obj.RecordTypeId != objRegionalRTId)
            {
                lstAP54.add(obj);
            }
        }
		if(lstAP54.size() > 0)
        {
        	AP54_UpdateObjectif.AddObjAgcID(lstAP54,trigger.oldMap);
        }
    }
}