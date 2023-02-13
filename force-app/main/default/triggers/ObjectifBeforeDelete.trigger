/*--------------------------------------------------------------------------------------------------------------------------
Company: EI-Technologies
Description: trigger on Objectif Before Update
Test Class: AP55_ObjectifAgence_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
25/04/2019	Rita Bejjani	 Creation
--------------------------------------------------------------------------------------------------------------------------*/

trigger ObjectifBeforeDelete on Objectif__c (before delete) {

    if(PAD.CanTrigger('AP55_ObjectifAgence'))
    {
        List<Objectif__c> lstAP55 = new List<Objectif__c>();
        String objRegionalRTId = Schema.getGlobalDescribe().get('Objectif__c').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.Objectif_regional).getRecordTypeId();
        for(Objectif__c obj : trigger.old)
        {
            if(obj.RecordTypeId != objRegionalRTId)
            {
                lstAP55.add(obj);
            }
        }
		if(lstAP55.size() > 0)
        {
     		AP55_ObjectifAgence.CallBatchObjAgc(lstAP55);       
        }
    }
}