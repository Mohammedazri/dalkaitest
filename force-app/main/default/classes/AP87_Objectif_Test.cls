/**
* @author Dona Kfoury -EI Technologies
* @date 14/07/2020
* @description Test Class for AP87_Objectif
*/
@isTest
public class AP87_Objectif_Test {
    @isTest
    static void testVentesADD() {
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
        a1.StatutPartenaire__c = 'OUV';
        insert a1;
        //create opp
        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
        myOpp1.AccountId=a1.Id;
        myOpp1.closeDate=Date.today();
        myOpp1.ownerid = u3.Id;
        myOpp1.statut__c =Label.Opp_StatutEnCours;
        insert myOpp1;
        //create and insert Contract
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        insert c1;
        List<objectif__c>ListObjectifs=new List<objectif__c>();
        objectif__c obj1=testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.valueof(System.Today().year()));
        obj1.Commercial__c=u2.Id;
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
            myOpp1.Action_commerciale_principale__c ='Chaudière à 1 €';
            update myOpp1;
            myOpp1.ownerid=u2.id;
            update myOpp1;
            delete myopp1;
        }
        delete c1;
        Test.stopTest();
    }

}