/*Test Class AP06_Objectif*/
@isTest
public class AP06_Objectif_test {
    @isTest
    static void shareObjectifTest() {
        Profile p = [SELECT Id FROM Profile WHERE id=: Label.AdminProfileId ];
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        insert u1;
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.accountId=a1.Id;
        myOpp1.OwnerId = u1.Id;
        myOpp1.Annee_de_signature__c =String.valueof(System.Today().year());
        insert myOpp1;
        Test.startTest();
        objectif__c obj1=testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.valueof(System.Today().year()));
        obj1.Commercial__c=u1.Id;
        insert obj1;
        obj1.Commercial__c = userInfo.getUserId();
        update obj1;
        Test.stopTest();
    }
}