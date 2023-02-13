trigger ObjectifAfterInsert on Objectif__c (after insert) {
    
    AP10_Objectif.manualShareObjectifRead(trigger.new, null);
    String objRegionalRTId = Schema.getGlobalDescribe().get('Objectif__c').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.Objectif_regional).getRecordTypeId();
    
    //ajoouté par Rita Bejjani
    if(PAD.CanTrigger('AP55_ObjectifAgence'))
    {
        List<Objectif__c> lstAP55 = new List<Objectif__c>();
        for(Objectif__c obj : trigger.new)
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
    
    if(PAD.CanTrigger('AP06_Objectif') || PAD.CanTrigger('AP102_Objectif'))
    {
        List<Objectif__c> lstAP06 = new List<Objectif__c>();
        List<Objectif__c> lstAP102 = new List<Objectif__c>();
        for(Objectif__c obj : trigger.new)
        {
            if(obj.RecordTypeId != objRegionalRTId)
            {
                lstAP06.add(obj);
            }else{
                lstAP102.add(obj);
            }
        }
        if(PAD.CanTrigger('AP06_Objectif') && lstAP06.size() > 0)
        {
            AP06_Objectif.UpdateObjectifInsert(lstAP06);   
        }
        if(PAD.CanTrigger('AP102_Objectif') && lstAP102.size() > 0)
        {
            AP102_Objectif.callSchedulerRegional(lstAP102);   
        }
    }
    
    /* System.debug('@@@ JK Limits ObjectifAfterInsert');
System.debug(Limits.getQueries());
System.debug(Limits.getLimitQueries());
System.debug(Limits.getQueryRows());
System.debug(Limits.getLimitQueryRows());
System.debug(Limits.getCpuTime());
System.debug(Limits.getLimitCpuTime());
System.debug(Limits.getDmlRows());
System.debug(Limits.getLimitDmlRows());*/
}