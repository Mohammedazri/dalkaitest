/**
* @author Dona Kfoury -EI Technologies
* @date 04/09/2020 
* @description Test Class for Batch Batch93_ContratsActifsDebutAnneeRAC
*/
@isTest
public class Batch93_ContratsActifsDebutAnneeRAC_test {
    @isTest
    static void testinitContratsActifsBatch()
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
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = 'OUV';
            insert a1;
            
            //create and insert Contract
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
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
            Id batchJobId = Database.executeBatch(new Batch93_ContratsActifsDebutAnneeRAC(), 200);
            Test.stopTest();
        }
    }

}