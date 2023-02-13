/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: This Before Insert trigger calls the class AP29_BudgetFieldsFill 
Test Class: AP29_BudgetFieldsFill_test
--------------------------------------------------------------------------------------------------------------------------*/

trigger BudgetBeforeInsert on Budget__c (before insert){
    AP29_BudgetFieldsFill.FieldsValues(trigger.new , Trigger.oldMap);
}