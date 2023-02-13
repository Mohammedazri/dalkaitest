/**
* @author Dona Kfoury -EI Technologies
* @date 08/09/2020
* @description Test Class for Batch Batch94_ContratsAgenceActifsDebutAnnee
*/
@isTest
public class Batch94_Test {
     @testSetup static void CreateObjects() {
        Agence__c agc1 =  testUtils.createAgence('CO - AGENCE ONE','DCIST','J00001203S');
        Agence__c agc2=  testUtils.createAgence('GE - AGENCE ONE','DCN','J00003660J');
        List<Agence__c> listAgc = new List<Agence__c>{agc1,agc2};   
            insert listAgc;
    }
	@isTest
    static void testinitAgenceContratsActifsBatch()
    {
        list<User> listUsers = new list<User>();
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE Name=:label.Profile_CommercialFirst];
        //create user and add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.Organisation__c = 'J00001203S';
        listUsers.add(u2);
        //create user and add bypass
        User u3 = testUtils.CreateUser('standt29', 'user3333@testorg2.com', 'Testing3', p.Id, 'user333@testor3.com');
        u3.Organisation__c = 'J00003660J';
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
            c1.PiloteDuContrat__c=u2.id;
            insert c1;
            list<Objectif__c> listObj = new list<Objectif__c>();
            Objectif__c Obj = new Objectif__c();
            Obj.Commercial__c = u2.id;
            Obj.Annee__c = string.valueOf(System.Today().year());
            Obj.recordTypeId = Schema.SObjectType.Objectif__c.getRecordTypeInfosByName().get('Commercial Agence One').getRecordTypeId();
            listObj.add(Obj);
            Objectif__c Obj2 = new Objectif__c();
            Obj2.Commercial__c = u3.id;
            Obj2.Annee__c = string.valueOf(System.Today().year());
            Obj2.recordTypeId = Schema.SObjectType.Objectif__c.getRecordTypeInfosByName().get('Commercial Agence One').getRecordTypeId();
            listObj.add(Obj2);
            insert listObj;
            Test.startTest();            
            Id batchJobId = Database.executeBatch(new Batch94_ContratsAgenceActifsDebutAnnee(), 2);
            Test.stopTest();
        }
    }
}