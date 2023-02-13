@isTest
public class AP59_PostalCodeUOPilote_test {
    @isTest
    static void TestUpdateContratActif() {
        list<uo_dalkia__c> listuoDalkia = new list<uo_dalkia__c>();
        uo_dalkia__c uoDalkia = new uo_dalkia__c();
        uoDalkia.BillingPostalCode__c = '11';
        uoDalkia.EntiteCommercialeDalkia__c = 'J00001003P';
        uoDalkia.EntiteCommercialeEDF__c = 'EDF01';
        uoDalkia.Name = 'test1';
        listuoDalkia.add(uoDalkia);
        uo_dalkia__c uoDalkia1 = new uo_dalkia__c();
        uoDalkia1.BillingPostalCode__c = '12';
        uoDalkia1.EntiteCommercialeDalkia__c = 'J00001002N';
        uoDalkia1.EntiteCommercialeEDF__c = 'EDF02';
        uoDalkia1.Name = 'test2';
        listuoDalkia.add(uoDalkia1);
        insert listuoDalkia;
        Test.startTest();
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        myaccount.BillingPostalCode = '121';
        update myaccount;
        Test.stopTest();
    }
}