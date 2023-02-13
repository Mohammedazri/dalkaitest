/*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Mattar 
Company: EI-Technologies
Description: This class contains unit tests for validating the behavior of Apex classes AP32_ChangeInLabelAgence
Test Class: AP32_ChangeInLabelAgence_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
30/08/2018   Rita Mattar      Creation of the test class
--------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class AP32_ChangeInLabelAgence_Test {
    @isTest
    
    static void testUser(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c=true;
        //u2.Nom_agence__c = 'AGENCE COMMERCIALE POITOU CHARENTES';
        insert u2;
        Agence__c Ag = new Agence__c();
        Ag.Name = 'test';
        insert Ag;
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            insert a1;
            
            set<id> setOwnerId = new set<Id>();
            setOwnerId.add(u2.Id);
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.Type_pers__c='Nouveau';
            myOpp.tech_Budget__c = null;
            myOpp.Annee_de_signature__c='2017';
            

            Test.startTest();
            insert myOpp;
            myOpp = [Select id,name//,Libelle_Agence__c
                     From Opportunity
                     Where id=:myOpp.id];
            //myOpp.Agence_Rattachement__c = Ag.id;
            update myOpp;
            Test.stopTest();
        }
    }
}