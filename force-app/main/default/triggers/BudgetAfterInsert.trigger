/*--------------------------------------------------------------------------------------------------------------------------
Author:  Dona Kfoury
Company: EI-Technologies
Description: Apex trigger BudgetAfterInsert
Test Class:  AP15_Budget_Test
History
<Date>      <Authors Name>      <Brief Description of Change>  
12/09/2018	Jacques Akiki		Added Functionality of class AP31
--------------------------------------------------------------------------------------------------------------------------*/
trigger BudgetAfterInsert on Budget__c (after insert) {
    
    
    //setting the lookup field tech_Budget__c of opportunity 
    if(PAD.CanTrigger('AP17_BudgetOnOpp')){
        AP17_BudgetOnOpp.UpdateBudgetOnOpportunityFromBudget(trigger.new);
    }
    
    //finds the list of "Fiche_de_synthese__c" that has the same contract and updates the fields used as reference and the lookup field Budget__c of the list
    if(PAD.CanTrigger('AP15_Budget')){
        AP15_Budget.UpdateBdgFDSAfterInsertBdg(trigger.new);
    }
    
    
    
    // Responsable for filling budget fields ( TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c) from the most recent budget record 
    // of a contrat to the contrat itself (Contrat__c.TechTotalCABudgetP1P2P3P4__c and Contrat__c.TechTotalMBBudgetP1P2P3P4__c.)
    if(PAD.CanTrigger('AP44_Budget'))
    {
        //AP44_Budget.displayMostRecentOnCont(trigger.new,null);
    }
    if(PAD.CanTrigger('AP49_OpportunityUpdate'))
    {
        AP49_OpportunityUpdate.UpdateOpportunities(trigger.new);
    }
}