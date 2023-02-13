/*
 * @Description: test Class used to cover lwc05EcosystemePartenaire_Controller
 * @Author: Jimmy Khalil
 * @Date: 09/09/2022
 * @Coverage: 97%
 */
@isTest
public with sharing class lwc05EcosystemePartenaire_Test {
    @isTest
    static void  testController(){
        User u2 = testUtils.CreateUser('standt28', 'userAdminAP112@testorg2.com', 'userAdminAP112', Label.AdminProfileId, 'userAdminAP112@testorg2.com');
        u2.isActive = true;
        u2.Code_d_Appartenance__c = 'OCESCOM2';
        u2.Organisation__c = 'A-1234';

        insert new List<User> {u2};

        System.runAs(u2){
            // create an account
            account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            myaccount.NaturePartenaire__c = 'ETAB';
            myaccount.DKCodeSurPartenaire__c = '123';
            insert new List<Account> {myaccount};
            // create an Opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(), 'En cours', 'Piste');
            myOpp.AccountId = myaccount.Id;
            myOpp.closeDate = Date.today();
            myOpp.Amount = 3;
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c = Label.LC28_TypeNouveau;
            insert myOpp;
            // create a Contrat__c
            Contrat__c c1 = new Contrat__c();
            c1.NomPartenaire__c = myaccount.Id;
            c1.TypeReconduction__c = 'RNUL';
            c1.DatePriseEffet__c = Date.Today();
            c1.DureeInitialeContrat__c = 3;
            c1.OwnerID = u2.id;
            insert c1;

            // create contacts (ajouté par Rita Bejjani le 06/06/2019)
            contact mycontact = testUtils.createContact('test 2', myaccount.Id, null);
            insert mycontact;

            contact mycontact1 = testUtils.createContact('test 1', myaccount.Id, null);
            insert mycontact1;

            // create an EcosystemePartenaire__c
            EcosystemePartenaire__c eco = new EcosystemePartenaire__c ( Partenaire__c = myaccount.Id, PartenaireLie__c = myaccount.Id, Opportunite__c = myOpp.ID, Statut__c = 'ACTIF', TypeRelation__c = 'DEST');
            // create an EcosystemePartenaire__c
            EcosystemePartenaire__c eco1 = new EcosystemePartenaire__c ( Partenaire__c = myaccount.Id, PartenaireLie__c = myaccount.Id, Contrat__c = c1.ID, Statut__c = 'ACTIF', ContactDuPartenaireLie__c = mycontact.id, TypeRelation__c = 'FACT_1');

            Test.startTest();

            Integer myaccountTotalEcosysteme = lwc05EcosystemePartenaire_Controller.getTotalEcosysteme(myaccount.Id);
            system.assertEquals(0, myaccountTotalEcosysteme);

            Insert new List<EcosystemePartenaire__c> {eco, eco1};

            myaccountTotalEcosysteme = lwc05EcosystemePartenaire_Controller.getTotalEcosysteme(myaccount.Id);
            system.assertEquals(2, myaccountTotalEcosysteme);

            List<lwc05EcosystemePartenaire_Wrapper> myaccount1GetRelatedEcosysteme = lwc05EcosystemePartenaire_Controller.getRelatedEcosysteme(myaccount.Id, 'ContratCAEnCours', 'asc', 5, 1);

            Test.stopTest();

        }
    }
}