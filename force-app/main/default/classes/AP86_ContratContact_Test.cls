/**
 * @author Dona Kfoury -EI Technologies
 * @date 07/07/2020
 * @description Test Class for AP86_ContratContact
 */
@isTest
public class AP86_ContratContact_Test {
    @isTest
    static void testEspaceClient() {
        Profile p = [SELECT Id FROM Profile WHERE id =:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c = 'OCECOM2';
        u2.Bypass_Triggers__c = 'AP08_Opportunity;AP14_OppRollUpSummaryUtility;AP07_Opportunity;AP17_BudgetOnOpp;AP09_Opportunity;AP24_OpportunityFDS;';
        u2.Bypass_Triggers__c += 'AP57_Affaire;AP25_OpportunityAvntRealise;AP05_Opportunity;AP15_Budget;AP08_Opportunity;AP38_OpportunityContratCadre;AP45_Account';
        PAD.PAD_BypassTrigger += u2.Bypass_Triggers__c;
        insert u2;
        System.runAs(u2){
            Account myaccount = testUtils.createAccount('testAccount2', 'Lebanon', 'Privé');
            myaccount.BillingCity = 'test';
            myaccount.BillingPostalCode = '111';
            myaccount.Lieu_immatriculation_legale__c = 'test';
            myaccount.StatutPartenaire__c = Label.WS11_OUV;

            Account myaccount2 = testUtils.createAccountParticulier('testAccountParticulier', 'France', 'Privé');
            myaccount2.BillingCity = 'test2';
            myaccount2.BillingPostalCode = '2222';
            myaccount2.Lieu_immatriculation_legale__c = 'test2';
            myaccount2.StatutPartenaire__c = Label.WS11_OUV;
            List<Account> listAccs = new list<Account> {myaccount, myaccount2};
            PAD.PAD_BypassTrigger += '; AP45_Account;';
            insert listAccs;
            Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(), null, 'Piste');
            myOpp1.AccountId = myaccount.Id;
            myOpp1.closeDate = Date.today();
            myOpp1.statut__c = Label.Opp_StatutEnCours;
            insert myOpp1;

            Contrat__c cont = new Contrat__c(name = 'Contrat');
            cont.NomPartenaire__c = myaccount.Id;
            cont.OpportuniteCommerciale__c = myOpp1.id;
            cont.EstContratcadre__c = true;
            insert cont;

            contact mycontact = testUtils.createContact('test 4', myaccount.Id, null);
            mycontact.IsContactEspaceClient__c = true;
            contact mycontact2 = testUtils.createContact('test 5', myaccount.Id, null);
            mycontact2.IsContactEspaceClient__c = true;
            List<Contact> listCons = new list<contact> {mycontact, mycontact2};
            insert listCons;
            test.starttest();
            ContratContact__c contactContrat = testUtils.createContactContrat(cont.Id, mycontact.Id);
            ContratContact__c contactContrat2 = testUtils.createContactContrat(cont.Id, mycontact2.Id);
            List<contact> listcontacts = [select id
                                          FROM contact
                                          where accountid =:myaccount2.id];
            system.debug('listcontacts ' + listcontacts);
            ContratContact__c contactContrat3 = testUtils.createContactContrat(cont.Id, listcontacts[0].id);
            List<ContratContact__c> listConConts = new list<ContratContact__c> {contactContrat, contactContrat2, contactContrat3};
            insert listConConts;
            mycontact.IsContactEspaceClient__c = false;
            update mycontact;
            map<id, ContratContact__c> oldmap = new map<id, ContratContact__c>();
            oldmap.put(contactContrat.id, contactContrat);
            AP86_ContratContact.contactContratEdit(new list<ContratContact__c> {contactContrat}, oldmap );
            update contactContrat;
            delete contactContrat;
            delete mycontact2;
            myaccount2.IsContactEspaceClient__pc = true;
            PAD.PAD_BypassTrigger += ';AP45_Account;';
            update myaccount2;
            PAD.PAD_BypassTrigger += 'AP74_Account;';
            delete myaccount2;
            test.stopTest();
        }
    }

}