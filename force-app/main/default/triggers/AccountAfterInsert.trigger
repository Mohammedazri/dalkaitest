trigger AccountAfterInsert on Account (after insert) {
    
    list<account> AccountListCreatedFromLeads = new List<account>();
    for (Account a : trigger.new)
    {
        if (a.Created_From_Lead__c)
        {
            AccountListCreatedFromLeads.add(a);
            system.debug('##account' + a);
        }
    }
    
    if(PAD.CanTrigger('AP01_Account') && AccountListCreatedFromLeads.size()>0){
        AP01_Account.CallBaseSirene(AccountListCreatedFromLeads);
    }
    
    if(PAD.CanTrigger('AP02_Account')){
        AP02_Account.AjoutProprietaireEquipeCompte(Trigger.new);
    }
    If(!TriggerUtility.RunOnce){
        if(PAD.CanTrigger('AP45_Account')){
            AP45_AccountCallouts.handleList(trigger.new,'create');
            System.debug('AP45_Account');
            TriggerUtility.RunOnce = true;
        }
    }
}