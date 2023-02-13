/**
* @author Jacques Akiki -EI Technologies
* @date 09/07/2019
* @description Test Class for Batch Batch49_VolumeHorsPDAEtQualite
*/
@istest
public class Batch49_VolumeHorsPDAEtQualite_test {
    
    @isTest
    static void Batch49_TestMethod() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c=Label.LC30_TEST_CodeRegion;
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            List <Account> listAcc = new List<Account>();
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            a1.Total_CA_Budget_P1_P2_P3_P4__c=0;
            listAcc.add(a1);
            insert listAcc;

            list<Opportunity> listopp = new list<opportunity>();
            opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(); 
            myOpp1.Type_pers__c=Label.Renouvellement;
            myOpp1.AccountId = a1.id;
            listopp.add(myOpp1);
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(); 
            myOpp2.Type_pers__c=Label.Renouvellement;
            myOpp2.AccountId = a1.id;
            listopp.add(myOpp2);
            insert listopp;
            
            List<Contrat__c> listContrat = new List<Contrat__c>();
            Contrat__c c1= new Contrat__c();
            c1.Name ='test1';
            c1.NomPartenaire__c=a1.Id;
            //c1.represente_par__c = null;
            c1.OpportuniteCommerciale__c=myOpp1.id;
            listContrat.add(c1);
            Contrat__c c2= new Contrat__c();
            c2.Name ='test2';
            c2.NomPartenaire__c=a1.Id;
            //c2.represente_par__c = null;
            c2.OpportuniteCommerciale__c=myOpp2.id;
            c2.Statut__c='OUV';
            listContrat.add(c2);
            insert listContrat;
            
            List<Budget__c> listBudg = new List<Budget__c>();
            Budget__c Budg1 = testUtils.CreateBudget ('testBudget1', '2016', c1.Id);
            Budg1.BudgetNP1VentesServices__c=10;
            Budg1.BudgetNP2VentesServices__c=20;
            listBudg.add(Budg1);
            Budget__c Budg2 = testUtils.CreateBudget ('testBudget2', '2016', c2.Id);
            Budg2.BudgetNP1VentesServices__c=20;
            Budg2.BudgetNP2VentesServices__c=25;
            listBudg.add(Budg2);
            Budget__c Budg3 = testUtils.CreateBudget ('testBudget3', '2017', c2.Id);
            Budg3.BudgetNP1VentesServices__c=10;
            Budg3.BudgetNP2VentesServices__c=7;
            listBudg.add(Budg3);
            String accId = a1.id;
            
            Test.startTest();
            insert listBudg; 
            Id BatchId = Database.executeBatch(new Batch49_VolumeHorsPDAEtQualite(' where id=\''+accId+'\''));
            Test.stopTest();
        }
        
        
    }
    
}