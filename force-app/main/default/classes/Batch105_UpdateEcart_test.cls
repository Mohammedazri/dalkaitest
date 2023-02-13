/** 
* @author Jacques Akiki 
* @date 02/12/2020 
* @Test Class for Batch105_UpdateEcart
*/
@isTest
public class Batch105_UpdateEcart_test {
    @isTest
    static void testBatch105()
    {
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = label.WS11_OUV;
        insert myaccount;
        
        Contrat__c cont1 = new Contrat__c(name='Contrat1');
        cont1.NomPartenaire__c = myaccount.Id; 
        insert cont1;
        
        Budget__c budgt = new Budget__c(Name='Test');
        budgt.AnneeBudget__c = '2020';
        budgt.BudgetNP1AchatsAutresEnergies__c = 10;
        budgt.BudgetNP2Electricite__c = 20;
        budgt.NomContrat__c = cont1.id;
        insert budgt;
        
        Opportunity myOpp1 = testUtils.createOpportunity ('TESTOPP1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.AccountId=myaccount.Id;
        myOpp1.closeDate=Date.today();
        myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp1.Type_pers__c=Label.Renouvellement;
        myOpp1.Annee_de_signature__c = '2019';
        myOpp1.Tech_CdtRefSelectionnee__c = null;
        myOpp1.tech_Budget__c = budgt.id;
        insert myOpp1;
        
        /*Fiche_de_synthese__c fds = new Fiche_de_synthese__c();
        fds.name = 'TEST';
        fds.Opportunit_commerciale__c = myOpp1.id;
        fds.Budget__c = budgt.id;
        insert fds;*/
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
        
        for(Fiche_de_synthese__c fds:listFDS){
            fds.SaisieRefP1VentesServices__c=12;
            fds.OffreA1P1VentesServices__c=13;
            fds.Budget__c = budgt.id;
        }
        Update listFDS;
        
        Id BatchId = Database.executeBatch(new Batch105_UpdateEcart());
        
    }
}