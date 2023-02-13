/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Classe test utilisé pour couvrir la classe AP24_OpportunityFDS
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP24_OpportunityFDS_Test 
{
    @isTest
    static void AP24_TestMethod() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c=Label.LC30_TEST_CodeRegion;
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.OwnerId=u2.id;
            myOpp.accountId=a1.Id;
            myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Opp_Type_Nouveau;
            insert myOpp;
            
            Test.startTest();
            
            //Sprint 31: Commented by Jimmy US C360-717
            /*fiche_de_synthese__c myFiche=new fiche_de_synthese__c();
            myFiche.Opportunit_commerciale__c=myOpp.Id;
            myFiche.Name='test1'; 
            insert myFiche;*/
            
            myOpp.name='test2';
            Update myOpp;
            Test.stopTest();
        }
    }
}