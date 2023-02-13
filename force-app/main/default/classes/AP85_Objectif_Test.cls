/**
* @author Dona Kfoury -EI Technologies
* @date 17/06/2020
* @description Test Class for AP85_Objectif
*/
@isTest
public class AP85_Objectif_Test {
    @isTest
    static void testinitContratsActifsBatch() {
        list<User> listUsers = new list<User>();
        //query the profile
        Profile CommFirst = [SELECT Id FROM Profile WHERE Name=:label.Profile_CommercialFirst];
        //create user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', CommFirst.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        listUsers.add(u2);
        //create user
        User u3 = testUtils.CreateUser('standt29', 'user3333@testorg2.com', 'Testing3', CommFirst.Id, 'user333@testor3.com');
        u3.Code_d_Appartenance__c='OCECOM2';
        listUsers.add(u3);
        User u1 = testUtils.CreateUser('standt12', 'user21111@testorg2.com', 'Testing5',Label.AdminProfileId, 'user5r@testorg5.com');
        listUsers.add(u1);
        insert listUsers;
        //create and insert Account
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        
        //create and insert Contract
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.OwnerId = u2.Id;
        insert c1;
        List<objectif__c>ListObjectifs=new List<objectif__c>();
        objectif__c obj1=testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.valueof(System.Today().year()));
        obj1.Commercial__c=u2.Id;
        obj1.recordTypeId = Schema.SObjectType.Objectif__c.getRecordTypeInfosByName().get('Commercial Agence One').getRecordTypeId();
        Test.startTest();
        insert obj1;
        obj1.Commercial__c=u3.Id;
        update obj1;
        c1.ownerid = u3.Id;
        update c1;
        System.runAs(u1) {
            u3.profileid = Label.AdminProfileId;
            update u3;
            u3.profileid = CommFirst.Id;
            update u3;
        }
        delete c1;
        Test.stopTest();
    }
    
    @isTest
    static void testinitContratsPerdus() {
        Profile CommFirst = [SELECT Id FROM Profile WHERE Name=:label.Profile_CommercialFirst];
        //create user 
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', CommFirst.Id, 'user2rrr@testorg2.com');
        insert u2;
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.OwnerId = u2.Id;
        c1.TechTotalCABudgetP1P2P3P4__c = 100;
        c1.TechTotalMBBudgetP1P2P3P4__c = 200;
        insert c1;
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.ContratOrigine__c=c1.id;
        myOpp.Annee_de_signature__c=String.valueof(System.Today().year());
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Opp_type_Renewal;
        insert myOpp;
        Fiche_de_synthese__c fds =  testUtils.createFDS();
        fds.Opportunit_commerciale__c = myOpp.Id;
        fds.OffreA1P2VentesServices__c = 100;
        insert fds;
        Contact contct = testUtils.createContact('Test',a1.Id, null);
        insert contct;
        OpportuniteContact__c oppCont = new OpportuniteContact__c (opportunite__c = myOpp.Id,Contact__c = contct.Id);
        insert oppCont;
        myOpp.TypeReconduction__c = Label.PV_Reconduction_Tacite;
        myOpp.StageName = Label.PV_Realisation;
        myOpp.Statut__c = Label.PV_StatutPerdu;
        myOpp.ZZZ_TECH_RealiseDuChemin__c = true;
        myOpp.motif__c = 'Abandon du projet';
        
        Test.startTest();
        update myOpp;
        c1.Statut__c = Label.ContratFerme;
        update c1;
        objectif__c obj1=testUtils.CreateObjectif('testObj1', null, String.valueof(System.Today().year()));
        obj1.Commercial__c=u2.Id;
        obj1.recordTypeId = Schema.SObjectType.Objectif__c.getRecordTypeInfosByName().get('Commercial Agence One').getRecordTypeId();
        insert obj1;
        Test.stopTest();
    }
}