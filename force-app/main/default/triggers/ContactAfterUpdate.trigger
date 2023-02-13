trigger ContactAfterUpdate on Contact (after update) {

    //MAJ du champ AuMoinsUnContactEspaceClient__c sur contrat par true si le contrat possède au moins un contact relié ayant le champ "Contact Espace Client" est vrai
    if(PAD.CanTrigger('AP86_ContratContact')) {
        AP86_ContratContact.contactUpdate(trigger.new, trigger.oldmap);
    }

    //17-5-2022 Modified By Jimmy to avoid AvoidSoqlInLoops
    if(PAD.CanTrigger('AP13_Contact')) {
        AP13_Contact.ModificationRelationContactUser(trigger.new, trigger.oldMap);
    }

}