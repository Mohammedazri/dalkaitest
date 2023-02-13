/*--------------------------------------------------------------------------------------------------------------------------
Author:  Johny Kassis
Company: EI-Technologies
Description: Apex trigger ContratAfterUpdate
Test Class:  AP18_Contrat_test
History
<Date> 		<Authors Name> 		<Brief Description of Change>
31/07/2018   Johny Kassis        Created
--------------------------------------------------------------------------------------------------------------------------*/
trigger ContratBeforeUpdate on Contrat__c (before Update) {
    PAD.PAD_BypassTrigger+=';AP45_Account;';
    // when the field "Pilote du contrat" is modified , this function modifies the value of the OwnerID using the Modified Field
    if(PAD.CanTrigger('AP28_SetContratOwner')){
        AP28_SetContratOwner.UpdateOwner(trigger.new, trigger.oldmap);
    }
    /*for(Contrat__c cont : trigger.new)
{
system.debug('contrat cadre: '+ cont.ContratCadre__c+' '+cont.EstContratcadre__c);
}*/
    
    /*if(PAD.CanTrigger('AP62_ContratOldPilote'))
{
AP62_ContratOldPilote.updateOwner(Trigger.new,trigger.oldmap);
}*/
    if(PAD.CanTrigger('AP71_ModifierTechContrat'))
    {
        AP71_ModifierTechContrat.updateTechModifierContrat(Trigger.new,trigger.oldmap);
    }

    if(PAD.CanTrigger('AP99_ContratUOPilote'))
    {
        List<Contrat__c> AP99ListContrats = new List<Contrat__c>();
        for(Contrat__c cont : trigger.new){
            if(cont.Libelle_Agence__c != trigger.oldMap.get(cont.Id).Libelle_Agence__c){
                AP99ListContrats.add(cont);
            }
        }
        AP99_ContratUOPilote.updateUOPilote(AP99ListContrats);
    }
    
    if(PAD.CanTrigger('AP115_ContratDateProchEch'))
    {
        AP115_ContratDateProchEch.calculDateProchaineEcheance(trigger.new, trigger.oldmap);
    }
}