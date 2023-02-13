/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used by the Lightning controller LC06_PlanAction_Controller and the lightning component LC06_PlanAction 
             and it aims to store the task or event related to the account and their information
Test Class: -
--------------------------------------------------------------------------------------------------------------------------*/
public class WrapperPlan_d_actions {
    
    @AuraEnabled
    public Sobject TheTaskEvent{get;set;}
    @AuraEnabled
    public string status{get;set;}
    @AuraEnabled
    public boolean NonAcheve{get;set;}
    @AuraEnabled
    public string Type{get;set;}
    @AuraEnabled
    public string genre_comite{get;set;}  
    @AuraEnabled
    public boolean ifHighPriority{get;set;}
    @AuraEnabled
    public string Realise{get;set;}
}