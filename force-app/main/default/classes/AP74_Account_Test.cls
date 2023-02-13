@isTest
public class AP74_Account_Test {
    static testMethod void testUpdatePartenaire()
    {
        Id soctRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.RT_Acc_Soc).getRecordTypeId();
        Id partRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.RT_ACC_Partenaire).getRecordTypeId();
        //create account
        account myaccount= testUtils.createAccount('Société', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.Grand_compte_EDF__c = true;
        myaccount.GrandCompteDalkia__c = false;
        myaccount.RecordTypeId = soctRT;
        myaccount.SIRET__c = '';
         insert myaccount;
        
        account myaccount1= testUtils.createAccount('Partenaire', 'Lebanon', 'Privé');
        myaccount1.Lieu_immatriculation_legale__c = 'test1';
        myaccount1.RecordTypeId = partRT;
        myaccount1.Code_NACE__c='112';
        myaccount1.parentId = myaccount.id;
        insert myaccount1;
        
        Test.startTest();
        myaccount.GrandCompteDalkia__c=true;
        TriggerUtility.RunOnce = false;
        update myaccount;
        Test.stopTest();

    }
}