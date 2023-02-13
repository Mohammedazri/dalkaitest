/**
* @author: Rita Bejjani -EI Technologies
* @date: 30/09/2019
* @description: Test Class for "LC62_RelationsEco_Controller" 
*/
@isTest
public class LC62_RelationsEco_Controller_test {
    
    @isTest
    static void LC62_test()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        insert u1;
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c =true;
        u2.Bypass_Triggers__c = 'AP08_Opportunity;AP14_OppRollUpSummaryUtility;AP07_Opportunity;AP17_BudgetOnOpp;AP09_Opportunity;AP24_OpportunityFDS;';
        u2.Bypass_Triggers__c += 'AP57_Affaire;AP25_OpportunityAvntRealise;AP05_Opportunity;AP15_Budget;AP08_Opportunity';
        PAD.PAD_BypassTrigger+=u2.Bypass_Triggers__c;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            
            account myaccount2= testUtils.createAccount2('tes2', 'Lebanon', 'Privé');
            myaccount2.Lieu_immatriculation_legale__c = 'tes2';
            insert myaccount2;
            
            contact mycontact4 = testUtils.createContact('test 3', myaccount.Id, null);
            mycontact4.Phone  = '123123';
            insert mycontact4;
            String teamMemberRole = 'Account Manager';
            AccountTeamMember myaccoutMember= New AccountTeamMember(AccountId = myaccount.id, TeamMemberRole = teamMemberRole, UserId= u1.Id);
            insert myaccoutMember;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.Renouvellement;
            insert myOpp;
            
            EcosystemePartenaire__c myEco = new EcosystemePartenaire__c();
            myEco.PartenaireLie__c = myaccount2.Id;
            myEco.TypeRelation__c = 'REPR_1';
            myEco.Opportunite__c = myOpp.Id;
            insert myEco;
            
            Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=myaccount.id,OpportuniteCommerciale__c=myOpp.id,OwnerID=u2.id,DatePriseEffet__c = Date.Today(),DureeInitialeContrat__c = 3,TypeReconduction__c = 'RNUL');
            //mycontrat.Contact__c = mycontact4.id; 
            insert(mycontrat);
            
            EcosystemePartenaire__c myEco2 = new EcosystemePartenaire__c();
            myEco2.PartenaireLie__c = myaccount2.Id;
            myEco2.TypeRelation__c = 'REPR_1';
            myEco2.Contrat__c = mycontrat.Id;
            insert myEco2;
            
            Test.startTest(); 
            List<EcosystemePartenaire__c> listEcoAccount = LC62_RelationsEco_Controller.getAccountEcoSys(myaccount.Id);
            List<EcosystemePartenaire__c> listEcoContact = LC62_RelationsEco_Controller.getContactEcoSys(mycontact4.Id);
            Test.stopTest();
        }
        
    }
}