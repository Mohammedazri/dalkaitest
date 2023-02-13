/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: test class for  Batch13_UpdateFdsWithBudgetRefRealise
History
<Date>   6/08/2018   <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/

@istest
public class Batch13_UpdateFdsBudgRefRealise_Test {
    
    @istest
    public static void testBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassFilters__c = true;
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassValidationRules__c=true;
        //u2.Bypass_Triggers__c = 'AP21_Opportunity;';
        u2.Bypass_Triggers__c = 'AP08_Opportunity;AP14_OppRollUpSummaryUtility;AP07_Opportunity;AP17_BudgetOnOpp;AP09_Opportunity;AP24_OpportunityFDS;';
        u2.Bypass_Triggers__c += 'AP57_Affaire;AP25_OpportunityAvntRealise;AP05_Opportunity;AP15_Budget;AP08_Opportunity;AP38_OpportunityContratCadre';
        PAD.PAD_BypassTrigger+=u2.Bypass_Triggers__c;
        insert u2;
        System.runAs(u2) {
            
            Test.startTest();
            Account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.Lieu_immatriculation_legale__c = 'test';
            insert myaccount;
            
            Contrat__c mycontrat2= new Contrat__c(Name='testContrat2');
            mycontrat2.NomPartenaire__c=myaccount.Id;
            mycontrat2.ReconductionFaitAutorisee__c = true;
            
            Contrat__c mycontrat3= new Contrat__c(Name='testContrat3');
            mycontrat3.NomPartenaire__c=myaccount.Id;
            mycontrat3.ReconductionFaitAutorisee__c = true;
            
            List<Contrat__c> listCont = new list<Contrat__c>();
            listCont.add(mycontrat2);
            listCont.add(mycontrat3);
            
            insert listCont;
            
            Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.Amount=3;
            myOpp.statut__c ='En cours';
            myOpp.ContratOrigine__c = mycontrat2.id;
            myOpp.Type_pers__c = Label.Renouvellement;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            
            insert myOpp;
            
            Contrat__c mycontrat= new Contrat__c(Name='testContrat');
            mycontrat.OpportuniteCommerciale__c=myOpp.Id;
            mycontrat.NomPartenaire__c=myaccount.Id;
            mycontrat.ReconductionFaitAutorisee__c = true;
            
            insert mycontrat;
            
            Budget__c budget = new Budget__c();
            budget.AnneeBudget__c = '2016';
            budget.NomContrat__c = mycontrat2.Id;
            
            
            Budget__c budget1 = new Budget__c();
            budget1.AnneeBudget__c = '2013';
            budget1.NomContrat__c = mycontrat2.Id;
            
            Budget__c budget2 = new Budget__c();
            budget2.AnneeBudget__c = '2017';
            budget2.NomContrat__c = mycontrat2.Id;
            
            List<budget__c> ListBudg = new List<budget__c>();
            ListBudg.add(budget);
            ListBudg.add(budget1);
            ListBudg.add(budget2); 
            insert ListBudg;
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c myfds:listFDS){
                myfds.OffreA1P1VentesServices__c = 0;
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
                myfds.Budget__c = budget1.Id;
            }
            update listfds;
            Batch13_UpdateFdsWithBudgetRefRealise testBatch=new Batch13_UpdateFdsWithBudgetRefRealise();
            DataBase.executeBatch(testBatch);
            Test.stopTest();
        }
        
    }
}