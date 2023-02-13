/** 
* @author Dona Kfoury
* @date 18/2/2020 
* @description trigger after update siège 
* @Test class: AP75_Agence_Test
*/
trigger SiegeAfterUpdate on Siege__c (after update) {
 if(PAD.CanTrigger('AP75_Agence'))
    {
        AP75_Agence.getSiegeChanged(trigger.new, trigger.oldmap);    
    }
}