/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Test Class for Batch11_OldValuesOnBudget_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@istest
public class Batch11_OldValuesOnBudget_Test {
    static testMethod void testUpdateBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        //u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            List<Budget__c> listBudg = new List<Budget__c>();
            
            Account myaccount = testUtils.createAccount('Acc_test' ,'BillingCountry_test', 'Privé');
            myaccount.Lieu_immatriculation_legale__c = 'test';
            Insert myaccount;
            List<contrat__c> listContrat = new List<contrat__c>();
            Contrat__c mycontrat1= new Contrat__c(Name='testContrat1');
            mycontrat1.NomPartenaire__c=myaccount.Id;	
            mycontrat1.ReconductionFaitAutorisee__c = true;
            listContrat.add(mycontrat1);
            Contrat__c mycontrat2= new Contrat__c(Name='testContrat2');
            mycontrat2.NomPartenaire__c=myaccount.Id;
            mycontrat2.ReconductionFaitAutorisee__c = true;
            listContrat.add(mycontrat2);
            Contrat__c mycontrat3= new Contrat__c(Name='testContrat3');
            mycontrat3.NomPartenaire__c=myaccount.Id;
            mycontrat3.ReconductionFaitAutorisee__c = true;
            listContrat.add(mycontrat3);
            insert listContrat;
            
            List<Budget__c> listBudget = new List<Budget__c>();
            Budget__c mybudget1 = new Budget__c();
            mybudget1.AnneeBudget__c = '2018';
            mybudget1.NomContrat__c = mycontrat1.Id;
            listBudget.add(myBudget1);
            
            mybudget1.CABudgetP1__c=1;
            mybudget1.BudgetNP1VentesServices__c=2;
            mybudget1.CABudgetP2__c=3;
            
            mybudget1.MBBudgetP2__c=4;
            mybudget1.BudgetNP2MargeBrute__c=5;
            
            Budget__c mybudget2 = new Budget__c();
            mybudget2.AnneeBudget__c = '2018';
            mybudget2.NomContrat__c = mycontrat2.Id;
            mybudget2.CABudgetP1__c=10;
            listBudget.add(myBudget2);
            
            Budget__c mybudget3 = new Budget__c();
            mybudget3.AnneeBudget__c = '2018';
            mybudget3.NomContrat__c = mycontrat3.Id;
            listBudget.add(myBudget3);
            
            insert listBudget;
            Test.startTest();
            Batch11_OldValuesOnBudget obj = new Batch11_OldValuesOnBudget();
            DataBase.executeBatch(obj);
            Test.stopTest();
            
        }
    }
}