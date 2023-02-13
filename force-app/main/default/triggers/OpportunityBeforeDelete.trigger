/** 
* @author Dona Kfoury
* @date 28/2/2020 
* @description trigger before delete Opportunity
* @Test class: AP77_ContratFerme_Test
*/
trigger OpportunityBeforeDelete on Opportunity (before delete) {
    //cal method to check if parent contract is closed
    if(PAD.CanTrigger('AP77_ContratFerme')){
        AP77_ContratFerme.checkIfCanDeleteOpportunity(Trigger.oldmap);
    }
}