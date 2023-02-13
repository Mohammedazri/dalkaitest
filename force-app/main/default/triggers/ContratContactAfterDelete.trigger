trigger ContratContactAfterDelete on ContratContact__c (after delete) {
    //MAJ du champ AuMoinsUnContactEspaceClient__c sur contrat par true si le contrat possède au moins un contact relié ayant le champ "Contact Espace Client" est vrai
    if(PAD.CanTrigger('AP86_ContratContact')){
        AP86_ContratContact.contactContratInsertDelete(trigger.old);
    }
}