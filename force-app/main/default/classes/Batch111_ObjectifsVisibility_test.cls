/** 
* @author Jacques Akiki - Ei technologies
* @date 06/04/2021 
* @Test Class of Batch111_ObjectifsVisibility
*/
@isTest
public class Batch111_ObjectifsVisibility_test {
    static testMethod void testObjShare(){
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        List<user> listUserInsert = new list<User>();
        List<Objectif__c> listObjInsert = new list<Objectif__c>();
        User u1 = testUtils.CreateUser('Us1Dlk', 'user1@testdalkia.com', 'TestingU1', p.Id, 'user1Test@testdalkia.com');
        User u2 = testUtils.CreateUser('Us1Dlk', 'user2@testdalkia.com', 'TestingU2', p.Id, 'user2Test@testdalkia.com');
        listUserInsert.add(u1);
        listUserInsert.add(u2);
        insert listUserInsert;
        Objectif__c Obj = new Objectif__c();
        Obj.Commercial__c = u1.id;
        Obj.Annee__c = '2021';
        listObjInsert.add(Obj);
        Objectif__c Obj1 = new Objectif__c();
        Obj1.Commercial__c = u2.id;
        Obj1.Annee__c = '2021';
        listObjInsert.add(Obj1);
        insert listObjInsert;
        List<Objectif__share> objsh = [SELECT id FROM Objectif__Share WHERE RowCause ='Manual' AND parentId =: Obj.Id];
        delete objsh;
       
        Test.startTest();
        Id BatchId = Database.executeBatch(new Batch111_ObjectifsVisibility('2021'));
        Test.stopTest();
    }
}