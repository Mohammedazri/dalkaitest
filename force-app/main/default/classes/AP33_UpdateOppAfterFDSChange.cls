/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: Update the values of the fields Tech_CA_Ecart__c and Tech_Marge_Brute_Ecart__c on Opportunity after changing the Budget related to the FDS. 
Test Class: AP33_UpdateOppAfterFDSChange_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
18/09/2018  Jacques Akiki     Creation
--------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------
Author: Jacques AKiki 
Company: EI-Technologies
Description: Update the values of the fields Tech_CA_Ecart__c and Tech_Marge_Brute_Ecart__c on Opportunity after changing the Budget related to the FDS.
Inputs: List FDS
Returns: --
Updated on 28/09/2018
----------------------------------------------------------------------------------------------------------------------------*/  

public class AP33_UpdateOppAfterFDSChange 
{
    public static void UpdateValues (list<fiche_de_synthese__c> listnew)
    {
        Set<id> setfdsId = new Set<id>(); 
        List<opportunity> listOpp = new List<opportunity>();
        List<opportunity> listOppUpdate = new List<Opportunity>();
        Map<id,fiche_de_synthese__c> mapOppFDS = new Map<id,fiche_de_synthese__c>();
        
        for (Fiche_de_synthese__c fds:listnew)
        { 
                setfdsId.add(fds.id);   
        }
        system.Debug('SET OF FDS ID: ' + setfdsId);
        if (setfdsId!=NULL&&setfdsId.size()>0)
        {
            list<fiche_de_synthese__c> listFDS = new list<fiche_de_synthese__c>();
            listFDS = [SELECT Opportunit_commerciale__r.id, BudgetNSousTotP1234CaEcart__c, BudgetNSousTotP1234MbEcart__c , RealiseNMoins1SousTotP1234CaEcart__c, 
                       RealiseNMoins1SousTotP1234MbEcart__c, EcartMainOeuvreDontNbHeureP2__c
                       FROM fiche_de_synthese__c
                       WHERE id in:setfdsId];
            system.Debug('LIST FDS : ' + listFDS);
            set<id> SetOppId = new set<id>();
            for(Fiche_de_synthese__c fds:listFDS)
            {
                SetOppId.add(fds.Opportunit_commerciale__r.id);
            }
            if (setfdsId!=NULL && setfdsId.size()>0)
            {
                listOpp=[SELECT id,name,Tech_CdtRefSelectionnee__c,Tech_CA_Ecart__c,Tech_Marge_Brute_Ecart__c,ZZZ_Tech_Heures_P2_Ecart__c 
                         FROM Opportunity
                         WHERE id in:SetOppId];
            }
            system.Debug('LIST OPP : ' + listOpp);
            for(Opportunity opp:listOpp)
            {
                for (fiche_de_synthese__c fds:listFDS)
                { 
                    if(fds.Opportunit_commerciale__r.id == opp.id)
                    { 
                        mapOppFDS.put(opp.id,fds);
                    }
                }
            }
            
            for(Opportunity opp : listOpp)
            {
                if (opp.Tech_CdtRefSelectionnee__c=='Budget')
                {
                    if (mapOppFDS.containsKey(opp.id))
                    {
                        opp.Tech_CA_Ecart__c = mapOppFDS.get(opp.id).BudgetNSousTotP1234CaEcart__c;
                        opp.Tech_Marge_Brute_Ecart__c= mapOppFDS.get(opp.id).BudgetNSousTotP1234MbEcart__c;
                        opp.ZZZ_Tech_Heures_P2_Ecart__c = mapOppFDS.get(opp.id).EcartMainOeuvreDontNbHeureP2__c;
                        listOppUpdate.add(opp);
                    }
                }
                 if (opp.Tech_CdtRefSelectionnee__c=='Réalisé N-1')
                {
                    if (mapOppFDS.containsKey(opp.id))
                    {
                        opp.Tech_CA_Ecart__c = mapOppFDS.get(opp.id).RealiseNMoins1SousTotP1234CaEcart__c;
                        opp.Tech_Marge_Brute_Ecart__c= mapOppFDS.get(opp.id).RealiseNMoins1SousTotP1234MbEcart__c;
                        opp.ZZZ_Tech_Heures_P2_Ecart__c = mapOppFDS.get(opp.id).EcartMainOeuvreDontNbHeureP2__c;
                        listOppUpdate.add(opp);
                    }
                }
                
            }
            System.Debug('LIST TO UPDATE: ' + listOppUpdate);
            if (listOppUpdate!=NULL && listOppUpdate.size()>0)
            {
                Update listOppUpdate;
            }
        }   
    }
}