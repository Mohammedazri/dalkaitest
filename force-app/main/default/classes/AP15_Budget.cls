/*--------------------------------------------------------------------------------------------------------------------------
   Author: Dona Kfoury
   Company: EI-Technologies
   Description: This class aims to relate the "Fiche_de_synthese__c"(FDS) records to their proper "Budget__c" record by filling the lookup field "Budget__c" on "Fiche_de_synthese__c".
   this relation is based on the comparision between the fields (ContratOrigine__c, Annee_de_signature__c) of the Opportunity related to the FDS and the fields (NomContrat__c,AnneeBudget__c) of the Budget
   Test Class: AP15_Budget_Test
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   26/06/2018   Johny Kassis      Commented AP15.
   12/07/2018   Johny Kassis      Modified the class to set the reference field in Budget__c on the FDS.
   24/07/2018   Johny Kassis      added the sections where the field Budget_Realise__c is set.
   30/08/2018	 Jacques Akiki		added a new filter to the query to take the opportunity of record type  Opportunité suite appro Opport
   20/12/2021	 Jimmy Khalil	   changed the code to directly copy the budget from the tech_Budget__c of opp to the Budget__c of fds and the budget of the previous year to Budget_Realise__c
   28/01/2022    Jimmy Khalil       ne plus avoir de budget de référence pour la fds d'une opportunite concurrente (US C360-588)
   --------------------------------------------------------------------------------------------------------------------------*/

