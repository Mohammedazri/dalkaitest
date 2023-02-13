/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Apex trigger EcosystemePartenaireBeforeDelete
Test Class: AP26_DeleteEcosystem_Test 
History
<Date>      <Authors Name>     <Brief Description of Change>
22/06/2018   Johny Kassis      Created
--------------------------------------------------------------------------------------------------------------------------*/
trigger EcosystemePartenaireBeforeDelete on EcosystemePartenaire__c (before delete) 
{
    //this function takes the list of the deleted EcosystemePartenaire__c and deletes the related antagonist EcosystemePartenaire__c
   if(PAD.CanTrigger('AP26_DeleteEcosystem'))
   {
       AP26_DeleteEcosystem.DeleteRepresenteDe(trigger.old);
   }
    
    //cal method to check if parent contract is closed
    if(PAD.CanTrigger('AP77_ContratFerme')){
        AP77_ContratFerme.checkIfCanDeleteEcosystemes(Trigger.oldmap);
    }
      
}