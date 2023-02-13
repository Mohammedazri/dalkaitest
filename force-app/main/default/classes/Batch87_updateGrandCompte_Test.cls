/**
* @author: Jacques Akiki
* @date: 04/08/2020
* @description: Test Class for "Batch87_updateGrandCompte" 
*/
@isTest
public class Batch87_updateGrandCompte_Test {
    static testMethod void testAccGrandCompte()
    {
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.GrandCompteDalkia__c = true;
        insert a1;
        Id batchId = Database.executeBatch(new Batch87_updateGrandCompte());
    }
}