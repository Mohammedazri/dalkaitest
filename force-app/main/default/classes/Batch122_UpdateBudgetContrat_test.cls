/**
 * @author Jacques Akiki - Ei technologies
 * @date 17/03/2022
 * @description test class of Batch122_UpdateBudgetContrat
 */
@istest
public class Batch122_UpdateBudgetContrat_test {
    @istest
    static void testBudget() {

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        Insert new List<Account> {a1, a2};

        String thisyear = String.valueOf(System.Today().year());
        String nextYear = String.valueOf(System.Today().year() + 1);
        BudgetCourant__c bc = new BudgetCourant__c (Name = 'BudgetCourant', Annee__c = thisYear);
        insert bc;

        Contact c1 = testUtilsC360.createContact('Test', a1.Id, null, true);

        Insert c1;

        Opportunity opp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', thisyear, Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
        Insert opp1;

        testUtilsC360.completeeFDS(new set<Id> {opp1.Id});

        OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(opp1.Id, c1.Id);
        Insert oppCont1;

        opp1 = testUtilsC360.realiseOpportunity(opp1);
        Update opp1;

        List<Contrat__c> contList =  testUtilsC360.getContratGeneree(new set<Id> {opp1.Id});
        Contrat__c cont =  contList[0];

        User u1 = testUtilsC360.CreateUser('standt18', 'batch122User@testorg1.com', 'Testing', Label.AdminProfileId, 'batch122User@testorg1.com');
   		u1.Bypass_Triggers__c = 'AP45_Account;AP48_ContractCallouts;AP85_Objectif;AP87_Objectif;AP90_Objectif;AP92_Objectif;AP96_Objectif';
        Insert u1;
        PAD.PAD_BypassTrigger = u1.Bypass_Triggers__c;
        System.runAs(u1){

            Test.startTest();
            Budget__c bud1 = testUtilsC360.createBudget('test', thisyear, cont.id, 100, 200);
            insert bud1;

            bc.Annee__c = nextYear;
            update bc;

            Budget__c bud2 = testUtilsC360.createBudget('test', nextYear, cont.id, 500, 600);
            insert bud2;

            Opportunity opp1Evol = testUtilsC360.createOpportunityIndepEvol('testOpp1Evol', nextYear, date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId(), cont.Id);
            Insert opp1Evol;
            opp1Evol.tech_Budget__c = bud1.Id;
            update opp1Evol;
            
            Fiche_de_synthese__c fds = [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:opp1Evol.Id Limit 1];
            fds.Budget__c = bud1.id;
            update fds;

            id BatchId = Database.executeBatch(new Batch122_UpdateBudgetContrat(true));
            Test.stopTest();
        }

    }
}