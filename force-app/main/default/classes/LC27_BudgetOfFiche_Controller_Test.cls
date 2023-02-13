/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Test Class of LC27_BudgetOfFiche_Controller
Coverage: 93%
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class LC27_BudgetOfFiche_Controller_Test {
    static testMethod void LC27_BudgetOfFicheTestCurrentYear() {
        
        //get current year (annee N)
        Integer currentYear = System.Today().year();
        string currentYearString = String.valueOf(currentYear);
        string previousYearString = String.valueOf(currentYear-1);
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = 'OUV';
            insert a1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            insert myOpp;
            
            /*fiche_de_synthese__c myFiche=new fiche_de_synthese__c();
            myFiche.Opportunit_commerciale__c=myOpp.Id;
            myFiche.Name='test1';*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c myFiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            myFiche.P6MbOf__c=12;
            myFiche.P6CaOf__c=11;
            update myFiche;
            
            Test.startTest();     
            Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=a1.id,OpportuniteCommerciale__c=myOpp.id);
            mycontrat.NumeroContrat__c = '1234567T';
            mycontrat.TypeReconduction__c = 'RNUL';
            mycontrat.DatePriseEffet__c = Date.today();
            insert(mycontrat);
            
            opportunity myOppEvol = testUtils.createOpportunity ('testOppEvol', date.today(),Label.Opp_StatutEnCours, 'Piste');
            myOppEvol.accountId=a1.Id;
            myOppEvol.ContratOrigine__c=mycontrat.Id;
            myOppEvol.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOppEvol.Type_pers__c=Label.PV_Evolution;
            myOppEvol.tech_Budget__c = null;
            myOppEvol.Annee_de_signature__c=currentYearString;
            insert myOppEvol;
            
            BudgetCourant__c bugetCourant = new BudgetCourant__c(name = 'BudgetCourant', annee__c=currentYearString);
            insert bugetCourant;
     
            Budget__c budg= new Budget__c(  name='test',  AnneeBudget__c=currentYearString,NomContrat__c=mycontrat.id);
            insert budg;
            Budget__c budg1= new Budget__c(  name='test2',  AnneeBudget__c=previousYearString,NomContrat__c=mycontrat.id);
            insert budg1;
            LC27_BudgetOfFiche_Controller.getCurrentObject(myFiche.Id);
            LC27_BudgetOfFiche_Controller.getCurrentObject(mycontrat.Id);
            LC27_BudgetOfFiche_Controller.getCurrentObject(myOppEvol.Id);
            LC27_BudgetOfFiche_Controller.getID();
            
            Test.stopTest();
        }
    }
    
    //Check previous year with budget for this year exist
    static testMethod void LC27_BudgetOfFicheTestPreviousYear() {
        
        //get current year (annee N)
        Integer currentYear = System.Today().year();
        string currentYearString = String.valueOf(currentYear);
        string previousYearString = String.valueOf(currentYear-1);
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = 'OUV';
            insert a1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            
            opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.accountId=a1.Id;
            insert new List<opportunity> {myOpp,myOpp1};
            
            /*fiche_de_synthese__c myFiche=new fiche_de_synthese__c();
            myFiche.Opportunit_commerciale__c=myOpp.Id;
            myFiche.Name='test1';*/
            Fiche_de_synthese__c myFiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            myFiche.P6MbOf__c=12;
            myFiche.P6CaOf__c=11;
            update myFiche;
            
            Test.startTest();     
            Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=a1.id,OpportuniteCommerciale__c=myOpp.id);
            mycontrat.NumeroContrat__c = '1234567T';
            mycontrat.TypeReconduction__c = 'RNUL';
            mycontrat.DatePriseEffet__c = Date.today();
            
            Contrat__c mycontrat1= new Contrat__c(Name='test1',NomPartenaire__c=a1.id,OpportuniteCommerciale__c=myOpp1.id);
            mycontrat1.NumeroContrat__c = '1234567T';
            mycontrat1.TypeReconduction__c = 'RNUL';
            mycontrat1.DatePriseEffet__c = Date.today();
            insert new List<Contrat__c> {mycontrat,mycontrat1};
            
            opportunity myOppEvol = testUtils.createOpportunity ('testOppEvol', date.today(),Label.Opp_StatutEnCours, 'Piste');
            myOppEvol.accountId=a1.Id;
            myOppEvol.ContratOrigine__c=mycontrat.Id;
            myOppEvol.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOppEvol.Type_pers__c=Label.PV_Evolution;
            myOppEvol.tech_Budget__c = null;
            myOppEvol.Annee_de_signature__c=previousYearString;
            insert myOppEvol;
            
            BudgetCourant__c bugetCourant = new BudgetCourant__c(name = 'BudgetCourant', annee__c=currentYearString);
            insert bugetCourant;
            
            Budget__c budg= new Budget__c(  name='test',  AnneeBudget__c=previousYearString,NomContrat__c=mycontrat.id);
            insert budg;
            Budget__c budg1= new Budget__c(  name='test2',  AnneeBudget__c=currentYearString,NomContrat__c=mycontrat1.id);
            insert budg1;
            LC27_BudgetOfFiche_Controller.getCurrentObject(myFiche.Id);
            LC27_BudgetOfFiche_Controller.getCurrentObject(mycontrat.Id);
            LC27_BudgetOfFiche_Controller.getCurrentObject(myOppEvol.Id);
            LC27_BudgetOfFiche_Controller.getID();
            
            Test.stopTest();
        }
    }
    
    //Check previous year with no budget for this year
     static testMethod void LC27_BudgetOfFicheTestPreviousYear1() {
        
        //get current year (annee N)
        Integer currentYear = System.Today().year();
        string currentYearString = String.valueOf(currentYear);
        string previousYearString = String.valueOf(currentYear-1);
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = 'OUV';
            insert a1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            
            opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
            myOpp1.accountId=a1.Id;
            insert new List<opportunity> {myOpp,myOpp1};
            
            /*fiche_de_synthese__c myFiche=new fiche_de_synthese__c();
            myFiche.Opportunit_commerciale__c=myOpp.Id;
            myFiche.Name='test1';*/
            Fiche_de_synthese__c myFiche= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            myFiche.P6MbOf__c=12;
            myFiche.P6CaOf__c=11;
            update myFiche;
            
            Test.startTest();     
            Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=a1.id,OpportuniteCommerciale__c=myOpp.id);
            mycontrat.NumeroContrat__c = '1234567T';
            mycontrat.TypeReconduction__c = 'RNUL';
            mycontrat.DatePriseEffet__c = Date.today();
            
            Contrat__c mycontrat1= new Contrat__c(Name='test1',NomPartenaire__c=a1.id,OpportuniteCommerciale__c=myOpp1.id);
            mycontrat1.NumeroContrat__c = '1234567T';
            mycontrat1.TypeReconduction__c = 'RNUL';
            mycontrat1.DatePriseEffet__c = Date.today();
            insert new List<Contrat__c> {mycontrat,mycontrat1};
            
            opportunity myOppEvol = testUtils.createOpportunity ('testOppEvol', date.today(),Label.Opp_StatutEnCours, 'Piste');
            myOppEvol.accountId=a1.Id;
            myOppEvol.ContratOrigine__c=mycontrat.Id;
            myOppEvol.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOppEvol.Type_pers__c=Label.PV_Evolution;
            myOppEvol.tech_Budget__c = null;
            myOppEvol.Annee_de_signature__c=previousYearString;
            insert myOppEvol;
            
            BudgetCourant__c bugetCourant = new BudgetCourant__c(name = 'BudgetCourant', annee__c=currentYearString);
            insert bugetCourant;
            
            Budget__c budg= new Budget__c(  name='test',  AnneeBudget__c=previousYearString,NomContrat__c=mycontrat.id);
            insert budg;
            Budget__c budg1= new Budget__c(  name='test2',  AnneeBudget__c=previousYearString,NomContrat__c=mycontrat1.id);
            insert budg1;
            LC27_BudgetOfFiche_Controller.getCurrentObject(myFiche.Id);
            LC27_BudgetOfFiche_Controller.getCurrentObject(mycontrat.Id);
            LC27_BudgetOfFiche_Controller.getCurrentObject(myOppEvol.Id);
            LC27_BudgetOfFiche_Controller.getID();
            
            Test.stopTest();
        }
    }
}