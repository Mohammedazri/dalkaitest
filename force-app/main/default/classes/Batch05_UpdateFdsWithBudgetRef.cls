/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: batch used to Update the reference field Budget__c of the Fiche de Synthése with the proper value
             < THIS BATCH WAS USED TO UPDATE ALL THE RECORDS BEFORE ADDING THE FUNCTIONALITY OF THE CLASS AP15_Budget >
Test Class: Batch05_UpdateFdsWithBudgetRef_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch05_UpdateFdsWithBudgetRef implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query ='SELECT id, IdMigration__c, budget__c, budget__r.AnneeBudget__c, Opportunit_commerciale__c, Opportunit_commerciale__r.Annee_de_signature__c,'
            + 'P1CaRef__c, P2CaRef__c, P3CaRef__c, P4CaRef__c, P6CaRef__c,'
            + 'P1MbRef__c, P2MbRef__c, P3MbRef__c, P4MbRef__c, P6MbRef__c, Opportunit_commerciale__r.ContratOrigine__c FROM Fiche_de_synthese__c '
            + 'WHERE Opportunit_commerciale__r.ContratOrigine__c != \'\'  and ((Opportunit_commerciale__r.Type_pers__c=\''+ Label.PV_Renouvellement +'\' and (Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRen +'\' or Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRenEXP +'\')) or (Opportunit_commerciale__r.Type=\''+ Label.PV_Evolution +'\' and (Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRen +'\'  or Opportunit_commerciale__r.Record_type__c=\''+ Label.OppType_EvRenEXP +'\')))';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c> ListFichesAvecParents){
        
        List<String> lsitid = new List<String>();
        if(ListFichesAvecParents.size() > 0){
                        
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
                    //Map each fiche de syntheses to the budgets related to its contract
                    Map<id, List<Budget__c>> MapFicheToBudgets= new Map<id, List<Budget__c>>();
                    //Map each fiche de synthese to its old budget Object
                    Map<id, Budget__c> MapFicheToOldBudget= new Map<id, Budget__c>();
                    for(Budget__c theBudget : ListBudgets){  
                        for(Fiche_de_synthese__c theFiche : ListFichesAvecParents)
                        {
                            if(theFiche.Opportunit_commerciale__r.ContratOrigine__c == theBudget.NomContrat__c)
                            {
                                if(!MapFicheToBudgets.containsKey(theFiche.Id)){
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
                    
                    Map<Id, Fiche_de_synthese__c> MapFichesToUpdate= new Map<Id, Fiche_de_synthese__c>();
                    List<Fiche_de_synthese__c> ListFichesToUpdate= new List<Fiche_de_synthese__c>();
                    //Modify Budget__c field on each fiche de synthese if its year is closer to the opportunity year
                    for(Fiche_de_synthese__c theFiche : ListFichesAvecParents)
                    {
                        if(MapFicheToBudgets.containsKey(theFiche.Id))
                        {    
                            List<Budget__c> ListBudgetsRelatedToFiche= MapFicheToBudgets.get(theFiche.Id);
                            Budget__c CorrectBudget;
                            integer yearOfCorrectBudget=0;
                            integer OpportunityYear=0;
                            
                            OpportunityYear=Integer.valueOf(theFiche.Opportunit_commerciale__r.Annee_de_signature__c);
                            
                            for(Budget__c thisBudget: ListBudgetsRelatedToFiche)
                            {
                                if(Integer.valueOf(thisBudget.AnneeBudget__c)>yearOfCorrectBudget && Integer.valueOf(thisBudget.AnneeBudget__c)<=OpportunityYear)
                                {
                                    yearOfCorrectBudget=Integer.valueOf(thisBudget.AnneeBudget__c);
                                    CorrectBudget=thisBudget;
                                }
                            }
                            
                            if(yearOfCorrectBudget>0 && (theFiche.Budget__c==null || theFiche.Budget__c != CorrectBudget.Id)){
                                
                                MapFichesToUpdate.put(theFiche.Id, theFiche);
                                if(MapFicheToOldBudget.containsKey(theFiche.Id) && MapFicheToOldBudget.get(theFiche.Id)!=null){
                                    
                                    //if values not changed manually <==> if values are equal to old budget values
                                    //--> take values from new budget
                                    Budget__c OldBudget= MapFicheToOldBudget.get(theFiche.Id);
                                    
                                }else{
                                    //if fiche de synthese is new or has no previous budget, take values from new budget
                                    
                                } 
                                theFiche.Budget__c=CorrectBudget.Id;
                            }else{
                                
                                if(yearOfCorrectBudget==0 && MapFicheToOldBudget.containsKey(theFiche.Id) && MapFicheToOldBudget.get(theFiche.Id)!=null){
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
                    update ListFichesToUpdate;
                }
            } 
            
            
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC) {
    }
    
}