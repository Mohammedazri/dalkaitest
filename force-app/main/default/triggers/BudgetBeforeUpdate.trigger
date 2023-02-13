/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: This Before Update trigger checks new  calls the class AP29_BudgetFieldsFill 
Test Class: AP29_BudgetFieldsFill_test
--------------------------------------------------------------------------------------------------------------------------*/

trigger BudgetBeforeUpdate on Budget__c (before update) {
    
    
    AP29_BudgetFieldsFill.FieldsValues(Trigger.new, Trigger.oldMap);
}