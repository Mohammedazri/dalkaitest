/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis 
Company: EI-Technologies
Description: Test Class for AP19_LookUpContratAccount
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP19_LookUpContratAccount_Test 
{
    @istest
    static void testBudget()
    {
        Test.startTest(); 
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCESCOM2';
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        //PAD.PAD_BypassTrigger+=';AP45_Account;AP48_ContractCallouts';
        insert u2;
        
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            insert a1;
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            
           // c1.WFRelaiCAOffre__c =12;
           // c1.WFRelaiCAEcart__c =12;
            update c1;
            
            delete a1;
        }
    }
    
}