/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki  
Company: EI-Technologies
Description: Trigger on Account Before insert
Test Class: AP42_Account_test
History
<Date>      <Authors Name>   <Brief Description of Change>
17/12/2018   Jacques AKiki      Creation
--------------------------------------------------------------------------------------------------------------------------*/
trigger AccountBeforeInsert on Account (before insert) {
    if (pad.canTrigger('AP42_Account'))
    {
        AP42_Account.UpdateVisionRelation(trigger.new);
    }
    if (pad.canTrigger('AP59_PostalCodeUOPilote'))
    {
        AP59_PostalCodeUOPilote.setFieldsFromPostalCode(trigger.new,null);
    }
    if (pad.canTrigger('AP73_DateDeclenchementWS'))
    {
        AP73_DateDeclenchementWS.updateDateDeclenchement(trigger.new);
    }
     
}