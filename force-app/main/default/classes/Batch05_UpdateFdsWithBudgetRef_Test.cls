/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: test class for  Batch05_UpdateFdsWithBudgetRef
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: test class for  Batch05_UpdateFdsWithBudgetRef with commented contrat__c fields
History
<Date>   6/08/2018   <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/

@istest
public class Batch05_UpdateFdsWithBudgetRef_Test {
    
    @istest
    public static void testBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Bypass_Triggers__c = 'AP08_Opportunity;AP14_OppRollUpSummaryUtility;AP07_Opportunity;AP17_BudgetOnOpp;AP09_Opportunity;AP24_OpportunityFDS;';
        u2.Bypass_Triggers__c += 'AP57_Affaire;AP25_OpportunityAvntRealise;AP05_Opportunity;AP15_Budget;AP08_Opportunity;AP38_OpportunityContratCadre';
        PAD.PAD_BypassTrigger+=u2.Bypass_Triggers__c;
        u2.BypassValidationRules__c =true;
        PAD.PAD_BypassTrigger+=u2.Bypass_Triggers__c;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            Test.startTest();
            Account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            
            Contrat__c mycontrat2= new Contrat__c(Name='testContrat2');
            
            mycontrat2.NomPartenaire__c=myaccount.Id;
            mycontrat2.ReconductionFaitAutorisee__c = true;
            insert mycontrat2;
            
            Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.Amount=3;
            myOpp.statut__c ='En cours';
            myOpp.ContratOrigine__c = mycontrat2.id;
            myOpp.Type_pers__c = Label.Renouvellement;
        	myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            
            insert myOpp;
            
            Contrat__c mycontrat= new Contrat__c(Name='testContrat');
            mycontrat.OpportuniteCommerciale__c=myOpp.Id;
            mycontrat.NomPartenaire__c=myaccount.Id;
            mycontrat.ReconductionFaitAutorisee__c = true;
            insert mycontrat;
            
            Budget__c budget = new Budget__c();
            budget.AnneeBudget__c = '2018';
            budget.NomContrat__c = mycontrat2.Id;
            
            insert budget;
            
            List<Fiche_de_synthese__c> listfds = new List<Fiche_de_synthese__c>();
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c myfds= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            
            /*Fiche_de_synthese__c myfds= new Fiche_de_synthese__c(Name='testfds');
            myfds.Opportunit_commerciale__c=myOpp.Id;*/
            myfds.P1CaOf__c=2;
            myfds.P2CaOf__c=2;
            myfds.P3CaOf__c=2;
            myfds.P4CaOf__c=2;
            myfds.P6CaOf__c=2;
            myfds.P1MbOf__c=2;
            myfds.P2MbOf__c=2;
            myfds.P3MbOf__c=2;
            myfds.P4MbOf__c=2;
            myfds.P6MbOf__c=2;
            myfds.P1CaRef__c=2;
            myfds.P2CaRef__c=2;
            myfds.P3CaRef__c=2;
            myfds.P4CaRef__c=2;
            myfds.P6CaRef__c=2;
            myfds.P1MbRef__c=2;
            myfds.P2MbRef__c=2;
            myfds.P3MbRef__c=2;
            myfds.P4MbRef__c=2;
            myfds.P6MbRef__c=2;
            myfds.P1Energie__c='2';
            myfds.P2Services__c='2';
            myfds.P3GarantieTotale__c='2';
            myfds.P4Financement__c='2';
            myfds.P6Travaux__c='2';
            myfds.SousTotP1234__c='2';
            myfds.BklgHorsP6__c='2';
            myfds.BklgAvecP6__c='2';
            myfds.ValorisationMainOeuvre__c='ThoEtude';
            myfds.Budget__c = budget.id;
            
            
            
            listfds.add(myfds);
            
            update listfds;
            
            System.assert(listfds.size() == 1, true);
            
            
            Batch05_UpdateFdsWithBudgetRef testBatch=new Batch05_UpdateFdsWithBudgetRef();
            DataBase.executeBatch(testBatch);
            Test.stopTest();
        }
        
    }
}