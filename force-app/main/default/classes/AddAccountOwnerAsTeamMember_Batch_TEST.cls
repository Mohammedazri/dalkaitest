/*--------------------------------------------------------------------------------------------------------------------------
Author: Ahmad Koubeissy
Company: EI-Technologies
Description: Test Class for AddAccountOwnerAsTeamMember_Batch
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AddAccountOwnerAsTeamMember_Batch_TEST{
    @isTest
    public static void test_batch(){
        account acc = testUtils.createAccount('test Account','test','Public');
        insert acc;
        //the account will have one team member by default which is the owner
        
        delete [select id from accountteammember where accountid=:acc.id];
        system.assertEquals(0, [Select id from accountTeamMember where accountid=:acc.id].size());
        
        AddAccountOwnerAsTeamMember_Batch batch= new AddAccountOwnerAsTeamMember_Batch();
        database.executeBatch(batch);
        
    }
}