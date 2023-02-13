/*
* @Fonctionnalité: test Classe utilisée pour couvrir LC29_CreationOpportunite_Controller
* @Auteur: Johny Kassis
* @Date: 25/01/2018
* @Class: LC29_CreationOpportunite_Controller
*/
@isTest
public class LC29_CreationOpportunite_Controller_Test 
{
    @isTest
    static void  testController()
    {
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.Type_pers__c = Label.Renouvellement;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            insert myOpp;
            
            String test1=LC29_CreationOpportunite_Controller.handler(myOpp.id,true);
            String test2=LC29_CreationOpportunite_Controller.handler(myOpp.id,false);
            
            boolean lStage= LC29_CreationOpportunite_Controller.isSave(myOpp.id);   
        }
        
        Test.stopTest();
    }
    
}