/**
 * @author: Jimmy Khalil
 * @date: 12/05/2022
 * @description: Test Class for AP110_OpportuniteContact
 */
@istest
public with sharing class AP110_OpportuniteContact_test {
    @istest
    static void deleteContactTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name = :Label.Profile_CommercialFirst];

        User usr = testUtilsC360.CreateUser('ComOne', 'Commercial@testorg.com', 'Commercial First', p.Id, 'Commercial@testorg.com');

        Insert usr;

        Contact cont = testUtilsC360.createContact('TEST', null, null, true);
        insert cont;

        list<Account> listAcc = new List<Account>();
        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        listAcc.add(a1);
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        listAcc.add(a2);
        insert listAcc;

        Opportunity myOpp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, usr.Id);

        insert myOpp1;

        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        /*Fiche_de_synthese__c Fiche1 = [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1];
           Fiche1.OffreA1P2VentesServices__c = 100;
           update Fiche1;*/
        testUtilsC360.completeeFDS(new set<Id> {myOpp1.Id});
        /* Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
           myFDS1.name = 'test1';
           myFDS1.Opportunit_commerciale__c = myOpp1.id;
           insert myFDS1;*/

        OpportuniteContact__c oc = testUtilsC360.createOpportunityContrat(myOpp1.Id, cont.Id);
        insert oc;

        Test.startTest();
        myOpp1 = testUtilsC360.realiseOpportunity(myOpp1);
        update myOpp1;

        System.runAs(usr){
            try {
                delete oc;
            }
            Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.AP110_ErrorMessage));
            }
        }
        Test.stopTest();
    }
    @istest
    static void insertContactTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name = :Label.Profile_CommercialFirst];

        User usr = testUtilsC360.CreateUser('ComOne', 'Commercial@testorg.com', 'Commercial First', p.Id, 'Commercial@testorg.com');

        Insert usr;

        Contact cont = testUtilsC360.createContact('TEST', null, null, true);
        Contact cont1 = testUtilsC360.createContact('TEST1', null, null, true);
        insert new List<Contact> {cont, cont1};

        list<Account> listAcc = new List<Account>();
        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        listAcc.add(a1);
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233', 'abcdef124');
        listAcc.add(a2);
        insert listAcc;

        Opportunity myOpp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, usr.Id);

        insert myOpp1;

        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        /*Fiche_de_synthese__c Fiche1 = [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1];
           Fiche1.OffreA1P2VentesServices__c = 100;
           update Fiche1;*/
        testUtilsC360.completeeFDS(new set<Id> {myOpp1.Id});
        /* Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
           myFDS1.name = 'test1';
           myFDS1.Opportunit_commerciale__c = myOpp1.id;
           insert myFDS1;*/

        OpportuniteContact__c oc = testUtilsC360.createOpportunityContrat(myOpp1.Id, cont.Id);
        insert oc;

        Test.startTest();
        myOpp1 = testUtilsC360.realiseOpportunity(myOpp1);
        update myOpp1;

        System.runAs(usr){
            try {
                OpportuniteContact__c oc1 = testUtilsC360.createOpportunityContrat(myOpp1.Id, cont1.Id);
                insert oc1;
            }
            Catch(Exception e){
                System.Assert(e.getMessage().contains(Label.AP110_ErrorMessage));
            }
        }
        Test.stopTest();
    }
}