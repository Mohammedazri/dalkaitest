/**
* @author Alain Ghoussoub -EI Technologies
* @date 12/08/2020
* @description Test Class for Batch87_ContratOppCons
*/
@isTest
public class Batch87_ContratOppCons_TEST {
@isTest
    static void testPuisCons() {
        
        Account myaccount=testUtils.createAccount('testAccount2', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
        myOpp1.EstOpportuniteMere__c = true;
        myOpp1.NatureOpportunitMere__c = 'Réseau';
        myOpp1.PuissanceChaud__c = 2;
        myOpp1.PuissanceFroid__c = 3;
        myOpp1.ConsommationChaud__c =4;
        myOpp1.ConsommationFroid__c =5;
        myOpp1.AccountId=myaccount.Id;
        myOpp1.closeDate=Date.today();
        myOpp1.statut__c =Label.Opp_StatutEnCours;
        insert myOpp1;
        
        Contrat__c cont = new Contrat__c(name='Contrat');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.EstContratcadre__c = true;
        insert cont;
        
        Test.startTest();            
        Id batchJobId = Database.executeBatch(new Batch87_ContratOppCons(), 2000);
        Test.stopTest();
    }
}