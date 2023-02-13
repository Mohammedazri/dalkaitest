/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Class used as an apex controller for the lightning component LC14_Contrat_ValorisationDeLOffre
Test Class: LC14_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
6/08/2018     Jacques Akiki		Commented unused fields in object Contrat__c
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC14_ContratValorisationOffre_Controller {
 /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: method that query and return the contract record and its fields using the given ID
Inputs: Id 
Returns: Contrat__c
----------------------------------------------------------------------------------------------------------------------------*/  
   
 
    
    @AuraEnabled
    public static Contrat__c getCurrentObject(Id ContratId){
        
        Contrat__c myContrat=[SELECT //P1CaOf__c, P2CaOf__c, P3CaOf__c, P4CaOf__c, P6CaOf__c, BklgHorsP6CaOf__c, BklgAvecP6CaOf__c, 
                                      //P1MbOf__c, P2MbOf__c, P3MbOf__c, P4MbOf__c, P6MbOf__c, SousTotP1234MbOf__c, BklgHorsP6MbOf__c, BklgAvecP6MbOf__c,
                                      //P1MbCaOf__c, P2MbCaOf__c, P3MbCaOf__c, P4MbCaOf__c, P6MbCaOf__c, BklgHorsP6MbCaOf__c, BklgAvecP6MbCaOf__c,SousTotP1234MbCaOf__c, SousTotP1234CaOf__c,
                                      //P1CaRef__c, P2CaRef__c, P3CaRef__c, P4CaRef__c, P6CaRef__c, SousTotP1234CaRef__c, BklgHorsP6CaRef__c, 
                                      //P1MbRef__c, P2MbRef__c, P3MbRef__c, P4MbRef__c, P6MbRef__c, SousTotP1234MbRef__c, BklgHorsP6MbRef__c, 
                                      //P1MbCaRef__c, P2MbCaRef__c, P3MbCaRef__c, P4MbCaRef__c, P6MbCaRef__c, SousTotP1234MbCaRef__c, BklgHorsP6MbCaRef__c, 
                                      //P1CaEcart__c, P2CaEcart__c, P3CaEcart__c, P4CaEcart__c, P6CaEcart__c, SousTotP1234CaEcart__c, BklgHorsP6CaEcart__c, 
                                      //P1MbEcart__c, P2MbEcart__c, P3MbEcart__c, P4MbEcart__c, P6MbEcart__c, SousTotP1234MbEcart__c, BklgHorsP6MbEcart__c,
                                      //P1MbCaEcart__c, P2MbCaEcart__c, P3MbCaEcart__c, P4MbCaEcart__c, P6MbCaEcart__c, SousTotP1234MbCaEcart__c, BklgHorsP6MbCaEcart__c, 
                                      //BklgAvecP6MbCaEcart__c, BklgAvecP6MbEcart__c, BklgAvecP6CaEcart__c, BklgAvecP6MbCaRef__c, BklgAvecP6MbRef__c, BklgAvecP6CaRef__c,        
                                      //P1Energie__c, P2Services__c, P3GarantieTotale__c,  P4Financement__c, P6Travaux__c,
                              		  //SousTotP1234__c, BklgHorsP6__c, BklgAvecP6__c, ValorisationMainOeuvre__c,toLabel(ValorisationMainOeuvre__c) VMO, 
                                      //ConditionsReference__c, toLabel(ConditionsReference__c) CDR, Investissementskeuros__c, dont_investissements_P4__c, dontInvestissement1ereAnn_e__c,
                                      Commentaire__c
                                     FROM Contrat__c
                                     Where id=:ContratId
                                     LIMIT 1];
        return myContrat;       
    }

}