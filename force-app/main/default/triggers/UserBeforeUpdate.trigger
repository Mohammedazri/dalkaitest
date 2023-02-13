trigger UserBeforeUpdate on User (before Update) {
    
    if(PAD.CanTrigger('AP09_User'))
    {
        List<User> UserList= new List<User>();
        for (User thisUser : trigger.new)
        {
            if((thisUser.Organisation__c != trigger.oldMap.get(thisUser.Id).Organisation__c))
            {
                UserList.add(thisUser);
            }
        }
        AP09_User.UpdateUserFields(UserList);
    }
    if(PAD.CanTrigger('AP73_User'))
    {
        AP73_User.fillUserSignature(trigger.new,trigger.oldMap);
    }
    
}