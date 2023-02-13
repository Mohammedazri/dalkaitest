@isTest
public class AP73_User_test {
    static testMethod void tesUpdateUserSignature(){
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create the user 
        User usr = testUtils.CreateUser('standt28', 'user-TestSig@dalkiadev.com', 'Testing2', p.Id, 'user-TestSig@dalkiadev.com'); 
        usr.FirstName= 'User-Test';
        usr.Department = 'Logistics';
        usr.Phone='12213211';
        usr.Title = 'manager';
        Test.startTest();
        
        insert usr;// insert the user
        usr.FirstName = null;
        usr.title = null;
        usr.Department=null;
        usr.phone=null;
        update usr; // change some fields to invoke the update trigger
        Test.stopTest();
        
    }
}