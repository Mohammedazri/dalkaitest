/**
* This class contains unit tests for validating the behavior of the batch Batch19_UpdateConditionRefOpp
* Coverage 100%
*/
@isTest
public class Batch19_UpdateConditionRefOpp_Test 
{
    @isTest
    static void  Batch19_UpdateConditionRefOpp_Test() 
    {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            //create Account
            account a1= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            //create Contrat__c
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            //create Budget__c
            Budget__c myBudget = testUtils.CreateBudget ('testBudget', '2017', c1.Id);
            myBudget.AnneeBudget__c='2018';
            myBudget.CABudgetP1__c=1;
            insert myBudget;
            //create Opportunity
            Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.tech_Budget__c = null;     
            myOpp.Annee_de_signature__c='2018';
            myOpp.Name='testOpp1';
            myOpp.Statut__c = 'En Cours';
            myOpp.Tech_CdtRefSelectionnee__c = 'Saisie manuelle (à justifier)';
            insert myOpp;
            
            Test.startTest(); 
            //Initialiazing and calling the batch
            Batch19_UpdateConditionRefOpp testBatch=new Batch19_UpdateConditionRefOpp();
            DataBase.executeBatch(testBatch);
            
            Test.stopTest();
        }
    }
    
    
}