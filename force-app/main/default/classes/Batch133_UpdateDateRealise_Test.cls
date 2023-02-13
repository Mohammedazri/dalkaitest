/**
 * @author Jimmy Khalil - EIT Mena
 * @date 01/12/2022
 * @description Test class for Batch133_UpdateDateRealise
 */
@isTest
public class Batch133_UpdateDateRealise_Test {
    @isTest
    static void setDateRealise() {

        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');

        Insert new List<Account> {a1, a2};

        Contact c1 = testUtilsC360.createContact('Test', a1.Id, null, true);

        Insert c1;

        Opportunity opp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
        Opportunity opp2 = testUtilsC360.createOpportunityIndepNouveau('testOpp2', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());

        Insert new List<Opportunity> {opp1, opp2};

        testUtilsC360.completeeFDS(new set<Id> {opp1.Id, opp2.Id});

        OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(opp1.Id, c1.Id);

        Insert new List<OpportuniteContact__c> {oppCont1};

        opp1 = testUtilsC360.realiseOpportunity(opp1);

        Update new List<Opportunity> {opp1};

        OpportunityFieldHistory oppHistory = new OpportunityFieldHistory(OpportunityId = opp1.Id,
                                                                         Field = 'StageName');

        Insert oppHistory;

        User u1 = testUtilsC360.CreateUser('standt18', 'batch133User@testorg1.com', 'Testing', Label.AdminProfileId, 'batch133User@testorg1.com');
        u1 = testUtilsC360.bypassUser(u1);

        Insert u1;

        PAD.PAD_BypassTrigger = ';' + u1.Bypass_Triggers__c + ';';

        System.runAs(u1){
            opp1.RelaisDatePassageGagnee__c = null;
            opp2.RelaisDatePassageGagnee__c = '2020-01-01';
            Update new List<Opportunity> {opp1, opp2};

            test.startTest();
            Id batch133Id = Database.executeBatch(new Batch133_UpdateDateRealise());
            test.stopTest();
        }
    }
}