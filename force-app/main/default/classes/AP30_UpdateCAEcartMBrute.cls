/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: This class is related to the trigger OpportunitybeforeUpdate to recalculate the values of CA Ecart and Marge Brute based
on the condition de ref on FDS
Test Class: AP30_UpdateCAEcartMBrute_test 
History
--------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------
Author: Jacques AKiki 
Company: EI-Technologies
Description: Function used to update the values of Tech_CA_Ecart__c and Tech_Marge_Brute_Ecart__c on opportunity after the change of the 
picklist selection value on the FDS.
Inputs: List Opportunity
Returns: --
Added on 26/09/2018
----------------------------------------------------------------------------------------------------------------------------*/  
public class AP30_UpdateCAEcartMBrute {
    
    public static void UpdateCAEcart (List <Opportunity> listOpp)
    {
        set<id> SetId = new Set<Id>();
        Map<id,fiche_de_synthese__c> mapIdFds = new Map<id,fiche_de_synthese__c>();
        
        for( Opportunity opp : listOpp )
        {
            SetId.add(opp.Id);
        }
        if (SetId!=NULL&&SetId.size()>0)
        {
            List<Fiche_de_synthese__c> ListFDS = [SELECT id, Opportunit_commerciale__c, BudgetNSousTotP1234CaEcart__c,SaisieRefSousTotP1234CaEcart__c,
                                                  BudgetNSousTotP1234MbEcart__c,SaisieRefSousTotP1234MbEcart__c,EcartNbHP2SelonConditionReference__c
                                                  FROM Fiche_de_synthese__c
                                                  WHERE Opportunit_commerciale__c in: SetId ]; 
            if (ListFDS!=NULL&&ListFDS.size()>0)
            {
                for (fiche_de_synthese__c fds : ListFDS)
                {
                    
                    mapIdFds.put(fds.Opportunit_commerciale__c,fds);
                }
                for(Opportunity opp:listOpp)
                {
                    if(mapIdFds.containskey(opp.id))
                    {
                        if (opp.Tech_CdtRefSelectionnee__c==Label.LC12_Budget)
                        {
                            opp.Tech_CA_Ecart__c= mapIdFds.get(opp.id).BudgetNSousTotP1234CaEcart__c;
                            opp.Tech_Marge_Brute_Ecart__c=mapIdFds.get(opp.id).BudgetNSousTotP1234MbEcart__c;
                        }
                        
                        if (opp.Tech_CdtRefSelectionnee__c==Label.LC12_Saisie)
                        {
                            opp.Tech_CA_Ecart__c= mapIdFds.get(opp.id).SaisieRefSousTotP1234CaEcart__c;
                            opp.Tech_Marge_Brute_Ecart__c=mapIdFds.get(opp.id).SaisieRefSousTotP1234MbEcart__c;
                        }
                        
                        if(mapIdFds.get(opp.id).EcartNbHP2SelonConditionReference__c != null)
                        {
                            opp.ZZZ_Tech_Heures_P2_Ecart__c = mapIdFds.get(opp.id).EcartNbHP2SelonConditionReference__c;   
                        }
                    }
                }
            }
        }
    }
    /*----------------------------------------------------------------------------------------------------------------------------
Author: Jacques AKiki 
Company: EI-Technologies
Description: Function used to update the values of Tech_CA_Ecart__c and Tech_Marge_Brute_Ecart__c on opportunity based on the new values
calculated based on input changes in the FDS.
Inputs: List FDS
Returns: --
Added on 26/09/2018
----------------------------------------------------------------------------------------------------------------------------*/  
    public static void UpdateValues (List <Fiche_de_synthese__c> listFds)
    {
        List <opportunity> ListOppUpdate = new List <opportunity>();
        for (Fiche_de_synthese__c fds: listFds)
        { 
            Opportunity opp = new Opportunity(id=fds.Opportunit_commerciale__c);
            if (fds.ConditionsDeReference__c==Label.LC12_Budget)
            {
                opp.Tech_CA_Ecart__c = fds.BudgetNSousTotP1234CaEcart__c;
                opp.Tech_Marge_Brute_Ecart__c = fds.BudgetNSousTotP1234MbEcart__c;
                opp.ZZZ_Tech_Heures_P2_Ecart__c = fds.EcartNbHP2SelonConditionReference__c;
                ListOppUpdate.add(opp);
            }
            
            if (fds.ConditionsDeReference__c==Label.LC12_Saisie) 
            {
                opp.Tech_CA_Ecart__c = fds.SaisieRefSousTotP1234CaEcart__c;
                opp.Tech_Marge_Brute_Ecart__c = fds.SaisieRefSousTotP1234MbEcart__c;
                opp.ZZZ_Tech_Heures_P2_Ecart__c = fds.EcartNbHP2SelonConditionReference__c;
                ListOppUpdate.add(opp);
            }
        }
        if (ListOppUpdate!=NULL && ListOppUpdate.size()>0)
        {
            update ListOppUpdate;
        }
    }  
}