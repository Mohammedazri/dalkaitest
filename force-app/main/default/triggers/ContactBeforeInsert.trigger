trigger ContactBeforeInsert on Contact (before insert) {
//MAJ des 4 champs perferences
    if(PAD.CanTrigger('AP105_Contact')) {
        AP105_Contact.setContactMailPreferences(trigger.new, null);
    }
}