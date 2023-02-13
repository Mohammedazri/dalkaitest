/** 
* @author Dona Kfoury
* @date 18/2/2020 
* @description trigger after update agence 
* @Test class: AP75_Agence_Test
*/
trigger AgenceAfterUpdate on Agence__c (after update) {
    if(PAD.CanTrigger('AP75_Agence'))
    {
        AP75_Agence.getAgenceChanged(trigger.new, trigger.oldmap);    
    } 
}