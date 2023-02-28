/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Test Class for AP10_Objectif
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP10_Objectif_Test {
    @isTest
    static void shareObjectifTest() {
        Profile p = [SELECT Id FROM Profile WHERE id=: Label.AdminProfileId ];
        List<User>listUsers= new List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        listUsers.add(u1);
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        listUsers.add(u2);
        
        Insert listUsers;
        System.runAs(u2) {
            List<objectif__c>ListObjectifs=new List<objectif__c>();
            objectif__c obj1=testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.valueof(System.Today().year()));
            obj1.Commercial__c=u1.Id;
            Test.startTest();
            insert obj1;
            obj1.Commercial__c=u2.Id;
            obj1.ManagerDeObjectif__c = u1.Id;
            update obj1;
            Test.stopTest();
        }
    }
}