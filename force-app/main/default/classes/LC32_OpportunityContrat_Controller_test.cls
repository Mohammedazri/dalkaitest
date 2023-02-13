/*
* @Fonctionnalité: test Class to cover the apex controller LC32_OpportunityContrat_Controller
* @Auteur: Johny Kassis
* @Date: 20/04/2018
* @Class: LC32_OpportunityContrat_Controller
*/
@isTest
public class LC32_OpportunityContrat_Controller_test 
{
    @isTest
    static void  testController()
    {
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.Code_d_Appartenance__c='OCESCOM2';
        insert u1;
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        System.runAs(u2) 
        {
            List<Objectif__c> ListObj2= new List<Objectif__c>();
            Objectif__c obj1=testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.valueof(System.Today().year()));
            obj1.Commercial__c=u2.Id;
            ListObj2.add(obj1);
            insert obj1;
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Opp_Type_Nouveau;
            insert myOpp;
            
            String msg=LC32_OpportunityContrat_Controller.Displaymessage(myOpp.id);
            String msg2=LC32_OpportunityContrat_Controller.changeTechField(myOpp.id);
        }
        
        Test.stopTest();
        
    }
    
}