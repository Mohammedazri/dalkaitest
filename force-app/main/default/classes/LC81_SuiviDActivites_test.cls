/** 
* @author Jacques Akiki
* @date 07/07/2020 
* @test Class of LC81_SuiviDActivites_Cont
*/

@isTest
public class LC81_SuiviDActivites_test {
    static testMethod void testGetProfile() 
    {
        LC81_SuiviDActivites_cont.getProfile();
        Profile p = [SELECT Id FROM Profile WHERE name='Commercial'];
        User u1 = testUtils.CreateUser('standt28', 'user1111@testorg2.com', 'Testing2', p.Id, 'user1rrr@testorg2.com');
        insert u1;
        system.runAs(u1)
        {
            LC81_SuiviDActivites_cont.getProfile();
        }
    }
}