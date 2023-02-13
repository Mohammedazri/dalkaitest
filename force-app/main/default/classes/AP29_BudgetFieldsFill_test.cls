@istest
public class AP29_BudgetFieldsFill_test {
    
    @isTest
    static void AP29_TestMethod() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c=Label.LC30_TEST_CodeRegion;
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            //create and insert Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            
            //create and insert Contract
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.Annee_de_signature__c='2017';
            insert myOpp;
            
            //create Fiche_de_synthese__c
            //Sprint 31: Commented by Jimmy US C360-717
           /* Fiche_de_synthese__c Fiche1= New Fiche_de_synthese__c();
            Fiche1.Name='testFiche1';
            Fiche1.Opportunit_commerciale__c=myOpp.Id;
            Fiche1.P6MbOf__c=12;*/
            Test.startTest();
            //Create Budget
            Budget__c Budg1 = testUtils.CreateBudget ('testBudget', '2016', c1.Id);
            Budg1.BudgetNP1VentesServices__c=10;
            Budg1.BudgetNP2VentesServices__c=20;
            Budg1.BudgetNP3VentesServices__c=30;
            Budg1.BudgetNP4VentesServices__c=40;
            Budg1.BudgetNP6VentesServices__c=50;
            Budg1.BudgetNP1MargeBrute__c=60;
            Budg1.BudgetNP2MargeBrute__c=70;
            Budg1.BudgetNP3MargeBrute__c=80;
            Budg1.BudgetNP4MargeBrute__c=90;
            Budg1.BudgetNP6MargeBrute__c=100;
            Budg1.CABudgetP1__c = 1;
            Budg1.CABudgetP2__c= 2;
            Budg1.CABudgetP3__c = 3;
            Budg1.CABudgetP4__c = 4;
            Budg1.CABudgetP6__c = 5;
            Budg1.MBBudgetP1__c = 6;
            Budg1.MBBudgetP2__c = 7;
            Budg1.MBBudgetP3__c = 8;
            Budg1.MBBudgetP4__c = 9;
            Budg1.MBBudgetP6__c = 10;
            
            insert Budg1;
            Budg1 = [Select ID , CABudgetP1__c, BudgetNP1VentesServices__c
                     from Budget__c 
                     where Id = :Budg1.Id
                     Limit 1]; 
            System.assertEquals(Budg1.CABudgetP1__c,Budg1.BudgetNP1VentesServices__c,'Big ERROR');
            Budg1.MBBudgetP6__c = 150;
            update Budg1;
            Budg1 = [Select ID , MBBudgetP6__c, BudgetNP6MargeBrute__c
                     from Budget__c 
                     where Id = :Budg1.Id
                     Limit 1];   
            //System.assertEquals(Budg1.MBBudgetP6__c, Budg1.BudgetNP6MargeBrute__c,'Big ERROR1');
            Test.stopTest();
        }
        
        
    }
    
}