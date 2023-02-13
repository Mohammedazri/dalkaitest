/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Controller of LC27_BudgetOfFiche
Test Class: LC27_BudgetOfFiche_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
14/12/2021  Jimmy Khalil	 Changed the conditions of returning a budget for a contrat (C360-104)
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC27_BudgetOfFiche_Controller {
    public static ID budgID;
    @AuraEnabled
    public static Object getCurrentObject(Id FicheId){
        
        //get current year (annee N)
        
        String str = FicheId;
        if(str.left(3) == Label.LC27_ContratID) {
            Contrat__c myContrat = [SELECT id, OpportuniteCommerciale__c, (SELECT id, Name,  NomContrat__c,  AnneeBudget__c, NomContrat__r.Name,
                                                                           CABudgetP1__c,  CABudgetP2__c,  CABudgetP3__c,  CABudgetP4__c,  CABudgetP6__c,
                                                                           MBBudgetP1__c,  MBBudgetP2__c,  MBBudgetP3__c,  MBBudgetP4__c,  MBBudgetP6__c,
                                                                           NbHeuresP2P1Budget__c, NbHeuresP2P2Budget__c, NbHeuresP2P3Budget__c, NbHeuresP2P4Budget__c,
                                                                           NbHeuresP2P6Budget__c, TotalCABudgetP1P2P3P4__c,  TotalMBBudgetP1P2P3P4__c,BudgetNMainOeuvreValorisationTHO__c,
                                                                           BudgetNMainOeuvreDontNbHeureP2__c, BudgetNMainOeuvreDontNbHeureP3__c, BudgetNMainOeuvreDontNbHeureP6__c, BudgetNMainOeuvreNombreHeureTotal__c
                                                                           FROM Budgets__r)
                                    FROM Contrat__c
                                    Where id =:FicheId
                                    LIMIT 1];
            
            Budget__c myBudget;
            List<Budget__c> listBudget = myContrat.Budgets__r;
            BudgetCourant__c BudgetCourant = BudgetCourant__c.getValues('BudgetCourant');
            String currentYear =  String.valueOf(System.Today().year());
            String AnneeBudget = BudgetCourant.Annee__c;
            if(integer.valueof(currentYear) < integer.valueof(BudgetCourant.Annee__c)){
                AnneeBudget = currentYear; 
            }

            if(listBudget.size() > 0) {
                for(Budget__c bdg : listBudget) {
                    if(bdg.AnneeBudget__c == AnneeBudget) {
                        //if AnneeBudget__c = N return budget N
                        myBudget = bdg;
                        budgID = myBudget.id;
                        break;
                    } 
                }
            }
            return myBudget;
        }
        
        else if(str.left(3) == Label.LC27_OpportuntyID) {
            Opportunity myOpp = [SELECT id, tech_Budget__c
                                 FROM Opportunity
                                 Where id =:FicheId
                                 LIMIT 1];
            
            if(myOpp.tech_Budget__c != null) {
                Budget__c myBudget = [SELECT id, Name,  NomContrat__c,  AnneeBudget__c, NomContrat__r.Name,
                                      CABudgetP1__c,  CABudgetP2__c,  CABudgetP3__c,  CABudgetP4__c,  CABudgetP6__c,
                                      MBBudgetP1__c,  MBBudgetP2__c,  MBBudgetP3__c,  MBBudgetP4__c,  MBBudgetP6__c,
                                      NbHeuresP2P1Budget__c, NbHeuresP2P2Budget__c, NbHeuresP2P3Budget__c, NbHeuresP2P4Budget__c,
                                      NbHeuresP2P6Budget__c, TotalCABudgetP1P2P3P4__c,  TotalMBBudgetP1P2P3P4__c, BudgetNMainOeuvreDontNbHeureP2__c,
                                      BudgetNMainOeuvreDontNbHeureP3__c, BudgetNMainOeuvreDontNbHeureP6__c, BudgetNMainOeuvreNombreHeureTotal__c,BudgetNMainOeuvreValorisationTHO__c
                                      FROM Budget__c
                                      WHERE id =:myOpp.tech_Budget__c ];
                budgID = myBudget.id;
                
                return myBudget;
            } else {
                return null;
            }
        } else {
            Fiche_de_synthese__c myFiche = [SELECT id, Budget__c, Budget__r.Name, Budget__r.NomContrat__c, Budget__r.AnneeBudget__c, Opportunit_commerciale__c, Budget__r.NomContrat__r.Name,
                                            Budget__r.CABudgetP1__c, Budget__r.CABudgetP2__c, Budget__r.CABudgetP3__c, Budget__r.CABudgetP4__c, Budget__r.CABudgetP6__c,
                                            Budget__r.MBBudgetP1__c, Budget__r.MBBudgetP2__c, Budget__r.MBBudgetP3__c, Budget__r.MBBudgetP4__c, Budget__r.MBBudgetP6__c,
                                            Budget__r.NbHeuresP2P1Budget__c, Budget__r.NbHeuresP2P2Budget__c, Budget__r.NbHeuresP2P3Budget__c, Budget__r.NbHeuresP2P4Budget__c,
                                            Budget__r.NbHeuresP2P6Budget__c, Budget__r.TotalCABudgetP1P2P3P4__c, Budget__r.TotalMBBudgetP1P2P3P4__c,
                                            Budget__r.BudgetNMainOeuvreDontNbHeureP2__c, Budget__r.BudgetNMainOeuvreDontNbHeureP3__c, Budget__r.BudgetNMainOeuvreDontNbHeureP6__c, Budget__r.BudgetNMainOeuvreNombreHeureTotal__c
                                            FROM Fiche_de_synthese__c
                                            Where id =:FicheId
                                            LIMIT 1];
            system.debug('##myFiche ' + myFiche);
            
            return myFiche;
        }
        
    }
    
    @AuraEnabled
    public static Object getID(){
        return budgID;
        
    }
}