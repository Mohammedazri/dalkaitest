/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description:  class responsible of doing a correspondence between contract fields and the fields of the related "Fiche de synthese"
Test Class: AP04_Contrat_Test   
--------------------------------------------------------------------------------------------------------------------------*/
public class AP04_Contrat {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function fill the values of the contract field using the fields of the related "Fiche de synthese"
Inputs: list of Contracts
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateContratFields(List<Contrat__c> ContratsList)
    {
        set<Id> OppsIds= New set<Id>();
        for(Contrat__c thisContrat:ContratsList)
        {
            OppsIds.add(thisContrat.OpportuniteCommerciale__c);
        }
       
        List<Fiche_de_synthese__c> ListFiche=[SELECT Opportunit_commerciale__c , P1CaOf__c, P2CaOf__c, P3CaOf__c, P4CaOf__c, P6CaOf__c, BklgHorsP6CaOf__c, BklgAvecP6CaOf__c, 
                                              P1MbOf__c, P2MbOf__c, P3MbOf__c, P4MbOf__c, P6MbOf__c, SousTotP1234MbOf__c, BklgHorsP6MbOf__c, BklgAvecP6MbOf__c,
                                              P1MbCaOf__c, P2MbCaOf__c, P3MbCaOf__c, P4MbCaOf__c, P6MbCaOf__c, BklgHorsP6MbCaOf__c,SousTotP1234MbCaOf__c, SousTotP1234CaOf__c,
                                              P1CaRef__c, P2CaRef__c, P3CaRef__c, P4CaRef__c, P6CaRef__c, SousTotP1234CaRef__c, BklgHorsP6CaRef__c, 
                                              P1MbRef__c, P2MbRef__c, P3MbRef__c, P4MbRef__c, P6MbRef__c, SousTotP1234MbRef__c, BklgHorsP6MbRef__c, 
                                              P1MbCaRef__c, P2MbCaRef__c, P3MbCaRef__c, P4MbCaRef__c, P6MbCaRef__c, SousTotP1234MbCaRef__c, BklgHorsP6MbCaRef__c, 
                                              P1CaEcart__c, P2CaEcart__c, P3CaEcart__c, P4CaEcart__c, P6CaEcart__c, SousTotP1234CaEcart__c, BklgHorsP6CaEcart__c, 
                                              P1MbEcart__c, P2MbEcart__c, P3MbEcart__c, P4MbEcart__c, P6MbEcart__c, SousTotP1234MbEcart__c, BklgHorsP6MbEcart__c,
                                              P1MbCaEcart__c, P2MbCaEcart__c, P3MbCaEcart__c, P4MbCaEcart__c, P6MbCaEcart__c, SousTotP1234MbCaEcart__c, BklgHorsP6MbCaEcart__c, 
                                              P1Energie__c, P2Services__c, P3GarantieTotale__c,  P4Financement__c, P6Travaux__c,SousTotP1234__c,BklgHorsP6__c, BklgAvecP6__c, ValorisationMainOeuvre__c,
                                              ConditionsDeReference__c, Investissements__c, DontInvestissementP4__c, DontInvestissement1ereAnnee__c
                                              FROM Fiche_de_synthese__c
                                              Where Opportunit_commerciale__c in:OppsIds];
        
        system.debug('ListFiche' + ListFiche);
        Map<Contrat__c, Fiche_de_synthese__c>MapContratWithFiche=new Map<Contrat__c, Fiche_de_synthese__c>();
        for(Contrat__c thisContrat:ContratsList)
        {
            for(Fiche_de_synthese__c thisFiche:ListFiche)
            {
                if(thisContrat.OpportuniteCommerciale__c==thisFiche.Opportunit_commerciale__c)
                {
                    MapContratWithFiche.put(thisContrat, thisFiche);
                }
            }
        }
        system.debug('##MapContratWithFiche' + MapContratWithFiche);
        for(Contrat__c thisContrat:ContratsList)
        {
            if(MapContratWithFiche.get(thisContrat)!= null)
            {   
               
                Fiche_de_synthese__c thisFiche=MapContratWithFiche.get(thisContrat);
               // thisContrat.P1CaOf__c=thisFiche.P1CaOf__c;
               // thisContrat.P2CaOf__c=thisFiche.P2CaOf__c;
               // thisContrat.P3CaOf__c=thisFiche.P3CaOf__c;
               // thisContrat.P4CaOf__c=thisFiche.P4CaOf__c;
               // thisContrat.P6CaOf__c=thisFiche.P6CaOf__c;
               // thisContrat.P1MbOf__c=thisFiche.P1MbOf__c;
               // thisContrat.P2MbOf__c=thisFiche.P2MbOf__c;
              //  thisContrat.P3MbOf__c=thisFiche.P3MbOf__c;
              //  thisContrat.P4MbOf__c=thisFiche.P4MbOf__c;
              //  thisContrat.P6MbOf__c=thisFiche.P6MbOf__c;
              //  thisContrat.P1CaRef__c=thisFiche.P1CaRef__c;
              //  thisContrat.P2CaRef__c=thisFiche.P2CaRef__c;
              //  thisContrat.P3CaRef__c=thisFiche.P3CaRef__c;
             //   thisContrat.P4CaRef__c=thisFiche.P4CaRef__c;
             //   thisContrat.P6CaRef__c=thisFiche.P6CaRef__c;
              //  thisContrat.P1MbRef__c=thisFiche.P1MbRef__c;
              //  thisContrat.P2MbRef__c=thisFiche.P2MbRef__c;
              //  thisContrat.P3MbRef__c=thisFiche.P3MbRef__c;
             //   thisContrat.P4MbRef__c=thisFiche.P4MbRef__c;
             //   thisContrat.P6MbRef__c=thisFiche.P6MbRef__c;
             //   thisContrat.P1Energie__c=thisFiche.P1Energie__c;
             //   thisContrat.P2Services__c=thisFiche.P2Services__c;
            //    thisContrat.P3GarantieTotale__c=thisFiche.P3GarantieTotale__c;
            //    thisContrat.P4Financement__c=thisFiche.P4Financement__c;
             //   thisContrat.P6Travaux__c=thisFiche.P6Travaux__c;
            //    thisContrat.SousTotP1234__c=thisFiche.SousTotP1234__c;
              //  thisContrat.BklgHorsP6__c=thisFiche.BklgHorsP6__c;
              //  thisContrat.BklgAvecP6__c=thisFiche.BklgAvecP6__c;
              //  thisContrat.ValorisationMainOeuvre__c=thisFiche.ValorisationMainOeuvre__c;
              //  thisContrat.ConditionsReference__c=thisFiche.ConditionsDeReference__c;
              //  thisContrat.Investissementskeuros__c=thisFiche.Investissements__c;
             //   thisContrat.dont_investissements_P4__c=thisFiche.DontInvestissementP4__c;
              //  thisContrat.dontInvestissement1ereAnn_e__c=thisFiche.DontInvestissement1ereAnnee__c;
            }
        }
    }
}