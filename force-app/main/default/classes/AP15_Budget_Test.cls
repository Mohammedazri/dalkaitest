/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Test Class for AP15_Budget
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP15_Budget_Test 
{
    @isTest
    static void testBudget()
    { 
        //get current year (annee N)
        Integer currentYear = System.Today().year();
        string currentYearString = String.valueOf(currentYear);
        string previousYearString = String.valueOf(currentYear-1);
        string nextYearString = String.valueOf(currentYear+1);
        
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create user and	 add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.Bypass_Triggers__c='AP05_Opportunity;AP14_OppRollUpSummaryUtility;AP08_Opportunity;AP21_Opportunity;AP24_OpportunityFDS';
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c= true;
        insert u2;
        //run test as user 
        System.runAs(u2) 
        {
            //create and insert Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.statutPartenaire__c  = label.WS11_OUV;
            a1.BillingPostalCode='111';
            insert a1;
            //create and insert Contract
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.Annee_de_signature__c=currentYearString;
            insert myOpp;
            
            //create and insert Budget__c
            Budget__c myBudget = testUtils.CreateBudget ('testBudget', previousYearString, c1.Id);
            
            Budget__c myBudget1 = testUtils.CreateBudget ('testBudget1', currentYearString, c1.Id);
            insert new list<Budget__c> {myBudget,myBudget1};
            
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            Fiche1.P6MbOf__c=12;
            update Fiche1;
            
            //start test
            Test.startTest();
         
            //update opp year
            myOpp.Annee_de_signature__c=nextYearString;
            update myOpp;
            
            //update myBudget
            myBudget.AnneeBudget__c=nextYearString;
            update myBudget;
          
            
            //update myOpp
            myOpp.CloseDate = Date.newInstance(2018, 10, 10);
            //Update myOpp;
            
            // delete myBudget
            delete myBudget;
            
            //stop test
            Test.stopTest();
        }
    }

}