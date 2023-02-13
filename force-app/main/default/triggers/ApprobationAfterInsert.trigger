/**
* @author: Jacques Akiki -EI Technologies
* @date: 14/05/2019
* @description: Trigger on Approbation__c after Insert
* @Test Class: AP50_Approbation_test 
* @Coverage: 100% 
*/
trigger ApprobationAfterInsert on Approbation__c (after insert) {
    
    if(PAD.CanTrigger('AP50_Approbation'))
    {
        AP50_Approbation.approveFDS(trigger.new); 
    }
    
}