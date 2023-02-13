trigger ContratBeforeDelete on Contrat__c (before delete) {
	if(PAD.CanTrigger('AP78_CannotDeleteContrat'))
    {
        AP78_CannotDeleteContrat.noDeleteContrat(trigger.old);
    }
}