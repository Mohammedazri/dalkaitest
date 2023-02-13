/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Chadi Geara
Company: EI-Technologies
Description: Responsable for filling budget fields ( TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c) from the most recent budget record
of a contrat to the contrat itself (Contrat__c.TechTotalCABudgetP1P2P3P4__c and Contrat__c.TechTotalMBBudgetP1P2P3P4__c.)
Test Class:  AP44_Budget_Test
-------------------------------------------------------------------------------------------------------------------------------------*/

public without sharing class AP44_Budget {
    
    
    public static void displayMostRecentOnCont(List<Budget__c> lstBudget, Map<Id,Budget__c> MapBudgetOld){
        
        // manipulate the budget list (lstBudget) if on update
        if( MapBudgetOld != null ){
            List<Budget__c> newLstBudget = new  List<Budget__c>();
            for ( Budget__c bgt : lstBudget){
                
                boolean ifChange = ( MapBudgetOld.get(bgt.Id).BudgetNP1VentesServices__c != bgt.BudgetNP1VentesServices__c 
                                    || MapBudgetOld.get(bgt.Id).BudgetNP2VentesServices__c != bgt.BudgetNP2VentesServices__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP3VentesServices__c != bgt.BudgetNP3VentesServices__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP4VentesServices__c != bgt.BudgetNP4VentesServices__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP6VentesServices__c != bgt.BudgetNP6VentesServices__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP1MargeBrute__c != bgt.BudgetNP1MargeBrute__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP2MargeBrute__c != bgt.BudgetNP2MargeBrute__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP3MargeBrute__c != bgt.BudgetNP3MargeBrute__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP4MargeBrute__c != bgt.BudgetNP4MargeBrute__c
                                    || MapBudgetOld.get(bgt.Id).BudgetNP6MargeBrute__c != bgt.BudgetNP6MargeBrute__c
                                    || MapBudgetOld.get(bgt.Id).AnneeBudget__c != bgt.AnneeBudget__c
                                    ||MapBudgetOld.get(bgt.Id).name != bgt.name);
                
                if (ifChange){
                    newLstBudget.add(bgt);
                }           
            }
            lstBudget = newLstBudget;            
        }
        
        Set<Id> setContratsId = new  Set<Id>();
        
        for ( Budget__c bgt : lstBudget){
            setContratsId.add(bgt.NomContrat__c);
        }
        
        List<Budget__c> allBudgets = [ SELECT Id,name,AnneeBudget__c, TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c ,NomContrat__c
                                      FROM Budget__c
                                      WHERE NomContrat__c IN :setContratsId];
        
        
        Map<Id,Budget__c> MapContIdRecentBudget = new  Map<Id,Budget__c>();
        BudgetCourant__c BudgetCourant = BudgetCourant__c.getValues('BudgetCourant');
        if (BudgetCourant!=NULL){
            for ( Budget__c bgt : allBudgets){
                if(bgt.AnneeBudget__c == BudgetCourant.Annee__c && bgt.AnneeBudget__c == String.valueOf(System.Today().year())){
                    MapContIdRecentBudget.put(bgt.NomContrat__c,bgt);
                } 
            }
            
            /*Modified by Jacques Akiki 12/07/2019*/
            if (MapContIdRecentBudget.size()>0 ) 
            {
                List <Contrat__c> listContUpdate = new List<Contrat__c>();
                for (Id contId : MapContIdRecentBudget.keySet())
                {
                    Contrat__c cont = new Contrat__c();
                    cont.Id = contId;
                    cont.BudgetReference__c = MapContIdRecentBudget.get(contId).name;
                    cont.TechTotalCABudgetP1P2P3P4__c = MapContIdRecentBudget.get(contId).TotalCABudgetP1P2P3P4__c;
                    cont.TechTotalMBBudgetP1P2P3P4__c = MapContIdRecentBudget.get(contId).TotalMBBudgetP1P2P3P4__c;
                    listContUpdate.add(cont);
                }
                update listContUpdate;
            } 
        }
    }
}