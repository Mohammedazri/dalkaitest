/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: Apex trigger LeadAfterUpdate
Test Class: AP20_LeadConversion_Test
History
<Date>      <Authors Name>  	 <Brief Description of Change>
23-03-2018   Christine Bayssary  Created
06-07-2018   Johny Kassis        Added the Function AP27_LeadConversionSiret.checkSIRETandAddError
--------------------------------------------------------------------------------------------------------------------------*/
trigger LeadAfterUpdate on Lead (after update) {
    
    // sets the field Contact_du_partenaire__c on the converted opportunity when converting a lead
    if(PAD.canTrigger('AP20_LeadConversion'))
    {
        AP20_LeadConversion.updateOpportunityContact(trigger.new);
    }
    
    //Add error to the record lead if the Siret id not valid or if the Siret is empty
    if(PAD.canTrigger('AP27_LeadConversionSiret'))
    {
        AP27_LeadConversionSiret.checkSIRETandAddError(trigger.new);
    }
}