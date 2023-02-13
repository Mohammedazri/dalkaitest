/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Apex trigger LeadBeforeUpdate
Test Class: AP27_LeadConversionSiret_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
09-07-2018   Johny Kassis        Created
11/10/2018	 Jacques AKiki		Added function AP36
--------------------------------------------------------------------------------------------------------------------------*/
trigger LeadBeforeUpdate  on Lead (before update) 
{
    List<Lead>LeadList = new list<Lead>();
    for (Lead l : trigger.new)
    {
        if (l.LeadSource != 'Explore')
        {
            LeadList.add(l);//ajouté par jacques Akiki 12/04 (Suivre Trigger LeadBeforeInsert) Bug WS
        }
    }
    
    //check if the siret is empty or not valid and update the lead 
   if(PAD.canTrigger('AP27_LeadConversionSiret') && LeadList.size()>0)
    {
        AP27_LeadConversionSiret.updateOpportunityContact(trigger.new, trigger.oldmap);
    }
    if(PAD.CanTrigger('AP36_UperCase')) 
    {
        //AP36_UperCase.ModifyToUpper('Lead',trigger.new);
    }
}