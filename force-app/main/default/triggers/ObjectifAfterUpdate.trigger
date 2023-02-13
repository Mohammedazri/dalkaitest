trigger ObjectifAfterUpdate on Objectif__c (after update) {
    
    List<Objectif__c> NewListObjectifToshare= new List<Objectif__c>();
    List<Objectif__c> OldListObjectifToshare= new List<Objectif__c>();
            String objRegionalRTId = Schema.getGlobalDescribe().get('Objectif__c').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.Objectif_regional).getRecordTypeId();

    for (Objectif__c thisobjectif : trigger.new)
    {
        Objectif__c oldobjectif = trigger.oldMap.get(thisobjectif.Id);
        if(thisobjectif.Commercial__c != oldobjectif.Commercial__c || thisobjectif.OwnerId != oldobjectif.OwnerId )
        {
            NewListObjectifToshare.add(thisobjectif);
            OldListObjectifToshare.add(oldobjectif);
        }
    }
    if(NewListObjectifToshare.size()>=1)
    {
        // we do not wish to bypass this class
        AP10_Objectif.manualShareObjectifRead(NewListObjectifToshare, OldListObjectifToshare);
    }
    

    
    if(PAD.CanTrigger('AP06_Objectif')){
        List<Objectif__c> lstAP06 = new List<Objectif__c>();
        for(Objectif__c obj : trigger.new)
        {
            if(obj.RecordTypeId != objRegionalRTId)
            {
                lstAP06.add(obj);
            }
        }
		if(lstAP06.size() > 0)
        {
        	AP06_Objectif.UpdateObjectifUpdate(lstAP06, trigger.oldMap);
        }
    }
    
    //ajoutée par Rita Bejjani 
    if(PAD.CanTrigger('AP55_ObjectifAgence')){
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
        	AP55_ObjectifAgence.UpdateObjAgence(lstAP55, trigger.oldMap);
        }
    }
    
    /*System.debug('@@@ JK Limits ObjectifAfterUpdate');
    System.debug(Limits.getQueries());
    System.debug(Limits.getLimitQueries());
    System.debug(Limits.getQueryRows());
    System.debug(Limits.getLimitQueryRows());
    System.debug(Limits.getCpuTime());
    System.debug(Limits.getLimitCpuTime());
    System.debug(Limits.getDmlRows());
    System.debug(Limits.getLimitDmlRows());*/
    
    
}