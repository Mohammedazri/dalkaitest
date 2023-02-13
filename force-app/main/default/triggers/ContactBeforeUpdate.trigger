trigger ContactBeforeUpdate on Contact (before update) {
    //MAJ des 4 champs perferences
    if(PAD.CanTrigger('AP105_Contact')) {
        AP105_Contact.setContactMailPreferences(trigger.new, trigger.oldMap);
    }
    
    if(PAD.CanTrigger('AP114_Contact')) {
        
        List<Contact> ListAP114 = new List<Contact>();
        
        for(Contact cont : trigger.new)
        {
            if(trigger.oldMap.get(cont.Id).Statut__c != cont.Statut__c && cont.Statut__c == Label.AP114_ContratInactif)
            {
                ListAP114.add(cont);
            }
        }
        
        if(ListAP114.size() > 0)
        {
         	AP114_Contact.checkContactContratSize(ListAP114, trigger.newMap);
        }
    }
}