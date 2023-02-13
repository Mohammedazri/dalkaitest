/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Apex trigger AccountAfterUpdate
Test Class: AP02_Account_TEST 
History
<Date>      <Authors Name>      <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger AccountAfterUpdate on Account (After Update) {
    
    //MAJ du champ AuMoinsUnContactEspaceClient__c sur contrat par true si le contrat possède au moins un contact relié ayant le champ "Contact Espace Client" est vrai
    if(PAD.CanTrigger('AP86_ContratContact')){
        AP86_ContratContact.PersonAccountUpdate(trigger.new, trigger.oldmap);
    }
    
    //add the Account Owner to the account team members
    if(PAD.CanTrigger('AP02_Account')){
        AP02_Account.AjoutProprietaireEquipeCompte(trigger.new);
    }
    if(!TriggerUtility.RunOnce) 
    {
        System.debug('PAD before ' + PAD.PAD_BypassTrigger);
        if(PAD.CanTrigger('AP45_Account')){
            AP45_AccountCallouts.handleList(trigger.new,'update');
            AP47_ModifierAdresse.handleList(trigger.new,'update');
        }
        TriggerUtility.RunOnce = true;
    }
    if(PAD.CanTrigger('AP74_Account'))
    {
        if(!Validation_Account.hasDoneOnce())
        {
            Validation_Account.setDoneOnce();
            AP74_Account.updateSocietePart(trigger.new, trigger.oldMap);
        }
    }
}