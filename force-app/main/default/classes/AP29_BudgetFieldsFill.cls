/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: this class is responsible of setting putting the values of 10 fields in object Budget to the value of other fields.
Test Class: AP29_BudgetFieldsFill_test
--------------------------------------------------------------------------------------------------------------------------*/

public class AP29_BudgetFieldsFill {
    
    public static void FieldsValues(List<Budget__c> BudgetList , Map<id,Budget__c>oldMap )
    {
        for (Budget__c Bdg:BudgetList)
            {
                Bdg.CABudgetP1__c=Bdg.BudgetNP1VentesServices__c;
                Bdg.CABudgetP2__c=Bdg.BudgetNP2VentesServices__c;
                Bdg.CABudgetP3__c=Bdg.BudgetNP3VentesServices__c;
                Bdg.CABudgetP4__c=Bdg.BudgetNP4VentesServices__c;
                Bdg.CABudgetP6__c=Bdg.BudgetNP6VentesServices__c;
                Bdg.MBBudgetP1__c=Bdg.BudgetNP1MargeBrute__c;
                Bdg.MBBudgetP2__c=Bdg.BudgetNP2MargeBrute__c;
                Bdg.MBBudgetP3__c=Bdg.BudgetNP3MargeBrute__c;
                Bdg.MBBudgetP4__c=Bdg.BudgetNP4MargeBrute__c;
                Bdg.MBBudgetP6__c=Bdg.BudgetNP6MargeBrute__c;
            }
        
        
    }
    
}