/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: this batch is responsible of updating the old fields on the budget with the values of the new fields
Test Class: Batch11_OldValuesOnBudget_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch11_OldValuesOnBudget implements Database.Batchable<SObject>{
    List<Budget__c> listBudgets = new List<Budget__c>();
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String part = 'Select Id, CABudgetP1__c, CABudgetP2__c, CABudgetP3__c,CABudgetP4__c, CABudgetP6__c, MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c, BudgetNP1VentesServices__c, BudgetNP2VentesServices__c, BudgetNP3VentesServices__c, BudgetNP4VentesServices__c, BudgetNP6VentesServices__c, BudgetNP1MargeBrute__c, BudgetNP2MargeBrute__c, BudgetNP3MargeBrute__c, BudgetNP4MargeBrute__c, BudgetNP6MargeBrute__c  From Budget__c ';
        String Condition ='Where (BudgetNP1VentesServices__c<>NULL OR BudgetNP2VentesServices__c<>NULL OR BudgetNP3VentesServices__c<>NULL OR BudgetNP4VentesServices__c<>NULL OR BudgetNP6VentesServices__c<>NULL OR BudgetNP1MargeBrute__c<>NULL OR BudgetNP2MargeBrute__c<>NULL OR BudgetNP3MargeBrute__c<>NULL OR BudgetNP4MargeBrute__c<>NULL OR BudgetNP6MargeBrute__c<>NULL OR BudgetNP1VentesServices__c<>0 OR BudgetNP2VentesServices__c<>0 OR BudgetNP3VentesServices__c<>0 OR BudgetNP4VentesServices__c<>0 OR BudgetNP6VentesServices__c<>0 OR BudgetNP1MargeBrute__c<>0 OR BudgetNP2MargeBrute__c<>0 OR BudgetNP3MargeBrute__c<>0 OR BudgetNP4MargeBrute__c<>0 OR BudgetNP6MargeBrute__c<>0 )';
        //String cond2 = ' AND id=\'a0q25000001fKKjAAM\'';
        String query = part + Condition /*+ cond2*/;
        return Database.getQueryLocator(query);
    
        
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope){
       
        for(Budget__c Bdg : (Budget__c[]) scope){
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
       	  listBudgets.add(Bdg);
        
        }
         if(!listBudgets.isEmpty())   
        {  
            update listBudgets; 
        } 
    }
    global void finish(Database.BatchableContext BC){
        
        system.debug('list to be deleted size  :: '+listBudgets.size());
       
    }
}