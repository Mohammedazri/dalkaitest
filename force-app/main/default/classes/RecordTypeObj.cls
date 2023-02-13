//return object record type
public class RecordTypeObj
{
    @AuraEnabled
    public string RTId;
    @AuraEnabled
    public string RTName;
    public RecordTypeObj(string RTName)
    {
        string x = '';
        if (RTName=='Indépendante')
        {
            x = 'Création';
        }
        else
        {
            x = RTName; 
        }
        this.RTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(x).getRecordTypeId();
        this.RTName = RTName;
    }
}