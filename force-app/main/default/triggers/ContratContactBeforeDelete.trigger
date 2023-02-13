/** 
* @author Jacques AKiki
* @date 11/06/2020 
* @description trigger before delete ContratContact
* @Test class: AP77_ContratFerme_Test
*/
trigger ContratContactBeforeDelete on ContratContact__c (before delete) {
    if(PAD.CanTrigger('AP77_ContratFerme'))
    {
        AP77_ContratFerme.checkIfCanDeleteContactContrat(Trigger.oldmap);
    }
    
    if(PAD.CanTrigger('AP113_ContratContact'))
    {
        AP113_ContratContact.checkContactContratSize(trigger.old);
    }
}