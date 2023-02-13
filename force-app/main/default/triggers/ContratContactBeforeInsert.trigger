/** 
* @author Jacques AKiki
* @date 11/06/2020 
* @description trigger before delete ContratContact
* @Test class: AP84_HandleDuplicates_test
*/
trigger ContratContactBeforeInsert on ContratContact__c (before insert) 
{
    // we do not want to bypass this class to handle duplicates
    AP84_HandleDuplicates.fillTechUniqueCont(trigger.new);
}