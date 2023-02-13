/**
* @author Rita Bejjani -EI Technologies
* @date 05/09/2019
* @description Batch qui crée des FDS pour les opportunités réalisées quelles soient perdues ou gagnées 
* @Test Class: Batch52_CreateFDS_test
* @Coverage: 95%
*/

global class Batch52_CreateFDS implements Database.Batchable<SObject>,Database.stateful{

    global string limt;
    
    global Batch52_CreateFDS(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id , Name, tech_Budget__c '+
            		   'FROM Opportunity '+ 
            		   'where (Nb_de_fiches_synthese__c  = 0 AND StageName = \'Réalisation\') ';
        
        if(limt<>'' && limt<>null)
        {
            query = query+ limt; 
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        List<Fiche_de_synthese__c> listFDSToInsert = new list<Fiche_de_synthese__c>();
        
        for(Opportunity opp : listOpp)
        {
            Fiche_de_synthese__c fds = new Fiche_de_synthese__c();
           if(opp.Name.length()>74)
            {
                fds.Name ='FDS - '+ opp.Name.substring(0,74);
            }
            else{
                fds.Name = 'FDS - '+ opp.Name;
            }
            fds.Opportunit_commerciale__c = opp.id;
           /* if(opp.tech_Budget__c <> null)
            {
               fds.Budget__c = opp.tech_Budget__c; 
            }*/
            listFDSToInsert.add(fds);
        }
        
        set<Id> SetOppIds= new set<Id>();// set that will contain the value of the field Opportunit_commerciale__c and used to query the Opportunities
        set<Id> SetContratIds= new set<Id>(); //  set that will contain the value of the field ContratOrigine__c and used to query the budgets
        List<Budget__c>ListBudgets=new List<Budget__c>();  // list that will contain the queried budgets
        Map<id, List<Budget__c>> MapOppToBudgets= new Map<id, List<Budget__c>>();// map that will contain the ID of the Fiche de sunthèse and the related list of Budgets (the relation here is only based on the contract)
        
        for(Fiche_de_synthese__c thisFiche: listFDSToInsert)
        {

            SetOppIds.add(thisFiche.Opportunit_commerciale__c);// loop on the list of FDS and fill the SetOppIds
        }
        //query the Opportunities relates to the FDS 
        Map<ID, Opportunity> MapOppIdToOpp = new Map<ID, Opportunity>([SELECT Annee_de_signature__c, ContratOrigine__c
                                                                       FROM Opportunity
                                                                       WHERE id in:SetOppIds
                                                                       and (Type_pers__c=: Label.PV_Renouvellement
                                                                            or Type_pers__c=: Label.PV_Evolution
                                                                            or(Type_pers__c =: Label.PV_Opp_Type_Nouveau AND OpportuniteDorigine__c!=null))
                                                                       AND (ContratOrigine__c != null)  ]);
        
        
        for(opportunity thisOpp: MapOppIdToOpp.values())
        {
            system.debug('opportunity: ' +thisOpp.ContratOrigine__c);
            SetContratIds.add(thisOpp.ContratOrigine__c);// loop on the Opportunities and fill the set SetContratIds
        }
        
        if(SetContratIds!= null)
        {
            //query the budgets 
            ListBudgets=[SELECT id, AnneeBudget__c, NomContrat__c,
                         CABudgetP1__c, CABudgetP2__c, CABudgetP3__c, CABudgetP4__c, CABudgetP6__c,
                         MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c
                         FROM Budget__c 
                         where NomContrat__c in: SetContratIds];
        }
        
        //loop on the queried budgets       
        for(Budget__c theBudget : ListBudgets)
        {  
            //loop on the Opportunities
            for(Opportunity opp : MapOppIdToOpp.values())
            {
                //if the Opportunity and the budget are related to the same contract add them to the map MapOppToBudgets
                if(opp.ContratOrigine__c == theBudget.NomContrat__c)
                {
                    if(!MapOppToBudgets.containsKey(opp.id))
                    {
                        MapOppToBudgets.put(opp.id, new list<Budget__c>());
                    }
                    MapOppToBudgets.get(opp.id).add(theBudget);
                }
            }
        }
        
        // loop on the FichesList and then on the list of budgets of each FDS to get the correct budget for each FDS
        for(Fiche_de_synthese__c theFiche : listFDSToInsert)
        {
            // if the set of keys of the MapOppToBudgets contains the FDS's ID 
            if(MapOppToBudgets.containsKey(theFiche.Opportunit_commerciale__c))
            {                  
                // get the List of budgets related to this FDS ( list of Budgets that are related to the same contract as the FDS)
                List<Budget__c> ListBudgetsRelatedToFiche= MapOppToBudgets.get(theFiche.Opportunit_commerciale__c);
                
                Budget__c CorrectBudget;// Declare the variable that will contain the correct budget N
                integer yearOfCorrectBudget=0;// declare and inisialize the variable that will contain the budget year 
                integer OpportunityYear=Integer.valueOf(MapOppIdToOpp.get(theFiche.Opportunit_commerciale__c).Annee_de_signature__c);// declare and initialize the variable that contains the year of the opportunity related to the FDS
                
                Budget__c CorrectBudgetRealise;// Declare the variable that will contain the correct budget N-1
                integer yearOfCorrectRealiset=0;// declare and inisialize the variable that will contain the budget year -1
                
                
                for(Budget__c thisBudget: ListBudgetsRelatedToFiche)// loop on the list of budgets 
                {
                    // if the year of the budget is greater than the variable yearOfCorrectBudget and smaller or equal to the Opportunity year 
                    if(Integer.valueOf(thisBudget.AnneeBudget__c)>yearOfCorrectBudget && Integer.valueOf(thisBudget.AnneeBudget__c)<=OpportunityYear)
                    {
                        yearOfCorrectBudget=Integer.valueOf(thisBudget.AnneeBudget__c);// modify the variable yearOfCorrectBudget with the value of the buget's year 
                        CorrectBudget=thisBudget;// modify the variable CorrectBudget with the budget 
                        
                    }
                }
                
                if(yearOfCorrectBudget>0)// if a budget is found 
                {    
                    
                    for(Budget__c thisBudget: ListBudgetsRelatedToFiche)// loop on the list of budgets 
                    {
                        // if the year of the budget is equal to the yearOfCorrectBudget-1
                        if(Integer.valueOf(thisBudget.AnneeBudget__c)>yearOfCorrectRealiset && Integer.valueOf(thisBudget.AnneeBudget__c)==(yearOfCorrectBudget-1))
                        {
                            yearOfCorrectRealiset=Integer.valueOf(thisBudget.AnneeBudget__c);// modify the variable yearOfCorrectRealiset with the value of the buget's year 
                            CorrectBudgetRealise=thisBudget;// modify the variable CorrectBudgetRealise with the budget 
                           
                        }
                    }
                    if(yearOfCorrectRealiset>0)// if we found a budget N-1
                    {
                        theFiche.Budget_Realise__c=CorrectBudgetRealise.Id;// update the field Budget_Realise__c
                    }
                    
                    theFiche.Budget__c=CorrectBudget.Id;// update the field Budget__c
                }
                
            }
        }
        
        insert listFDSToInsert;
         
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}