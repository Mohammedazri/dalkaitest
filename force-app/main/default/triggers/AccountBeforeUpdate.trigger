/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki  
Company: EI-Technologies
Description: Trigger on Account Before Update 
Test calss: AP42_Account_test
History
<Date>      <Authors Name>   <Brief Description of Change>
17/12/2018   Jacques AKiki      Creation
--------------------------------------------------------------------------------------------------------------------------*/
trigger AccountBeforeUpdate on Account (before update) {
    if (pad.canTrigger('AP42_Account'))
    {
        AP42_Account.UpdateVisionRelation(trigger.new);
    }
    /* CKH - US455 - 06/21/2021
    AP45_AccountCallouts.updateUOPilote(trigger.new);
    */
    if (pad.canTrigger('AP59_PostalCodeUOPilote'))
    {
        AP59_PostalCodeUOPilote.setFieldsFromPostalCode(trigger.new,trigger.oldMap);
    }
    if (pad.canTrigger('AP73_DateDeclenchementWS'))
    {
        AP73_DateDeclenchementWS.updateDateDeclenchement(trigger.new);
    }
    if (pad.canTrigger('AP106_PartenaireInactif'))
    {
        List<Account> ListAP106 = new List<Account>();
        
        for(Account acc : trigger.new)
        {
            if(trigger.oldMap.get(acc.Id).StatutPartenaire__c != acc.StatutPartenaire__c && acc.StatutPartenaire__c == Label.Partenaire_FER && UserInfo.getUserName().contains('integration.webservice'))
            {
                ListAP106.add(acc);
            }
        }
        
        if(ListAP106.size() > 0)
        {
         	AP106_PartenaireInactif.sendEmail(ListAP106);
        }
    }
    
}