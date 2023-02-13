/**
* @author Alain Ghoussoub -EI Technologies
* @date 28/08/2020
* @description Test Class for Batch88_OpportunitePrestation
*/ 
@isTest
public class Batch88_OpportunitePrestation_Test {
    @isTest
    static void testPrestation() {
        
        Account myaccount=testUtils.createAccount('testAccount2', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp1.AccountId=myaccount.Id;
        myOpp1.closeDate=Date.today();
        myOpp1.statut__c =Label.Opp_StatutEnCours;
        myOpp1.Amount=3;
        myOpp1.EstOpportuniteMere__c = true;
        myOpp1.NatureOpportunitMere__c = Label.AP16_National;
        myOpp1.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        myOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        insert myOpp1;
        
        Contrat__c cont = new Contrat__c(name='Contrat');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.EstContratcadre__c = true;
        insert cont;
        
        Opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp2.AccountId=myaccount.Id;
        myOpp2.closeDate=Date.today();
        myOpp2.statut__c =Label.Opp_StatutEnCours;
        myOpp2.Contrat_Genere_lookup__c = cont.id;
        myOpp2.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        myOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        
        Opportunity myOpp3 = testUtils.createOpportunity ('testOpp2', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp3.AccountId=myaccount.Id;
        myOpp3.closeDate=Date.today();
        myOpp3.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        myOpp3.ContratOrigine__c = cont.id;
        myOpp3.OpportuniteMere__c = myOpp1.id;
        myOpp3.NatureOpportunitMere__c = Label.AP16_National;
        myOpp3.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        
        opportunity myOpp4 = testUtils.createOpportunity ('testOpp2', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp4.accountId=myaccount.Id;
        myOpp4.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp4.Type_pers__c = Label.Renouvellement;
        myOpp4.CreerNouveauProjetCommercial__c = false;
        myOpp4.Contrat_Genere_lookup__c = cont.id;
        myOpp4.ContratOrigine__c = cont.id;
        insert new List<opportunity> {myOpp2,myOpp3,myOpp4};
            
            Test.startTest();            
        Id batchJobId = Database.executeBatch(new Batch88_OpportunitePrestation(), 2000);
        Test.stopTest();
    }
}