@isTest
public class Batch67_ShareObjectif_test {
    static testMethod void testObjShare(){
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('Us1Dlk', 'user1@testdalkia.com', 'TestingU1', p.Id, 'user1Test@testdalkia.com');
        u1.phone = '123';
        u1.Department = 'TEST';
        u1.Title = 'TEST';
        insert u1;
        User u2 = testUtils.CreateUser('Us2Dlk', 'user2@testdalkia.com', 'TestingU2', p.Id, 'user2Test@testdalkia.com');
        u2.phone = '123';
        u2.Department = 'TEST';
        u2.Title = 'TEST'; 
        u2.ManagerId = u1.Id;
        insert u2;
        Objectif__c Obj = new Objectif__c();
        Obj.Commercial__c = u1.id;
        Obj.Annee__c = '2020';
        insert Obj;
        Objectif__share objsh = new Objectif__share();
        objsh.ParentId = Obj.id;
        objsh.UserOrGroupId = u2.id;
        objsh.RowCause = 'Manual';
        objsh.AccessLevel = 'Read';
        insert objsh;
        Test.startTest();
        Id BatchId = Database.executeBatch(new Batch67_ShareObjectif());
        Test.stopTest();
    }
}