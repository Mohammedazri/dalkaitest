/**
 * Wrapper for lwc06 to pass ContratShare members to Component
 */
public class WrapperContratShare {
    @AuraEnabled
    public String photoURL {get; set;}
    @AuraEnabled
    public String UserName {get; set;}
    @AuraEnabled
    public String UserAccess {get; set;}
    @AuraEnabled
    public String UserId {get; set;}
    @AuraEnabled
    public String csId {get; set;}
    @AuraEnabled
    public Boolean notdeleteable {get; set;}
    @AuraEnabled
    public Boolean cancreate {get; set;}
}