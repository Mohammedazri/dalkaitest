@isTest
public class Batch65_UpdateUserSignature_test {
    static testMethod void tesUpdateUserSignature(){
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create the user 
        User usr = testUtils.CreateUser('standt28', 'user-TestSig@dalkiadev.com', 'Testing2', p.Id, 'user-TestSig@dalkiadev.com'); 
        usr.FirstName= 'Usr-Test';
        usr.Department = 'Logistics';
        usr.Phone='12213211';
        usr.Title = 'manager';
        usr.isActive= true;
        insert usr;// insert the user
        
        Test.startTest();
        usr.Signature = null;
        update usr; // change some fields to invoke the update trigger
        Id BatchId = Database.executeBatch(new Batch65_UpdateUserSignature(' AND id=\''+usr.id+'\''));
        Test.stopTest();
        
    }
}