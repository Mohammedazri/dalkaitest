trigger ContactSatisfactionTrigger on Contact_Satisfaction__c (before insert , after insert) {
    
    if(trigger.isBefore)
    {
       if(PAD.canTrigger('AP97_ContactSatisfaction'))
       {
           AP97_ContactSatisfaction.updateName(trigger.new);
       } 
    }
    if(trigger.isAfter)
    {
        if(PAD.canTrigger('AP97_ContactSatisfaction'))
        {
            AP97_ContactSatisfaction.updateContact(trigger.new);
        }
    }
    
}