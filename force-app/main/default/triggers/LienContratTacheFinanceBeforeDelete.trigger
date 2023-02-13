/** 
* @author Dona Kfoury
* @date 19/2/2020 
* @description trigger before delete lien contrat tache finance
* @Test class: AP77_ContratFerme_Test
*/
trigger LienContratTacheFinanceBeforeDelete on LienContratTacheFinance__c (before delete) {
    //cal method to check if parent contract is closed
    if(PAD.CanTrigger('AP77_ContratFerme')){
        AP77_ContratFerme.checkIfCanDeleteLienContratTache(Trigger.oldmap);
    }
}