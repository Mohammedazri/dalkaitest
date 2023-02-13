/** 
* @author Jacques AKiki
* @date 11/06/2020 
* @description trigger before delete ContratContact
* @Test class: AP84_HandleDuplicates_test
*/
trigger ContratContactBeforeUpdate on ContratContact__c (before update) 
{
    // we do not want to bypass this class to handle duplicates
    AP84_HandleDuplicates.fillTechUniqueCont(trigger.new);
}