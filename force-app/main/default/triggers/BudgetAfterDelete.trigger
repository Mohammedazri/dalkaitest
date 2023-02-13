/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Apex trigger BudgetAfterDelete
Test Class:  AP17_BudgetOnOpp_test
History
<Date>      <Authors Name>      <Brief Description of Change>
12/09/2018	Jacques Akiki		Added Functionality of class AP31
--------------------------------------------------------------------------------------------------------------------------*/
trigger BudgetAfterDelete on Budget__c (After delete) 
{
    //setting the lookup field tech_Budget__c of opportunity 
    if(PAD.CanTrigger('AP17_BudgetOnOpp')){
        AP17_BudgetOnOpp.UpdateBudgetOnOpportunityFromBudget(trigger.old);
    }
    
    
    //update the lookup field(Budget__c) and the fields used as refrence of the "Fiche_de_synthese__c" records whenever a budget is deleted
    if(PAD.CanTrigger('AP15_Budget')){
        AP15_Budget.UpdateBdgFDSAfterDeleteBdg(trigger.old);
    }
    
    
    // Responsable for filling budget fields ( TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c) from the most recent budget record 
    // of a contrat to the contrat itself (Contrat__c.TechTotalCABudgetP1P2P3P4__c
    if(PAD.CanTrigger('AP44_Budget'))
    {
        AP44_Budget.displayMostRecentOnCont(trigger.old,null);
    }
}