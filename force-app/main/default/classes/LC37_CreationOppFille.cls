/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Apex controller for the lightning component LC37_CreerOpportuniteFille  responsible of creating "des opportunités filles"
related to the "Opportunité mère" that created the contrat upon Realisation
Test Class: LC37_CreationOppFille_test
-------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC37_CreationOppFille {
    
    @AuraEnabled
    public static String getCurrentObject(Id OppId){
        Opportunity myOpp=[SELECT id,EstOpportuniteMere__c,OpportuniteMere__c,NatureOpportunitMere__c,Type_pers__c,Statut__c,stageName
                           FROM Opportunity
                           Where id=:OppId
                           LIMIT 1];
        //14-04-2022 Modified by JKH check if it's only a Opp mere (US C360-250 Sprint 28)
        if (myOpp.EstOpportuniteMere__c == true)
        {
            return 'Oui';  
        }
        else
        {
            return 'Non' ;    
        }
    }
    @AuraEnabled
    public static Opportunity getOpp(Id OppId){
        
        Opportunity Opp=[SELECT id,name
                         FROM Opportunity
                         Where id=:OppId
                         LIMIT 1];
        return Opp;    
    }
    
    @AuraEnabled
    public static String CreateOpportunity(Opportunity opp,Id OppId)
    {
        Opportunity oppMere = [SELECT id,name,Societevente__c, ProjetCommercial__c,NatureOpportunitMere__c,AccountId
                               FROM Opportunity 
                               WHERE id=:OppId limit 1];
        opp.OpportuniteMere__c = oppMere.id;
        opp.OwnerId=UserInfo.getUserId();//Cont.OwnerID;
        opp.AccountId=oppMere.AccountId;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        opp.Type_pers__c = Label.LC78_Nouveau; // CKH US290 - 06/10/2021
        opp.Statut__c = Label.OpportunityStatusEnCours;
        opp.ProjetCommercial__c = oppMere.ProjetCommercial__c;
        opp.NatureOpportunitMere__c = oppMere.NatureOpportunitMere__c;
        opp.Societevente__c = oppMere.Societevente__c;
        
        try
        {
            insert(opp);
            return opp.id;
        }
        catch(System.DMLException e)
        { 
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static list<WRP01_MenuPickList> GetStagesPicklist()
    {
        system.debug('test stages');
        List<WRP01_MenuPickList> StagesList= new List<WRP01_MenuPickList>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            StagesList.add(new WRP01_MenuPickList(f.getLabel(), f.getValue()));
        }   
        system.debug(StagesList);
        return StagesList;
    }
    
    @AuraEnabled
    public static list<WRP01_MenuPickList> GetMoisPicklist()
    {
        system.debug('test trimestre');
        List<WRP01_MenuPickList> MoisList= new List<WRP01_MenuPickList>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Moisdesignature__c .getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            MoisList.add(new WRP01_MenuPickList(f.getLabel(), f.getValue()));
        }   
        system.debug(MoisList);
        return MoisList;
    }
    @AuraEnabled
    public static list<WRP01_MenuPickList> GetAnneePicklist()
    {
        List<WRP01_MenuPickList> TrimestresList= new List<WRP01_MenuPickList>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Annee_de_signature__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            TrimestresList.add(new WRP01_MenuPickList(f.getLabel(), f.getValue()));
        }   
        system.debug(TrimestresList);
        return TrimestresList;
    }
    
    public class WRP01_MenuPickList {
        
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        
        public WRP01_MenuPickList(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}