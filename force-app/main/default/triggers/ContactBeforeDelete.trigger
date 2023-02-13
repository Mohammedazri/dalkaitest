/** 
* @author Dona Kfoury
* @date 15/1/2020 
* @description trigger before delete on contact object 
*/
trigger ContactBeforeDelete on Contact (before delete) {
    //do not allow the removal of the contact technique which should always exist for SDocs
	AP72_Contact.checkIfCanDeleteContact(trigger.Old);
    
    
    //MAJ du champ AuMoinsUnContactEspaceClient__c sur contrat par true si le contrat possède au moins un contact relié ayant le champ "Contact Espace Client" est vrai
    if(PAD.CanTrigger('AP86_ContratContact')){
        AP86_ContratContact.contactDelete(trigger.old);
    }

    if(PAD.CanTrigger('AP107_DeleteContact')){
        AP107_DeleteContact.canDeleteContact(trigger.old);
    }
    
    if(PAD.CanTrigger('AP114_Contact')){
        AP114_Contact.checkContactContratSize(trigger.old, trigger.oldMap);
    }
}