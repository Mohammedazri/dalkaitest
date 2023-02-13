/**
* This class contains unit tests for validating the behavior of the batch Batch09_MAJ_TechPriorStageName
* Coverage 100%
*/
@isTest
public class Batch09_MAJ_TechPriorStageName_Test 
{
    @isTest
    static void  Batch09_MAJ_TechPriorStageNameTest() 
    {
        // query the profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        // create the user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.BypassValidationRules__c =true;//add bypass 
        insert u2;// insert the user
        
        // run test as the created user 
        System.runAs(u2) 
        {
            // Create an Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            
            // Create and insert Contrat
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            
            // Create an Opportunity 
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Statut__c = Label.LC35_Statut;
            myOpp.StageName = 'Réalisation';
            myOpp.Type_pers__c =Label.Renouvellement;
            myOpp.Annee_de_signature__c='2017';
            myOpp.ContratOrigine__c=c1.Id;
            insert myOpp;
            
            // Starting the tests
            Test.startTest(); 
            //Initialiazing and calling the batch
            Batch09_MAJ_TechPriorStageName testBatch=new Batch09_MAJ_TechPriorStageName();
            DataBase.executeBatch(testBatch);  
            
            Test.stopTest();
        }
    }
    
}