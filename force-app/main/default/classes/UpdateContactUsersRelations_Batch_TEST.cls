/*--------------------------------------------------------------------------------------------------------------------------
Author: Ahmad Koubeissy
Company: EI-Technologies
Description: Test Class for UpdateContactUsersRelations_Batch
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class UpdateContactUsersRelations_Batch_TEST{
    
    @isTest
    public static void test_batch(){
        account acc = testUtils.createAccount('test Account','test','Public');
        insert acc;
        
        system.assertEquals(1, [Select id from accountTeamMember where accountid=:acc.id].size());
        
        //the account will have one team member by default which is the owner
        contact con= testUtils.CreateContact('test Contact',acc.id,null);
        con.Phone ='45245';
        insert con;
        
        User User3 = testUtils.CreateUser('userTst3','test@test.com','test3',userInfo.getProfileId(),'userTest3@test.test.com');
        insert User3;
        
        contact_user__c conUser = new contact_user__c (contact_client__c= con.id, contact_interne__c = user3.id);
        insert conUser;
        
        User User2 = testUtils.CreateUser('userTest','test@test.com','test',userInfo.getProfileId(),'userTest@test.test.com');
        insert User2;
        
        AccountTeamMember atm = testUtils.CreateAccountTeamMember(acc.id,user2.id);
        insert atm;
        
        system.assertEquals(2, [Select id from accountTeamMember where accountid=:acc.id].size());
        
        UpdateContactUsersRelations_Batch batch= new UpdateContactUsersRelations_Batch();
        database.executeBatch(batch);
        
    }
}