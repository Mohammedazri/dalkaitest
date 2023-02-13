/*--------------------------------------------------------------------------------------------------------------------------
@Author: Chadi Geara  
@Company: EI-Technologies
@Description: This Batch updates old records of contrats where the fields 
TechTotalCABudgetP1P2P3P4__c TechTotalMBBudgetP1P2P3P4__c are not filled yet from the most recent related budget to the current contrat
Test Class: Batch30_UpdateTotalBudgetOnContrat_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
21/01/2019   Chadi Geara      Creation
--------------------------------------------------------------------------------------------------------------------------*/

global class Batch33_UpdateBudgetOnContrat implements Database.Batchable<sObject>, Database.Stateful{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query ='SELECT id, ( Select id , name, TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c,AnneeBudget__c,NomContrat__c from Budgets__r ) from Contrat__c ' ;
            query+=' WHERE TechTotalCABudgetP1P2P3P4__c = null and TechTotalMBBudgetP1P2P3P4__c = null  ';
        
        return Database.getQueryLocator(query);
        
    }
    
    
    global void execute(Database.BatchableContext BC, List<Contrat__c> lstContrats ){
        
        List<Budget__c> lstBudgetToContrats = new  List<Budget__c>();
        
        for(  Contrat__c cont : lstContrats ){
            if( cont.Budgets__r.size()>0){
                
                Budget__c recentBudget = null; 
                
                for( Budget__c currentBdg : cont.Budgets__r ){
                    if( recentBudget == null){
                        recentBudget = currentBdg;
                    }else if ( currentBdg.AnneeBudget__c > recentBudget.AnneeBudget__c) {
                        recentBudget = currentBdg;
                        
                    }
                }
                lstBudgetToContrats.add(RecentBudget);
                
            }
        }
        
        List <Contrat__c> lstContratUpdate = new List<Contrat__c>();
        
        for ( Budget__c bgt : lstBudgetToContrats){
            Contrat__c contratToUpdate= new Contrat__c();
            contratToUpdate.Id = bgt.NomContrat__c;
            contratToUpdate.TechTotalCABudgetP1P2P3P4__c = bgt.TotalCABudgetP1P2P3P4__c;
            contratToUpdate.TechTotalMBBudgetP1P2P3P4__c = bgt.TotalMBBudgetP1P2P3P4__c;
            lstContratUpdate.add(contratToUpdate);
            
        }
        
        update lstContratUpdate;
        
    }
    
        global void finish(Database.BatchableContext BC) {}

}