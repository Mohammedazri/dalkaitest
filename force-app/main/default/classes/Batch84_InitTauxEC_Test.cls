/**
* @author Dona Kfoury -EI Technologies
* @date 10/07/2020
* @description Test Class for Batch84_InitTauxEC
*/
@isTest
public class Batch84_InitTauxEC_Test {
    @isTest
    static void testinitContratEC()
    {
        list<User> listUsers = new list<User>();
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE Name=:label.Profile_DACFirst];
        //create user and add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        listUsers.add(u2);
        //create user and add bypass
        User u3 = testUtils.CreateUser('standt29', 'user3333@testorg2.com', 'Testing3', p.Id, 'user333@testor3.com');
        u3.Code_d_Appartenance__c='OCECOM2';
        listUsers.add(u3);
        insert listUsers;
        //run test as user 
        System.runAs(u2) 
        {
            //create and insert Account
            account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            myaccount.StatutPartenaire__c = 'OUV';
            insert myaccount;
            
            //create and insert Contract
            Contrat__c cont= new Contrat__c();
            cont.NomPartenaire__c=myaccount.Id;
            insert cont;
            contact mycontact = testUtils.createContact('test 4', myaccount.Id, null);
            mycontact.IsContactEspaceClient__c = true;
            contact mycontact2 = testUtils.createContact('test 5', myaccount.Id, null);
            mycontact2.IsContactEspaceClient__c = true;
            List<Contact> listCons = new list<contact>{mycontact,mycontact2};
            insert listCons;
            ContratContact__c contactContrat = testUtils.createContactContrat(cont.Id, mycontact.Id);
            ContratContact__c contactContrat2 = testUtils.createContactContrat(cont.Id, mycontact2.Id);    
            List<ContratContact__c> listConConts = new list<ContratContact__c>{contactContrat,contactContrat2};
            insert listConConts;
            
            list<Objectif__c> listObj = new list<Objectif__c>();
            Objectif__c Obj = new Objectif__c();
            Obj.Commercial__c = u2.id;
            Obj.Annee__c = '2020';
            listObj.add(Obj);
            Objectif__c Obj2 = new Objectif__c();
            Obj2.Commercial__c = u3.id;
            Obj2.Annee__c = '2020';
            listObj.add(Obj2);
            insert listObj;
            Test.startTest();            
            Id batchJobId = Database.executeBatch(new Batch84_InitTauxEC(), 2000);
            Test.stopTest();
        }
    }
}