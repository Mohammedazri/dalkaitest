/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Test Class for LC65_NewContractTeamMember_Controller
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class LC65_Controller_Test {
@isTest
    static void CreateTeamMemberTest() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u1 = testUtils.CreateUser('stan82', 'user211121@testorg2.com', 'Testing22', p.Id, 'user2rr2r@testorg2.com');
        u1.BypassValidationRules__c=true;
        u1.Bypass_Workflow__c = true;
        u1.BypassProcessBuilder__c = true;
        u1.BypassFilters__c = true;
        u1.Statut__c = 'OUV';
        u1.DkCode__c='123';
        insert u1;
        
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        
        system.runAs(u1){
            Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.AccountId=myaccount.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.Amount=3;
            myOpp1.statut__c ='En cours';
            insert myOpp1;
            
            Contrat__c cont1 = new Contrat__c(name='Contrat1');
            cont1.NomPartenaire__c = myaccount.Id; 
            cont1.OpportuniteCommerciale__c = myOpp1.id;
            cont1.EstContratcadre__c = true;
            cont1.OwnerId = u1.id;
            cont1.EstContratcadre__c = true;
            insert cont1;
            Test.startTest(); 
            LC65_NewContractTeamMember_Controller.getContractName(cont1.Name);
            string memberId = LC65_NewContractTeamMember_Controller.createContractMember(u1.Id,cont1.id,'');
            LC65_NewContractTeamMember_Controller.getUsersWrp(u1.LastName);
            LC65_NewContractTeamMember_Controller.getContractMember(memberId);
            LC65_NewContractTeamMember_Controller.editContractMember(u1.Id,cont1.id,'',memberId);
            Test.stopTest();
        }
    }
}