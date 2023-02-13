/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this class is responsible of setting the lookup field tech_Budget__c of opportunity 
Test Class: AP17_BudgetOnOpp_test
History
<Date>      <Authors Name>   <Brief Description of Change>
30/08/2018	Jacques Akiki	 Introduce changes in record type and filter conditions
14/12/2021  Jimmy Khalil	 Changed the conditions to attach a budget to an opp (C360-104)
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class AP17_BudgetOnOpp 
{
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: this function is used to enter the field tech_Budget__c when a budget is created or edited
Inputs: list of Budget
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateBudgetOnOpportunityFromBudget(List<Budget__c> budgetMap)
    {
        set<Id> SetContratIds= new set<Id>();
        BudgetCourant__c bugetCourant = BudgetCourant__c.getValues('BudgetCourant');
        
        for(Budget__c bdgt: budgetMap)
        {
            if(bdgt.NomContrat__c!=null)
            {
                SetContratIds.add(bdgt.NomContrat__c);
            }
            
        }
        if(SetContratIds.size()>0){
            List<Opportunity> ListOpp = new List<Opportunity>([SELECT Annee_de_signature__c, ContratOrigine__c,tech_Budget__c
                                                               FROM Opportunity
                                                               WHERE ContratOrigine__c in:SetContratIds AND statut__c=:Label.Opp_StatutEnCours
                                                               AND (Type_pers__c=: Label.PV_Renouvellement OR Type_pers__c=: Label.PV_Evolution)
                                                               AND ContratOrigine__c != null FOR UPDATE]);
            if(ListOpp!=null && ListOpp.size()>0){              
                /*--End*/
                system.debug('list of opportunities'+listOpp);        
                List<Budget__c> ListBudgets=new List<Budget__c>([SELECT id, AnneeBudget__c, NomContrat__c,
                                                                 CABudgetP1__c, CABudgetP2__c, CABudgetP3__c, CABudgetP4__c, CABudgetP6__c,
                                                                 MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c
                                                                 FROM Budget__c 
                                                                 where NomContrat__c in: SetContratIds FOR UPDATE]);
                
                List<Opportunity> ListOppToUpdate= new List< Opportunity> ();                    
                Map<String, List<Budget__c>> MapcontratIdToBudgets= new Map<String, List<Budget__c>>();                 
                
                //fill a map with the contrat and the list of the related budgets
                if(ListBudgets!=null && ListBudgets.size()>0){
                    for(Budget__c theBudget : ListBudgets)
                    {  
                        if(!MapcontratIdToBudgets.containsKey(theBudget.NomContrat__c)){
                            MapcontratIdToBudgets.put(theBudget.NomContrat__c, new list<Budget__c>());
                        }
                        MapcontratIdToBudgets.get(theBudget.NomContrat__c).add(theBudget);
                    }
                }
                
                for(Opportunity opp : ListOpp)
                {                        
                    Budget__c CorrectBudget; 
                    integer yearCorrect=0;
                    integer OpportunityYear=Integer.valueOf(opp.Annee_de_signature__c);
                    
                    //get related budgets based on the ContratOrigine__c
                    if(MapcontratIdToBudgets.containsKey(opp.ContratOrigine__c) && bugetCourant !=NULL)
                    {
                        integer currBudget = Integer.valueOf(bugetCourant.annee__c);
                        for(Budget__c thisBudget: MapcontratIdToBudgets.get(opp.ContratOrigine__c))
                        {
                            Integer budgetYear = Integer.valueOf(thisBudget.AnneeBudget__c);
                            //if AnneeBudget__c >= this year we can only attach the budget of the current or previous year
                            if(OpportunityYear >= currBudget && budgetYear == currBudget){
                                CorrectBudget=thisBudget;
                                break;
                            }
                        }
                    }
                    if(CorrectBudget!=null)
                    { 
                        if(opp.tech_Budget__c==null || opp.tech_Budget__c!=CorrectBudget.id)
                        {
                            opp.tech_Budget__c=CorrectBudget.id;
                            ListOppToUpdate.add(opp);
                        }
                    }
                   
                }
                if(ListOppToUpdate.size()>0)
                {
                    update ListOppToUpdate;
                }
            }
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: this function is used to enter the field tech_Budget__c when an opportunity is created or edited
Inputs: list of Opportunities
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/  
    public static void UpdateBudgetOnOpportunityFromOpportunity(List<Opportunity> OpportunityList)
    {
        
        set<Id> SetContratIds= new set<Id>();
        
        BudgetCourant__c bugetCourant = BudgetCourant__c.getValues('BudgetCourant');
        for(opportunity thisOpp: OpportunityList)
        {
            if(thisOpp.ContratOrigine__c!=null){
                SetContratIds.add(thisOpp.ContratOrigine__c);
            }
        }
        
        //query all the budgets that has the same contract as the opportunities or have the AnneeBudget__c = Annee_de_signature__c
        List<Budget__c> ListBudgets=new List<Budget__c>([SELECT id, AnneeBudget__c, NomContrat__c,
                                                         CABudgetP1__c, CABudgetP2__c, CABudgetP3__c, CABudgetP4__c, CABudgetP6__c,
                                                         MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c
                                                         FROM Budget__c 
                                                         where NomContrat__c in: SetContratIds]);
        
        
        
        Map<String, List<Budget__c>> MapcontratIdToBudgets= new Map<String, List<Budget__c>>(); 
        
        if(ListBudgets!=null && ListBudgets.size()>0){
            //fill a map with the contrat and the list of the related budgets
            for(Budget__c theBudget : ListBudgets)
            {  
                if(!MapcontratIdToBudgets.containsKey(theBudget.NomContrat__c)){
                    MapcontratIdToBudgets.put(theBudget.NomContrat__c, new list<Budget__c>());
                }
                MapcontratIdToBudgets.get(theBudget.NomContrat__c).add(theBudget);
            }
        }
        if(bugetCourant!=NULL){
            integer currBudget = Integer.valueOf(bugetCourant.annee__c);
            for(Opportunity opp : OpportunityList)
            {
                Budget__c CorrectBudget;
                integer OpportunityYear=Integer.valueOf(opp.Annee_de_signature__c);
                //get related budgets based on the ContratOrigine__c
                if(MapcontratIdToBudgets.containsKey(opp.ContratOrigine__c))
                {            
                    for(Budget__c thisBudget: MapcontratIdToBudgets.get(opp.ContratOrigine__c))
                    {
                        Integer budgetYear = Integer.valueOf(thisBudget.AnneeBudget__c);
                        Integer currentYear =  System.Today().year();
                        //if AnneeBudget__c >= this year we can only attach the budget of the current or previous year
                        if((OpportunityYear >= currBudget && budgetYear == currBudget)
                          ||(OpportunityYear < currBudget && budgetYear == OpportunityYear && OpportunityYear==currentYear)){
                            CorrectBudget=thisBudget;
                            break;
                        }
                    }
                }  
                
                //If the budget is found and the field  tech_Budget__c is diffrent from the found budget we update the field tech_Budget__c
                if(CorrectBudget!=null)
                {
                    if(opp.tech_Budget__c!=CorrectBudget.id)
                    {
                        opp.tech_Budget__c=CorrectBudget.id; 
                    }
                }
                else
                {
                    //If the budget is not found we update the field to null 
                    opp.tech_Budget__c=null;
                }
            }
        }
    }
}