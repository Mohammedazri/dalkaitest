/*--------------------------------------------------------------------------------------------------------------------------
Author:  Dona Kfoury
Company: EI-Technologies
Description: Apex trigger BudgetBeforeDelete
Test Class:  AP15_Budget_Test
History
<Date>      <Authors Name>      <Brief Description of Change>
26/06/2018   Johny Kassis      Commented AP15
--------------------------------------------------------------------------------------------------------------------------*/
trigger BudgetBeforeDelete on Budget__c (before delete) {
    
    //cal method to check if parent contract is closed
    if(PAD.CanTrigger('AP77_ContratFerme')){
        AP77_ContratFerme.checkIfCanDeleteBudgets(Trigger.oldmap);
    }
}