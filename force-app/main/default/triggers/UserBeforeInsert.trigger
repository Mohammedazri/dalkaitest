trigger UserBeforeInsert on User (before insert) {
    
    if(PAD.CanTrigger('AP09_User'))
    {
        AP09_User.UpdateUserFields(trigger.new);    
    } 
    
    if(PAD.CanTrigger('AP73_User'))
    {
        AP73_User.fillUserSignature(trigger.new,null);
    }
    
}