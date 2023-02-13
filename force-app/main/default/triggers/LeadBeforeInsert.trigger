/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Apex trigger LeadBeforeInsert
Test Class: AP27_LeadConversionSiret_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
09-07-2018   Johny Kassis        Created
11/10/2018   Jacques AKiki      Added function AP36
--------------------------------------------------------------------------------------------------------------------------*/
trigger LeadBeforeInsert on Lead (Before insert) 
{

    list<Lead> LeadList = new List<Lead>();
    for (Lead l : trigger.new)
    {
        if (l.LeadSource != 'Explore')
        {
            LeadList.add(l);//ajouté par jacques Akiki cf mail PJ 14/03 Bug WS
        }
    }
    
    //check if the siret is empty or not valid and update the lead 
   if(PAD.canTrigger('AP27_LeadConversionSiret') && LeadList.size()>0)
    {
        AP27_LeadConversionSiret.updateOpportunityContact(trigger.new, null);
    }
    if(PAD.CanTrigger('AP36_UperCase')) 
    {
        //AP36_UperCase.ModifyToUpper('Lead',trigger.new);
    }
}