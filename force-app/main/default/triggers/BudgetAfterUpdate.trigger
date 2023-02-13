/*--------------------------------------------------------------------------------------------------------------------------
Author:  Dona Kfoury
Company: EI-Technologies
Description: Apex trigger BudgetAfterUpdate
Test Class:  AP15_Budget_Test
History
<Date>      <Authors Name>      <Brief Description of Change>
26/06/2018   Johny Kassis      Commented AP15
30/08/2018	 Jacques Akiki	
12/09/2018	Jacques Akiki		Added Functionality of class AP31
--------------------------------------------------------------------------------------------------------------------------*/
trigger BudgetAfterUpdate on Budget__c (after update) {
    
    set<Id> SetAllContractIds= new set<Id>();
    Map<Id, Budget__c> MapidToOldBudgetWithDiffCAOrMb= new Map<Id, Budget__c>();
    Map<Id, Budget__c> MapidToNewBudgetWithDiffCAOrMb= new Map<Id, Budget__c>();
    
    for (Budget__c thisBudget : trigger.new)
    {
        Budget__c oldBudget=trigger.oldMap.get(thisBudget.Id);
        if(thisBudget.NomContrat__c != oldBudget.NomContrat__c
           || thisBudget.AnneeBudget__c != oldBudget.AnneeBudget__c)
        {
            SetAllContractIds.add(thisBudget.NomContrat__c);
            SetAllContractIds.add(oldBudget.NomContrat__c);
        }
        /** else if(thisBudget.CABudgetP1__c != oldBudget.CABudgetP1__c
|| thisBudget.CABudgetP2__c != oldBudget.CABudgetP2__c
|| thisBudget.CABudgetP3__c != oldBudget.CABudgetP3__c
|| thisBudget.CABudgetP4__c != oldBudget.CABudgetP4__c
|| thisBudget.CABudgetP6__c != oldBudget.CABudgetP6__c
|| thisBudget.MBBudgetP1__c != oldBudget.MBBudgetP1__c
|| thisBudget.MBBudgetP2__c != oldBudget.MBBudgetP2__c
|| thisBudget.MBBudgetP3__c != oldBudget.MBBudgetP3__c
|| thisBudget.MBBudgetP4__c != oldBudget.MBBudgetP4__c
|| thisBudget.MBBudgetP6__c != oldBudget.MBBudgetP6__c)
{
MapidToOldBudgetWithDiffCAOrMb.put(thisBudget.Id, oldBudget);
MapidToNewBudgetWithDiffCAOrMb.put(thisBudget.Id, thisBudget);
}*/
    }
    
    //setting the lookup field tech_Budget__c of opportunity 
    
    /* Change done on 30/08/2018 -- Start
if(PAD.CanTrigger('AP17_BudgetOnOpp'))*/
    
    if(PAD.CanTrigger('AP17_BudgetOnOpp')&& SetAllContractIds != null && SetAllContractIds.size()>0){
        AP17_BudgetOnOpp.UpdateBudgetOnOpportunityFromBudget(trigger.new);
    }
    /*-- End*/
    
    //when the year or the name of the budget change update the list of the related "Fiche_de_synthese__c"
    if(PAD.CanTrigger('AP15_Budget') && SetAllContractIds != null && SetAllContractIds.size()>0){
        AP15_Budget.UpdateBdgFDSAfterUpdateAnneeorContratBdg(SetAllContractIds);
    }
    
    
    // Responsable for filling budget fields ( TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c) from the most recent budget record 
    // of a contrat to the contrat itself (Contrat__c.TechTotalCABudgetP1P2P3P4__c
    if(PAD.CanTrigger('AP44_Budget'))
    {
        AP44_Budget.displayMostRecentOnCont(trigger.new,trigger.oldMap);
    }
    
    //after modifying the fields of the budgets that are used as refrence on the  Fiche_de_synthese__c. The related Fiche_de_synthese__c must be updated with the new values 
    /* if(PAD.CanTrigger('AP15_Budget') && MapidToNewBudgetWithDiffCAOrMb != null && MapidToNewBudgetWithDiffCAOrMb.keySet().size()>0)
AP15_Budget.UpdateBdgFDSAfterUpdateCABdg(MapidToOldBudgetWithDiffCAOrMb, MapidToNewBudgetWithDiffCAOrMb, true);*/
    if(PAD.CanTrigger('AP49_OpportunityUpdate'))
    {
        AP49_OpportunityUpdate.UpdateOpportunities(trigger.new);
    }
}