public class AP15_Budget {
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Dona Kfoury
       Company: EI-Technologies
       Description: This function is used in the trigger FicheDeSyntheseBeforeInsert
       It enters the proper value of the lookup field Budget__c when a record of type Fiche_de_synthese__c is created
       Inputs: List of "Fiche_de_synthese__c" and a boolean
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateBudgetOnFicheDeSyntheseBeforeInsert(List<Fiche_de_synthese__c> FichesList){
        set<Id> SetOppIds = new set<Id>();// set that will contain the value of the field Opportunit_commerciale__c and used to query the Opportunities
        set<Id> SetContratIds = new set<Id>(); //  set that will contain the value of the field ContratOrigine__c and used to query the budgets
        List<Budget__c> ListBudgets = new List<Budget__c>();  // list that will contain the queried budgets

        for(Fiche_de_synthese__c thisFiche : FichesList) {
            SetOppIds.add(thisFiche.Opportunit_commerciale__c);// loop on the list of FDS and fill the SetOppIds
        }
        //query the Opportunities relates to the FDS and not concurrente (OpportuniteDorigine__c =null) to keep Budget__c empty
        Map<ID, Opportunity> MapOppIdToOpp = new Map<ID, Opportunity>([SELECT Annee_de_signature__c, ContratOrigine__c,
                                                                       tech_Budget__c, tech_Budget__r.AnneeBudget__c
                                                                       FROM Opportunity
                                                                       WHERE id in: SetOppIds and statut__c = : Label.Opp_StatutEnCours
                                                                       AND (Type_pers__c = : Label.PV_Renouvellement OR Type_pers__c = : Label.PV_Evolution)
                                                                       AND (ContratOrigine__c != null)
                                                                       AND OpportuniteDorigine__c = null  ]);

        Map<String, String> mapOppIdAnneeBudgetRealise = new Map<String, String>();

        for(opportunity thisOpp : MapOppIdToOpp.values()) {
            SetContratIds.add(thisOpp.ContratOrigine__c);// loop on the Opportunities and fill the set SetContratIds
            if(thisOpp.tech_Budget__c != null) {
                //if tech_Budget__c existe on opp, we get the budget of the previous year for Budget_Realise__c
                Integer anneeBudget = Integer.valueOf(thisOpp.tech_Budget__r.AnneeBudget__c);
                mapOppIdAnneeBudgetRealise.put(thisOpp.Id, String.valueOf(anneeBudget - 1));
            }
        }

        Map<String, List<Budget__c>> mapcontratIdBudget = new Map<String, List<Budget__c>>();
        if(SetContratIds != null) {
            //query the budgets related to the same contrat of the opp for the previous year
            ListBudgets = [SELECT id, AnneeBudget__c, NomContrat__c,
                           CABudgetP1__c, CABudgetP2__c, CABudgetP3__c, CABudgetP4__c, CABudgetP6__c,
                           MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c
                           FROM Budget__c
                           where NomContrat__c in: SetContratIds];
        }

        //map contrat to related budgets
        if(ListBudgets != null && ListBudgets.size() > 0) {
            for(Budget__c theBudget : ListBudgets) {
                if(!mapcontratIdBudget.containsKey(theBudget.NomContrat__c)) {
                    mapcontratIdBudget.put(theBudget.NomContrat__c, new List<Budget__c>());
                }
                mapcontratIdBudget.get(theBudget.NomContrat__c).add(theBudget);
            }
        }

        for(Fiche_de_synthese__c currFiche : FichesList) {
            Opportunity currOpp = MapOppIdToOpp.get(currFiche.Opportunit_commerciale__c);
            if(currOpp != null) {
                //Budget__c = tech_Budget__c
                currFiche.Budget__c = currOpp.tech_Budget__c;
                if(mapcontratIdBudget.containsKey(currOpp.ContratOrigine__c)) {
                    for(Budget__c contratBudget : mapcontratIdBudget.get(currOpp.ContratOrigine__c)) {
                        //Budget_Realise__c = budget of year-1
                        if(contratBudget.AnneeBudget__c == mapOppIdAnneeBudgetRealise.get(currOpp.Id)) {
                            currFiche.Budget_Realise__c = contratBudget.Id;
                            break;
                        }
                    }
                }
            }
        }

    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Dona Kfoury
       Company: EI-Technologies
       Description:  This function is used in the trigger OpportunityAfterUpdate it finds the related  list "Fiche_de_synthese__c" and call the function UpdateBudgetOnFicheDeSynthese.
       Inputs: List of Opportunities and a boolean.
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateBdgFDSAfterUpdateAnneeOpp(List<Opportunity> OpportunityList){
        //quert the Fiche_de_synthese__c related to the modified Opportunities
        List<Fiche_de_synthese__c> ListFichesAvecParents = [SELECT id, budget__c, budget__r.AnneeBudget__c, Opportunit_commerciale__r.Annee_de_signature__c,
                                                            P1CaRef__c, P2CaRef__c, P3CaRef__c, P4CaRef__c, P6CaRef__c,
                                                            P1MbRef__c, P2MbRef__c, P3MbRef__c, P4MbRef__c, P6MbRef__c,
                                                            Opportunit_commerciale__r.ContratOrigine__c, Budget_Realise__c,
                                                            Opportunit_commerciale__r.tech_Budget__c, Opportunit_commerciale__r.tech_Budget__r.AnneeBudget__c
                                                            FROM Fiche_de_synthese__c
                                                            WHERE Opportunit_commerciale__c in:OpportunityList AND Opportunit_commerciale__r.statut__c =:Label.Opp_StatutEnCours
                                                            AND (Opportunit_commerciale__r.Type_pers__c =: Label.PV_Renouvellement OR Opportunit_commerciale__r.Type_pers__c =: Label.PV_Evolution )
                                                            AND(Opportunit_commerciale__r.ContratOrigine__c != null)
        ];
        //if the List is not empty call the function UpdateBudgetOnFicheDeSynthese and add the List as an argument
        if(ListFichesAvecParents.size() > 0) {
            UpdateBudgetOnFicheDeSynthese(ListFichesAvecParents);
        }
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Dona Kfoury
       Company: EI-Technologies
       Description: This function is used in the trigger BudgetAfterInsert it query the list of "Fiche_de_synthese__c" that has the  same contract (Opportunit_commerciale__r.ContratOrigine__c)
       by calling the function UpdateBdgFDSAfterUpdateAnneeorContratBdg that will call another function to modify the List of FDS if necessary
       Inputs: list of Opportunities and a boolean
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateBdgFDSAfterInsertBdg(List<Budget__c> BudgetList){
        set<Id> SetContratIds = new set<Id>();// this set will contain the IDs of the Contract mentioned in the budgets
        for(Budget__c thisBudget : BudgetList) {
            if(thisBudget.NomContrat__c != null) {
                SetContratIds.add(thisBudget.NomContrat__c);// add the contract's ID of the budget to the  set
            }
        }
        if(SetContratIds.size() > 0) {
            UpdateBdgFDSAfterUpdateAnneeorContratBdg(SetContratIds);//call the function UpdateBdgFDSAfterUpdateAnneeorContratBdg to query the related Fiche_de_synthese__c
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Dona Kfoury
       Company: EI-Technologies
       Description:  This function is used in the trigger BudgetAfterUpdate when the year or the name of the budget change and in the above function
       It takes a set of contracts as an argument and queries the list of related "Fiche_de_synthese__c" that has the same contract (Opportunit_commerciale__r.ContratOrigine__c)
       and then it calls the function UpdateBudgetOnFicheDeSynthese to update the field Budget__c of the records of the queried List if necessary.
       Inputs: Set of contract IDs and a boolean
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateBdgFDSAfterUpdateAnneeorContratBdg(set<Id> SetContratIds){
        //query all the Fiche_de_synthese__c related to the  set of contracts
        List<Fiche_de_synthese__c> ListFichesAvecParents = [SELECT id, budget__c, budget__r.AnneeBudget__c, Opportunit_commerciale__r.Annee_de_signature__c,
                                                            P1CaRef__c, P2CaRef__c, P3CaRef__c, P4CaRef__c, P6CaRef__c,
                                                            P1MbRef__c, P2MbRef__c, P3MbRef__c, P4MbRef__c, P6MbRef__c,
                                                            Opportunit_commerciale__r.ContratOrigine__c, Budget_Realise__c,
                                                            Opportunit_commerciale__r.tech_Budget__c, Opportunit_commerciale__r.tech_Budget__r.AnneeBudget__c
                                                            FROM Fiche_de_synthese__c
                                                            WHERE Opportunit_commerciale__r.ContratOrigine__c in:SetContratIds AND Opportunit_commerciale__r.statut__c =:Label.Opp_StatutEnCours
                                                            AND (Opportunit_commerciale__r.Type_pers__c =: Label.PV_Renouvellement OR Opportunit_commerciale__r.Type_pers__c =: Label.PV_Evolution)
                                                            AND(Opportunit_commerciale__r.ContratOrigine__c != null)];

        if(ListFichesAvecParents.size() > 0) {
            UpdateBudgetOnFicheDeSynthese(ListFichesAvecParents);//  call the function UpdateBudgetOnFicheDeSynthese and pass the queried list as an argument
        }
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Dona Kfoury
       Company: EI-Technologies
       Description:  this function is used in the functions abov. It takes a list of FDS as an argument and Update their  field Budget__c with the ID of the proper Budget
       Inputs: List of "Fiche_de_synthese__c" and a boolean
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/

    public static void UpdateBudgetOnFicheDeSynthese(List<Fiche_de_synthese__c> ListFichesAvecParents){
        set<Id> SetContratIds = new set<Id>();//Set used to store the contracts IDs related to the items of the list ListFichesAvecParents
        List<Budget__c> ListBudgets = new List<Budget__c>();  // list that will contain the queried budgets
        List<Fiche_de_synthese__c> fichesToUpdate = new List<Fiche_de_synthese__c>();// list of Fiche_de_synthese__c to Update
        Map<String, String> mapOppIdAnneeBudgetRealise = new Map<String, String>();//map Opp with the previous year of the related budget

        // loop on the list ListFichesAvecParents
        for(Fiche_de_synthese__c thisFiche : ListFichesAvecParents) {
            SetContratIds.add(thisFiche.Opportunit_commerciale__r.ContratOrigine__c);// fill the set SetContratIds
            if(thisFiche.Opportunit_commerciale__r.tech_Budget__c != null) {
                //if tech_Budget__c existe on opp, we get the budget of the previous year for Budget_Realise__c
                Integer anneeBudget = Integer.valueOf(thisFiche.Opportunit_commerciale__r.tech_Budget__r.AnneeBudget__c);
                mapOppIdAnneeBudgetRealise.put(thisFiche.Opportunit_commerciale__c, String.valueOf(anneeBudget - 1));
            }
        }

        if(SetContratIds != null) {
            // query the Budgets
            ListBudgets = [SELECT id, AnneeBudget__c, NomContrat__c,
                           CABudgetP1__c, CABudgetP2__c, CABudgetP3__c, CABudgetP4__c, CABudgetP6__c,
                           MBBudgetP1__c, MBBudgetP2__c, MBBudgetP3__c, MBBudgetP4__c, MBBudgetP6__c
                           FROM Budget__c
                           where NomContrat__c in: SetContratIds];

            //map contrat Id to list of related budget
            Map<String, List<Budget__c>> mapcontratIdBudget = new Map<String, List<Budget__c>>();
            if(ListBudgets != null) {
                for(Budget__c theBudget : ListBudgets) {
                    if(!mapcontratIdBudget.containsKey(theBudget.NomContrat__c)) {
                        mapcontratIdBudget.put(theBudget.NomContrat__c, new List<Budget__c>());
                    }
                    mapcontratIdBudget.get(theBudget.NomContrat__c).add(theBudget);
                }
            }

            // loop on the ListFichesAvecParents
            for(Fiche_de_synthese__c theFiche : ListFichesAvecParents) {
                //to check if we need to update the budget fields on the fds because the value has changed or is empty to avoid updating unchaged fds
                Boolean updateBudget = false;
                Boolean updateBudgetRealise = false;

                //Budget__c = tech_Budget__c
                //we copy the budget from the opp
                if(theFiche.Budget__c != theFiche.Opportunit_commerciale__r.tech_Budget__c) {
                    theFiche.Budget__c = theFiche.Opportunit_commerciale__r.tech_Budget__c;
                    updateBudget = true;
                }

                if(mapcontratIdBudget.containsKey(theFiche.Opportunit_commerciale__r.ContratOrigine__c)) {
                    for(Budget__c contratBudget : mapcontratIdBudget.get(theFiche.Opportunit_commerciale__r.ContratOrigine__c)) {
                        //Budget_Realise__c = budget of year-1
                        if(contratBudget.AnneeBudget__c == mapOppIdAnneeBudgetRealise.get(theFiche.Opportunit_commerciale__c)) {
                            if(theFiche.Budget_Realise__c != contratBudget.Id) {
                                theFiche.Budget_Realise__c = contratBudget.Id;
                                updateBudgetRealise = true;
                            } else {
                                updateBudgetRealise = false;
                            }
                            break;
                        } else {
                            //if we don't have the previous budget, we empty the field
                            if(theFiche.Budget_Realise__c != null) {
                                theFiche.Budget_Realise__c = null;
                                updateBudgetRealise = true;
                            } else {
                                updateBudgetRealise = false;
                            }
                        }
                    }
                } else {
                    //if we don't have the previous budget, we empty the field
                    if(theFiche.Budget_Realise__c != null) {
                        theFiche.Budget_Realise__c = null;
                        updateBudgetRealise = true;
                    } else {
                        updateBudgetRealise = false;
                    }
                }

                if(updateBudget || updateBudgetRealise) {
                    fichesToUpdate.add(theFiche);
                }
            }
            if(fichesToUpdate.size() > 0) {
                update fichesToUpdate;//update fiche de synthese
            }

        }
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Dona Kfoury
       Company: EI-Technologies
       Description:  This function is used in the trigger BudgetBeforeDelete it updates the lookup field(Budget__c) of the "Fiche_de_synthese__c" records whenever a budget is deleted
       Inputs: List of the deleted Budgets and a boolean
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateBdgFDSAfterDeleteBdg(List<Budget__c> ListDeletedBudget){
        set<Id> SetoldContratIds = new set<Id>();// set that will contain the contract ID of the deleted budgets
        set<Id> SetDeletedBudgetIds = new set<Id>();// set that will contain the ID of the deleted budgets
        set<Id> SetContratIds = new set<Id>();// set that contains the contract ID of the queried FDS
        List<Budget__c> ListBudgets = new List<Budget__c>(); // list that will contain the queried budgets
        List<Fiche_de_synthese__c> ListFichesToUpdate = new List<Fiche_de_synthese__c>();
        Map<String, String> mapOppIdAnneeBudgetRealise = new Map<String, String>();//map Opp with the previous year of the related budget

        // Loop on the list of deleted budgets
        for(Budget__c thisBudget : ListDeletedBudget) {
            SetoldContratIds.add(thisBudget.NomContrat__c);// fill the set SetoldContratIds with the contract ID of the deleted budgets
            SetDeletedBudgetIds.add(thisBudget.Id); //fill the set SetDeletedBudgetIds with the ID of the deleted budgets
        }
        //query the list of Fiche_de_synthese__c
        List<Fiche_de_synthese__c> ListFichesAvecParents = [SELECT id, budget__c, budget__r.AnneeBudget__c, Opportunit_commerciale__r.Annee_de_signature__c,
                                                            Opportunit_commerciale__r.ContratOrigine__c, Budget_Realise__c,
                                                            Opportunit_commerciale__r.tech_Budget__c, Opportunit_commerciale__r.tech_Budget__r.AnneeBudget__c
                                                            FROM Fiche_de_synthese__c
                                                            WHERE Opportunit_commerciale__r.ContratOrigine__c in:SetoldContratIds and Opportunit_commerciale__r.statut__c =:Label.Opp_StatutEnCours
                                                            AND (Opportunit_commerciale__r.Type_pers__c =: Label.PV_Renouvellement OR Opportunit_commerciale__r.Type_pers__c =: Label.PV_Evolution)
                                                            AND(Opportunit_commerciale__r.ContratOrigine__c != null)];

        //get the contract ids and the old budget ids
        for(Fiche_de_synthese__c thisFiche : ListFichesAvecParents) {
            SetContratIds.add(thisFiche.Opportunit_commerciale__r.ContratOrigine__c);//fill the sets SetContratIds
            if(thisFiche.Opportunit_commerciale__r.tech_Budget__c != null) {
                //if tech_Budget__c existe on opp, we get the budget of the previous year for Budget_Realise__c
                Integer anneeBudget = Integer.valueOf(thisFiche.Opportunit_commerciale__r.tech_Budget__r.AnneeBudget__c);
                mapOppIdAnneeBudgetRealise.put(thisFiche.Opportunit_commerciale__c, String.valueOf(anneeBudget - 1));
            }
        }

        if(SetContratIds != null) {
            //get the budgets that are related to our contracts
            ListBudgets = [SELECT id, AnneeBudget__c, NomContrat__c
                           FROM Budget__c
                           where NomContrat__c in: SetContratIds
                           or id not in: SetDeletedBudgetIds];

            //map contrat Id to list of related budget
            Map<String, List<Budget__c>> mapcontratIdBudget = new Map<String, List<Budget__c>>();
            if(ListBudgets != null) {
                for(Budget__c theBudget : ListBudgets) {
                    if(!mapcontratIdBudget.containsKey(theBudget.NomContrat__c)) {
                        mapcontratIdBudget.put(theBudget.NomContrat__c, new List<Budget__c>());
                    }
                    mapcontratIdBudget.get(theBudget.NomContrat__c).add(theBudget);
                }
            }
            // loop on the ListFichesAvecParents
            for(Fiche_de_synthese__c theFiche : ListFichesAvecParents) {

                //to check if we need to update the budget fields on the fds because the value has changed or is empty to avoid updating unchaged fds
                Boolean updateBudget = false;
                Boolean updateBudgetRealise = false;

                //Budget__c = tech_Budget__c
                //we copy the budget from the opp
                if(theFiche.Budget__c != theFiche.Opportunit_commerciale__r.tech_Budget__c) {
                    theFiche.Budget__c = theFiche.Opportunit_commerciale__r.tech_Budget__c;
                    updateBudget = true;
                }
                if(mapcontratIdBudget.containsKey(theFiche.Opportunit_commerciale__r.ContratOrigine__c)) {
                    for(Budget__c contratBudget : mapcontratIdBudget.get(theFiche.Opportunit_commerciale__r.ContratOrigine__c)) {
                        //Budget_Realise__c = budget of year-1
                        if(contratBudget.AnneeBudget__c == mapOppIdAnneeBudgetRealise.get(theFiche.Opportunit_commerciale__c)) {
                            if(theFiche.Budget_Realise__c != contratBudget.Id) {
                                theFiche.Budget_Realise__c = contratBudget.Id;
                                updateBudgetRealise = true;
                            } else {
                                updateBudgetRealise = false;
                            }
                            break;
                        } else {
                            //if we don't have the previous budget, we empty the field
                            if(theFiche.Budget_Realise__c != null) {
                                theFiche.Budget_Realise__c = null;
                                updateBudgetRealise = true;
                            } else {
                                updateBudgetRealise = false;
                            }
                        }
                    }
                } else {
                    //if we don't have the previous budget, we empty the field
                    if(theFiche.Budget_Realise__c != null) {
                        theFiche.Budget_Realise__c = null;
                        updateBudgetRealise = true;
                    } else {
                        updateBudgetRealise = false;
                    }
                }

                if(updateBudget || updateBudgetRealise) {
                    ListFichesToUpdate.add(theFiche);
                }
            }
            if(ListFichesToUpdate.size() > 0) {
                update ListFichesToUpdate;//update fiche de synthese
            }

        }
    }
}