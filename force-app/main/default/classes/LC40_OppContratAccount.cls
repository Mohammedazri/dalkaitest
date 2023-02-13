/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: Apex controller for the lightning component LC40_GridView et LC40_OppContratsOnAccount
responsible of showing a list of the Opportunities and contracts related to an account.
Test Class: LC40_OppContratAccount_test
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC40_OppContratAccount {
    
    /*Query all opportunities related to Account*/
    private static List<Opportunity> getOpportunity (String AccId)
    {
        List <Opportunity> ListOpp = [SELECT id, name , NumeroOpportunite__c, StageName , techOwner__c , techagenceName__c , Libelle_Region__c     
                                      FROM Opportunity  
                                      WHERE StageName<>:Label.PV_Realisation AND AccountId =:AccId AND OpportuniteMere__c = null];
        return  ListOpp ; 
    }
    
    /*Query all Contrats related to Account*/
    private static List<Contrat__c> getContrat (String AccId)
    {
        
        List <Contrat__c> ListCont = [SELECT id, name , NumeroContrat__c, NomPartenaire__c , toLabel(Statut__c), techOwner__c ,Nom_d_Agence__c , LibelleRegion__c     
                                      FROM Contrat__c  
                                      WHERE Statut__c<>:Label.ContratFerme  AND NomPartenaire__c =:AccId AND ContratCadre__c = null];
        
        return  ListCont ; 
    }
    
    @AuraEnabled
    public static ListOppContWrapper getOppCont (String AccId )
    {
        ListOppContWrapper LOCW = new ListOppContWrapper();
        LOCW.ListOpp = getOpportunity(AccId);
        LOCW.listCont = getContrat(AccId);
        return LOCW;
    }
    
    public class ListOppContWrapper
    {
        @AuraEnabled public List<Opportunity> listOpp {get ; set;}
        @AuraEnabled public List <Contrat__c> listCont {get ; set;}
    }
}