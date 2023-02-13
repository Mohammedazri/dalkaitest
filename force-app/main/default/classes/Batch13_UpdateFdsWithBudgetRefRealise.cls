/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: batch used to Update the reference field Budget__c and Budget_realise__c of the Fiche de Synthèse with the proper value
< THIS BATCH WAS USED TO UPDATE ALL THE RECORDS BEFORE ADDING THE FUNCTIONALITY OF THE CLASS AP15_Budget after update >
Test Class: Batch13_UpdateFdsBudgRefRealise_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch13_UpdateFdsWithBudgetRefRealise implements Database.Batchable<sObject>{
        
    Set<Id> setIds = new Set<Id>();

    global Batch13_UpdateFdsWithBudgetRefRealise (Set<Id> setIds){
        this.setIds = setIds;
    }
    
    global Batch13_UpdateFdsWithBudgetRefRealise (){   
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query ='SELECT id, IdMigration__c, budget__c, budget__r.AnneeBudget__c, Opportunit_commerciale__c, Opportunit_commerciale__r.Annee_de_signature__c,'
            + 'P1CaRef__c, P2CaRef__c, P3CaRef__c, P4CaRef__c, P6CaRef__c,Budget_Realise__c, '
            + 'P1MbRef__c, P2MbRef__c, P3MbRef__c, P4MbRef__c, P6MbRef__c, Opportunit_commerciale__r.ContratOrigine__c FROM Fiche_de_synthese__c '
            + 'WHERE Opportunit_commerciale__r.ContratOrigine__c != \'\'  and ((Opportunit_commerciale__r.Type_pers__c=\''+ Label.PV_Renouvellement +'\' and (Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRen +'\' or Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRenEXP +'\' or Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_appro +'\')) or (Opportunit_commerciale__r.Type_pers__c=\''
            + Label.PV_Evolution +'\' and (Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRen +'\'  or Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRenEXP +'\' or Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_appro +'\')))';
		//query = query + 'AND budget__r.AnneeBudget__c=\'2018\'';
		//query = query + ' AND id=\'0060Y00000CBLNgQAP\'';

        if(setIds!=null && setIds.size()>0){
            query = query + ' and id in :setIds';
        }

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c> ListFichesAvecParents)
    {
        
        List<String> lsitid = new List<String>();
        if(ListFichesAvecParents.size() > 0)
        {
            
            set<Id> SetContratIds= new set<Id>();
            set<Id> SetOldBudgetIds= new set<Id>();
            
            //get the contract ids and the old budget ids
            for(Fiche_de_synthese__c thisFiche: ListFichesAvecParents)
            {
                SetContratIds.add(thisFiche.Opportunit_commerciale__r.ContratOrigine__c);
                SetOldBudgetIds.add(thisFiche.Budget__c);
            }
            //get the budgets related to our contracts
            List<Budget__c>ListBudgets=new List<Budget__c>();        
            if(SetContratIds!= null)
            {
                ListBudgets=[SELECT id, AnneeBudget__c, NomContrat__c,
                             CABudgetP1__c, CABudgetP2__c, CABudgetP3__c, CABudgetP4__c, CABudgetP6__c,
                             MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c
                             FROM Budget__c 
                             where NomContrat__c in: SetContratIds
                             or id in: SetOldBudgetIds];
                if(ListBudgets != null)
                {
                    system.debug('La liste des budgets'+ListBudgets);
                    //Map each fiche de syntheses to the budgets related to its contract
                    Map<id, List<Budget__c>> MapFicheToBudgets= new Map<id, List<Budget__c>>();
                    //Map each fiche de synthese to its old budget Object
                    Map<id, Budget__c> MapFicheToOldBudget= new Map<id, Budget__c>();
                    for(Budget__c theBudget : ListBudgets)
                    {  
                        for(Fiche_de_synthese__c theFiche : ListFichesAvecParents)
                        {
                            if(theFiche.Opportunit_commerciale__r.ContratOrigine__c == theBudget.NomContrat__c)
                            {
                                if(!MapFicheToBudgets.containsKey(theFiche.Id))
                                {
                                    MapFicheToBudgets.put(theFiche.Id, new list<Budget__c>());
                                }
                                MapFicheToBudgets.get(theFiche.Id).add(theBudget);
                            }
                            
                            if(theFiche.Budget__c != null && theFiche.Budget__c == theBudget.Id)
                            {
                                if(!MapFicheToOldBudget.containsKey(theFiche.Id))
                                    MapFicheToOldBudget.put(theFiche.Id, theBudget);
                            }
                        }
                    }
                    
                    System.Debug('Maps'+MapFicheToOldBudget+MapFicheToBudgets);
                    
                    Map<Id, Fiche_de_synthese__c> MapFichesToUpdate= new Map<Id, Fiche_de_synthese__c>();
                    List<Fiche_de_synthese__c> ListFichesToUpdate= new List<Fiche_de_synthese__c>();
                    //Modify Budget__c field on each fiche de synthese if its year is closer to the opportunity year
                    for(Fiche_de_synthese__c theFiche : ListFichesAvecParents)
                    {
                        if(MapFicheToBudgets.containsKey(theFiche.Id))
                        {    
                            List<Budget__c> ListBudgetsRelatedToFiche= MapFicheToBudgets.get(theFiche.Id);
                            Budget__c CorrectBudget;
                            Budget__c CorrectBudgetRealise;
                            integer yearOfCorrectBudget=0;
                            integer OpportunityYear=0;
                            integer yearOfCorrectRealiset=0;
                            system.Debug('test###test###'+ListBudgetsRelatedToFiche);
                            OpportunityYear=Integer.valueOf(theFiche.Opportunit_commerciale__r.Annee_de_signature__c);
                            system.Debug('oppyear '+OpportunityYear);
                            
                            for(Budget__c thisBudget: ListBudgetsRelatedToFiche)
                            {	system.Debug('ANNEE1 : '+Integer.valueOf(thisBudget.AnneeBudget__c)+' '+yearOfCorrectBudget);
                             if(Integer.valueOf(thisBudget.AnneeBudget__c)>yearOfCorrectBudget && Integer.valueOf(thisBudget.AnneeBudget__c)<=OpportunityYear)
                             {
                                 
                                 yearOfCorrectBudget=Integer.valueOf(thisBudget.AnneeBudget__c);
                                 CorrectBudget=thisBudget;
                                 /*here comes the new */
                             }
                             system.Debug('ANNEE2 : '+yearOfCorrectBudget);
                             
                            }
                            if(yearOfCorrectBudget>0)// if a budget is found 
                            {    
                                
                                for(Budget__c thisBudget: ListBudgetsRelatedToFiche)// loop on the list of budgets 
                                {
                                    // if the year of the budget is equal to the yearOfCorrectBudget-1
                                    System.Debug('test###'+thisBudget.AnneeBudget__c+yearOfCorrectBudget);
                                    if(Integer.valueOf(thisBudget.AnneeBudget__c)>yearOfCorrectRealiset && Integer.valueOf(thisBudget.AnneeBudget__c)==(yearOfCorrectBudget-1))
                                    {
                                        System.Debug('Le batch travaille 1');
                                        yearOfCorrectRealiset=Integer.valueOf(thisBudget.AnneeBudget__c);// modify the variable yearOfCorrectRealiset with the value of the buget's year 
                                        CorrectBudgetRealise=thisBudget;// modify the variable CorrectBudgetRealise with the budget 
                                    }
                                }
                                
                                if(yearOfCorrectRealiset>0)// if we found a budget N-1
                                {
                                    System.Debug('Le batch travaille 2');
                                    theFiche.Budget_Realise__c=CorrectBudgetRealise.Id;// update the field Budget_Realise__c
                                	MapFichesToUpdate.put(theFiche.Id, theFiche);
                                }
                            }
                            System.Debug('Check cond ' +yearOfCorrectBudget+' '+theFiche.Budget__c);
                            if(yearOfCorrectBudget>0 && (theFiche.Budget__c==null || theFiche.Budget__c != CorrectBudget.Id))
                            {
                                
                                MapFichesToUpdate.put(theFiche.Id, theFiche);
                                if(MapFicheToOldBudget.containsKey(theFiche.Id) && MapFicheToOldBudget.get(theFiche.Id)!=null)
                                {
                                    
                                    //if values not changed manually <==> if values are equal to old budget values
                                    //--> take values from new budget
                                    Budget__c OldBudget= MapFicheToOldBudget.get(theFiche.Id);
                                    
                                }
                                else
                                {
                                    //if fiche de synthese is new or has no previous budget, take values from new budget
                                    
                                } 
                                
                                theFiche.Budget__c=CorrectBudget.Id;
                                
                                
                                
                            }
                            else{
                                
                                if(yearOfCorrectBudget==0 && MapFicheToOldBudget.containsKey(theFiche.Id) && MapFicheToOldBudget.get(theFiche.Id)!=null)
                                {
                                    //if values not changed manually <==> if values are equal to old budget values
                                    //--> put 0 in CA
                                    Budget__c OldBudget= MapFicheToOldBudget.get(theFiche.Id);
                                    MapFichesToUpdate.put(theFiche.Id, theFiche);
                                    
                                    theFiche.Budget__c=null;
                                }
                            }
                        }
                    }
                    
                    
                    //if in after trigger update fiche de synthese
                    ListFichesToUpdate=MapFichesToUpdate.values();
                    system.Debug('MapFichesToUpdate'+MapFichesToUpdate);
                    
                    update ListFichesToUpdate;
                }
            } 
            
            
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}