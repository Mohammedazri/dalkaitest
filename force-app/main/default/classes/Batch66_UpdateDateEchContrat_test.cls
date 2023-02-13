@isTest
public class Batch66_UpdateDateEchContrat_test {
    static testMethod void tesUpdateDateCont(){
        Contrat__c  myCont = new Contrat__c();
        myCont.name='TEST';
        myCont.DKCodeSurContrat__c=NULL;
        myCont.DateProchaineEcheance__c = Date.Today();
        insert myCont;
        
        Test.startTest();
        Id BatchId = Database.executeBatch(new Batch66_UpdateDateEchContrat());
        Test.stopTest();
    }
}