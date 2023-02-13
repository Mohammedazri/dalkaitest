/** 
* @author Jacques Akiki
* @date 07/07/2020 
* @test Class of LC69_BudgetCadreCalcule
*/
@isTest
public class LC69_BudgetCadreCalcule_test {
    static testMethod void testSumBudgets() 
    {
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        
        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp1.AccountId=myaccount.Id;
        myOpp1.closeDate=Date.today();
        insert myOpp1;
        
        Contrat__c cont = new Contrat__c(name='Contrat');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.EstContratcadre__c = true;
        insert cont;
        
        List<contrat__c> listContFils = new list<Contrat__c>();
        
        Contrat__c contF1 = new Contrat__c(name='ContratF1');
        contF1.NomPartenaire__c = myaccount.Id; 
        contF1.ContratCadre__c = cont.id;
        listContFils.add(contF1);
        
        Contrat__c contF2 = new Contrat__c(name='ContratF2');
        contF2.NomPartenaire__c = myaccount.Id; 
        contF2.ContratCadre__c = cont.id;
        listContFils.add(contF2);
        
        Contrat__c contF3 = new Contrat__c(name='ContratF3');
        contF3.NomPartenaire__c = myaccount.Id; 
        contF3.ContratCadre__c = cont.id;
        listContFils.add(contF3);
        
        Contrat__c contF4 = new Contrat__c(name='ContratF4');
        contF4.NomPartenaire__c = myaccount.Id; 
        contF4.ContratCadre__c = cont.id;
        listContFils.add(contF4);
        
        insert listContFils;
        
        test.startTest();
        List<Budget__c> listBudget = new List<Budget__c>();
        string currentYear = string.valueOf(System.Today().year());
        Budget__c bud1 = testUtils.createBudget('test',currentYear,contF1.id);
        bud1.CABudgetP1__c = 10;
        bud1.CABudgetP2__c = 10;
        bud1.CABudgetP3__c = 10;
        bud1.CABudgetP4__c  = 10;
        bud1.CABudgetP6__c = 10;
        bud1.MBBudgetP1__c  = 10;
        bud1.MBBudgetP2__c  = 10;
        bud1.MBBudgetP3__c = 10;
        bud1.MBBudgetP4__c  = 10;
        bud1.MBBudgetP6__c = 10;
        bud1.BudgetNMainOeuvreDontNbHeureP2__c = 10;
        bud1.BudgetNMainOeuvreDontNbHeureP3__c = 10;
        bud1.BudgetNMainOeuvreDontNbHeureP6__c = 10;
        bud1.BudgetNMainOeuvreNombreHeureTotal__c = 10;
        listBudget.add(bud1);
        
        Budget__c bud2 = testUtils.createBudget('test2','2015',contF1.id);
        bud2.CABudgetP1__c = 10;
        bud2.CABudgetP2__c = 10;
        bud2.CABudgetP3__c = 10;
        bud2.CABudgetP4__c  = 10;
        bud2.CABudgetP6__c = 10;
        bud2.MBBudgetP1__c  = 10;
        bud2.MBBudgetP2__c  = 10;
        bud2.MBBudgetP3__c = 10;
        bud2.MBBudgetP4__c  = 10;
        bud2.MBBudgetP6__c = 10;
        bud2.BudgetNMainOeuvreDontNbHeureP2__c = 10;
        bud2.BudgetNMainOeuvreDontNbHeureP3__c = 10;
        bud2.BudgetNMainOeuvreDontNbHeureP6__c = 10;
        bud2.BudgetNMainOeuvreNombreHeureTotal__c = 10;
        listBudget.add(bud2);
        
        Budget__c bud3 = testUtils.createBudget('test3','2018',contF2.id);
        bud3.CABudgetP1__c = 10;
        bud3.CABudgetP2__c = 10;
        bud3.CABudgetP3__c = 10;
        bud3.CABudgetP4__c  = 10;
        bud3.CABudgetP6__c = 10;
        bud3.MBBudgetP1__c  = 10;
        bud3.MBBudgetP2__c  = 10;
        bud3.MBBudgetP3__c = 10;
        bud3.MBBudgetP4__c  = 10;
        bud3.MBBudgetP6__c = 10;
        bud3.BudgetNMainOeuvreDontNbHeureP2__c = 10;
        bud3.BudgetNMainOeuvreDontNbHeureP3__c = 10;
        bud3.BudgetNMainOeuvreDontNbHeureP6__c = 10;
        bud3.BudgetNMainOeuvreNombreHeureTotal__c = 10;
        listBudget.add(bud3);
        
        Budget__c bud4 = testUtils.createBudget('test4','2017',contF4.id);
        bud4.CABudgetP1__c = 10;
        bud4.CABudgetP2__c = 10;
        bud4.CABudgetP3__c = 10;
        bud4.CABudgetP4__c  = 10;
        bud4.CABudgetP6__c = 10;
        bud4.MBBudgetP1__c  = 10;
        bud4.MBBudgetP2__c  = 10;
        bud4.MBBudgetP3__c = 10;
        bud4.MBBudgetP4__c  = 10;
        bud4.MBBudgetP6__c = 10;
        bud4.BudgetNMainOeuvreDontNbHeureP2__c = 10;
        bud4.BudgetNMainOeuvreDontNbHeureP3__c = 10;
        bud4.BudgetNMainOeuvreDontNbHeureP6__c = 10;
        bud4.BudgetNMainOeuvreNombreHeureTotal__c = 10;
        listBudget.add(bud4);
        
        Budget__c bud5 = testUtils.createBudget('test5',currentYear,contF4.id);
        bud5.CABudgetP1__c = 10;
        bud5.CABudgetP2__c = 10;
        bud5.CABudgetP3__c = 10;
        bud5.CABudgetP4__c  = 10;
        bud5.CABudgetP6__c = 10;
        bud5.MBBudgetP1__c  = 10;
        bud5.MBBudgetP2__c  = 10;
        bud5.MBBudgetP3__c = 10;
        bud5.MBBudgetP4__c  = 10;
        bud5.MBBudgetP6__c = 10;
        bud5.BudgetNMainOeuvreDontNbHeureP2__c = 10;
        bud5.BudgetNMainOeuvreDontNbHeureP3__c = 10;
        bud5.BudgetNMainOeuvreDontNbHeureP6__c = 10;
        bud5.BudgetNMainOeuvreNombreHeureTotal__c = 10;
        listBudget.add(bud5);
        insert listBudget;
        LC69_BudgetCadreCalcule.getCurrentObject(cont.id);
        LC69_BudgetCadreCalcule.getCurrentObject(contF4.id);
        
    }
}