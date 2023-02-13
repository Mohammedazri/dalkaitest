public without sharing class LC24_crteRelationClientInt_Controller {
    @AuraEnabled
    public static string SaveRC(String newRCStr)
    {
        newRCStr = newRCStr.replace('[','');
        newRCStr = newRCStr.replace(']','');
        Contact_User__c newRC =(Contact_User__c)JSON.Deserialize(newRCStr,Contact_User__c.class); 
        system.debug('##newRC '+ newRC);
        
        string result;
        try{
            system.debug('-----------******************'+newRC);
            upsert newRC;
            result='SUCCESS';
            system.debug('result '+ result);
            return result;
        }
        catch(exception e)
        {
            system.debug('e.getMessage '+ e.getMessage());
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static string DeleteRelationInterne(String RelationId)
    {
        string result;
        try{
            delete new Contact_User__c(Id=RelationId);
            result='SUCCESS';
            system.debug('result '+ result);
            return result;
        }
        catch(exception e)
        {
            system.debug('e.getMessage '+ e.getMessage());
            return e.getMessage();
        }
    }
}