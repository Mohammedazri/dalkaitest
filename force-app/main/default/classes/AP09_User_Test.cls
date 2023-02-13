@isTest
public class AP09_User_Test {
    static testMethod void UpdateUserFieldsTest() {
        Test.startTest();
        List<Agence__c> agenceList= new List<Agence__c>();
        Agence__c a1= new agence__c();
        a1.Code_Agence__c='OCOSCOM1';
        a1.DkCode__c='OCOSCOM1';
        agenceList.add(a1);
        Agence__c a2= new agence__c();
        a2.DkCode__c='OCOSCOM2';
        a2.Code_Agence__c='OCOSCOM2';
        agenceList.add(a2);
        insert agenceList;
        region__c r1= new region__c();
        r1.Code_Region__c='OCES';
        r1.DkCode__c='OCES';
        insert r1;
        siege__c s1 = new siege__c();
        s1.code_siege__c='DKSG';
        insert s1;
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId]; 
        List<User> NewUsersList= New List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.Code_d_Appartenance__c='OCOSCOM2';
        u1.Organisation__c='OCOSCOM2';
        insert u1;
        system.debug('##NewUsersList '+ NewUsersList);
        u1.Code_d_Appartenance__c='OCOSCOM1';
        u1.Organisation__c='OCOSCOM1';
        update u1;
        u1.Code_d_Appartenance__c='OCES';
        u1.Organisation__c='OCES';
        update u1;
        u1.Code_d_Appartenance__c='DKSG';
        u1.Organisation__c='DKSG';
        update u1;
        Test.stopTest();
    }

}