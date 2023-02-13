/** 
* @author Dona Kfoury
* @date 18/2/2020 
* @description trigger after update region 
* @Test class: AP75_Agence_Test
*/
trigger RegionAfterUpdate on Region__c (after update) {
    if(PAD.CanTrigger('AP75_Agence'))
    {
        AP75_Agence.getRegionChanged(trigger.new, trigger.oldmap);    
    } 

}