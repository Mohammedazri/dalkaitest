/** 
* @author Jacques Akiki 
* @date 02/12/2020 
* @Test Class for Batch106_ContactNPS
*/
@isTest
public class Batch106_ContactNPS_test {
    @isTest
    static void testBatch105()
    {
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = label.WS11_OUV;
        insert myaccount;
        
        Contact cont = testUtils.createContact('test', myaccount.id, null);
        cont.Supporteur__c = 'Promoteur';
        insert cont;
        Id BatchId = Database.executeBatch(new Batch106_ContactNPS());
        
    }
}