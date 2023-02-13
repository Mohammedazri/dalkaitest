/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EIT Mena
Description: Apex trigger CaseBeforeDelete
History
<Date> 		<Authors Name> 		<Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger CaseBeforeDelete on Case (before delete) {

    //check if can delete case
    if(PAD.CanTrigger('AP117_Case')){
        AP117_Case.checkIfCanDeleteCase(trigger.old);
    }
}