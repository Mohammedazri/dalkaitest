/**
* @author Jacques Akiki
* @date 31/08/2020
* @description Test Class for Batch90_UpdateOppMereEvol
*/
@isTest
public class Batch90_UpdateOppMereEvol_test {
    @isTest
    static void  testOppEvolMere() 
    {
        // Create an Account
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        
        
        opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.accountId=a1.Id;
        myOpp1.EstOpportuniteMere__c = true;
        myOpp1.NatureOpportunitMere__c = Label.batch59_Reseau;
        myOpp1.Type_pers__c = Label.Evolution;
        //myOpp1.Record_type__c = Label.OppType_EvRen;
        insert myOpp1;
        
        Id BattchId = Database.executeBatch(new Batch90_UpdateOppMereEvol());
        
    }
}