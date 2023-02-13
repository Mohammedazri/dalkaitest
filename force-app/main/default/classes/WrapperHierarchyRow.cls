/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used by the Lightning controller LC10_Hierarchy_Controller and the lightning component LC10_Hierarchy 
Test Class: -
--------------------------------------------------------------------------------------------------------------------------*/
public class WrapperHierarchyRow {
    @AuraEnabled
    public string ObjectName;
    @AuraEnabled
    public string ObjectId;
    @AuraEnabled
    public string ObjectType;
    @AuraEnabled
    public list<WrapperHierarchyRow> listChildren;
    @AuraEnabled
    public Boolean isCurrent;
    @AuraEnabled
    public Boolean isParentOfCurrent;
    @AuraEnabled
    public string ExtraInfo; // extra info on account
}