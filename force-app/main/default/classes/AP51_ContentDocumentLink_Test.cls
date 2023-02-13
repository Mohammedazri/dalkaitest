/**
 * @author: Rita Bejjani -EI Technologies
 * @date: 11/04/2019
 * @description: Test Class for "AP51_ContentDocumentLink"
 */
@isTest
public class AP51_ContentDocumentLink_Test {

    static testMethod void testCheckPreviousCDL(){
        //create the user
        User u1 = testUtilsC360.CreateUser('standt18', 'lc34User@testorg1.com', 'Testing', Label.AdminProfileId, 'lc34User@testorg1.com');
        u1 = testUtilsC360.bypassUser(u1);

        Insert u1;

        // run test as the created user
        System.runAs(u1){

            ContentVersion contentVersion1 = testUtilsC360.createContentVersion('Test1', 'Test1.jpg', 'Test1 Content Data', true);
            ContentVersion contentVersion2 = testUtilsC360.createContentVersion('Test2', 'Test2.jpg', 'Test2 Content Data', true);

            insert new List<ContentVersion> {contentVersion1, contentVersion2};

            List<ContentDocument> documents = [SELECT Id, Title FROM ContentDocument];

            Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
            Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
            Insert new List<Account> {a1, a2};

            Contact c1 = testUtilsC360.createContact('TestLC34', a1.Id, null, true);
            Insert c1;

            Opportunity opp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
            Insert opp1;

            testUtilsC360.completeeFDS(new set<Id> {opp1.Id});

            OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(opp1.Id, c1.Id);
            Insert oppCont1;

            opp1 = testUtilsC360.realiseOpportunity(opp1);
            Update opp1;

            List<Contrat__c> contList =  testUtilsC360.getContratGeneree(new set<Id> {opp1.Id});
            Contrat__c contrat =  contList[0];
            test.startTest();
            Document_Contractuel__c DC = testUtilsC360.createDocumentContractuel('test', '123', 'DOC01', 'ACT', contrat.id, date.today(), date.today(), 'DOC_C02');
            insert DC;

            ContentDocumentLink contentlink1 = testUtilsC360.createContentDocumentLink(DC.id, documents[0].Id, 'AllUsers', 'I');
            insert contentlink1;

            ContentDocumentLink contentlink2 = testUtilsC360.createContentDocumentLink(DC.id, documents[1].Id, 'AllUsers', 'I');
            try {
                insert contentlink2;

            }
            catch(exception e) {
                system.debug('exception message ' + e.getMessage());
                system.assertEquals(e.getMessage(), 'Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Vous ne pouvez ajouter plus qu' + '\\' + '\'un seul fichier sur ce document contractuels: []');
            }

            test.stopTest();
        }

    }

}