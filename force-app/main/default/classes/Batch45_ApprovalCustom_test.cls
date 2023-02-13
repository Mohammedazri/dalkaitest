/**
* @author Jacques Akiki -EI Technologies
* @date 05/02/2019
* @description Test Class for Batch45_ApprovalCustom 
*/
@istest(SeeAllData=true)
public class Batch45_ApprovalCustom_test {
    @istest 
    static void testApproval()
    {
        Id BatchId = Database.executeBatch(new Batch45_ApprovalCustom(' Limit 100'));
    }
}