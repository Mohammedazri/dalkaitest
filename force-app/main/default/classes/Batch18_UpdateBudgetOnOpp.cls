/*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran 
Company: EI-Technologies
Description: batch used to responsible of applying the functionality of the AP17_BudgetOnOpp which is responsible for setting the lookup field tech_Budget__c of opportunity  
Test Class: Batch18_UpdateBudgetOnOpp_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
11/10/2018   Hussein Farran      Creation
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch18_UpdateBudgetOnOpp implements Database.Batchable<sObject>{
    Set<Id> setIds = new Set<Id>();
    global Batch18_UpdateBudgetOnOpp (Set<Id> setIds){
        this.setIds = setIds;
    }
    global Batch18_UpdateBudgetOnOpp (){
        
    }
    global Database.QueryLocator start(Database.BatchableContext bc){

        String query ='SELECT id,name,ContratOrigine__c,Annee_de_signature__c,tech_Budget__c from Opportunity where ContratOrigine__c!=null and (type_pers__c =\''+Label.PV_Renouvellement+'\' or '+
            +'type_pers__c =\''+Label.PV_Evolution+'\') and (Record_type__c  =\''+Label.OppType_EvRen+'\' or Record_type__c  =\''+Label.OppType_EvRenEXP+'\' or Record_type__c  =\''+Label.OppType_appro+'\')';
        if(setIds!=null && setIds.size()>0){
            query = query + ' and id in :setIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> OpportunityList)
    {
        System.debug('##OpportunityList '+ OpportunityList);
        
        set<Id> SetContratIds= new set<Id>();
        set<Id> SetOpportunityIds= new set<Id>();
        
        for(opportunity thisOpp: OpportunityList)
        {
            if(thisOpp.ContratOrigine__c!=null){
                SetContratIds.add(thisOpp.ContratOrigine__c);
            }
            SetOpportunityIds.add(thisOpp.Id);
        }
        System.debug('##SetContratIds '+ SetContratIds);
        //query all the budgets that has the same contract as the opportunities
        List<Budget__c> ListBudgets=new List<Budget__c>([SELECT id, AnneeBudget__c, NomContrat__c,
                                                         CABudgetP1__c, CABudgetP2__c, CABudgetP3__c, CABudgetP4__c, CABudgetP6__c,
                                                         MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c
                                                         FROM Budget__c 
                                                         where NomContrat__c in: SetContratIds]);
        
        List<Opportunity> lstOppToUpdate= new List< Opportunity> ();
        Map<Opportunity, List<Budget__c>> MapOppToBudgets= new Map<Opportunity, List<Budget__c>>();        
        
        //fill a map with the Opportunity and the list of the related budgets based on the contract
        for(Budget__c theBudget : ListBudgets)
        {  
            for(Opportunity opp : OpportunityList)
            {
                if(opp.ContratOrigine__c == theBudget.NomContrat__c)
                {
                    if(!MapOppToBudgets.containsKey(opp))
                    {
                        MapOppToBudgets.put(opp, new list<Budget__c>());
                    }
                    MapOppToBudgets.get(opp).add(theBudget);
                }
            }
        }
        System.debug('##MapOppToBudgets '+ MapOppToBudgets);
        // find the budget that has the closest year to the signature year of the opportunity 
        for(Opportunity opp : MapOppToBudgets.keySet())
        {
            System.debug('##opp.tech_Budget__c before is '+ opp.tech_Budget__c);
            List<Budget__c> ListBudgetsRelatedToOPP= MapOppToBudgets.get(opp);
            
            Budget__c CorrectBudget;
            integer yearCorrect=0;
            integer OpportunityYear=Integer.valueOf(opp.Annee_de_signature__c);
            System.debug('##OpportunityYear '+ OpportunityYear);
            if(ListBudgetsRelatedToOPP.size()>0)
            {
                for(Budget__c thisBudget: ListBudgetsRelatedToOPP)
                {
                    System.debug('##thisBudget.AnneeBudget__c '+ thisBudget.AnneeBudget__c);
                    if( Integer.valueOf(thisBudget.AnneeBudget__c)>yearCorrect   && Integer.valueOf(thisBudget.AnneeBudget__c)<=OpportunityYear)
                    {
                        CorrectBudget=thisBudget;
                        yearCorrect=Integer.valueOf(thisBudget.AnneeBudget__c);
                    }
                }
            }
            
            //If the budget is found and the field  tech_Budget__c is diffrent from the found budget we update the field tech_Budget__c
            if(CorrectBudget!=null)
            {
                if(opp.tech_Budget__c!=CorrectBudget.id){
                    System.debug('##updating tech_Budget__c to '+ CorrectBudget.id);
                    opp.tech_Budget__c=CorrectBudget.id; 
                }
                lstOppToUpdate.add(opp);
            }
            else
            {
                System.debug('##updating tech_Budget__c to null');
                //If the budget is not found we update the field to null 
                opp.tech_Budget__c=null;
                lstOppToUpdate.add(opp);
            }
        }
        
        update lstOppToUpdate;
        
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}