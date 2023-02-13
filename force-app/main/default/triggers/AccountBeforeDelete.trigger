/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Apex trigger AccountBeforeDelete
Test Class:  AP19_LookUpContratAccount_Test
History
<Date> 		<Authors Name> 		<Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger AccountBeforeDelete on Account (Before delete) {
    //check if can delete account
    if(PAD.CanTrigger('AP79_Account')){
        AP79_Account.checkIfCanDeleteAccount(trigger.old);
    }
    //MAJ du champ AuMoinsUnContactEspaceClient__c sur contrat par true si le contrat possède au moins un contact relié ayant le champ "Contact Espace Client" est vrai
    if(PAD.CanTrigger('AP86_ContratContact')){
        AP86_ContratContact.accountDelete(trigger.old);
    }
    //commenté par dona 22/4/2020 parceque on a mis une nouvelle règle en place qui ne permet pas la supression d'un partenaire s'il a un contrat rattaché 
    // delete the contracts of an account when the account is deleted like the standard functionality of a master detail relationship 
    /*if(PAD.CanTrigger('AP19_LookUpContratAccount')){
        AP19_LookUpContratAccount.DeleteContrats(trigger.old);
    }*/
     
    //do not allow the removal of the parent account of the contact technique which should always exist for SDocs
    AP72_Contact.checkIfCanDeleteAccount(trigger.old);
}