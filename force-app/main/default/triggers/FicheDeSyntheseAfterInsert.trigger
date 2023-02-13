/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: Trigger After Insert on the fiche_de_synthese__c object
Test Class: AP30_UpdateCAEcartMBrute_Test
--------------------------------------------------------------------------------------------------------------------------*/
trigger FicheDeSyntheseAfterInsert on Fiche_de_synthese__c (after insert) {
    if(PAD.CanTrigger('AP30_UpdateCAEcartMBrute'))
       {
           AP30_UpdateCAEcartMBrute.UpdateValues(trigger.new); 
       }
       
}