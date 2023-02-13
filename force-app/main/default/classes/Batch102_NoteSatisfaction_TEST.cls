/**
* @author: Jacques Akiki
* @date: 23/12/2020
* @description: Test Class for Batch102_NoteSatisfaction & Batch107_UpdateSatisfactionPartenaire 
*/
@isTest
public class Batch102_NoteSatisfaction_TEST {
static testMethod void test()
    {
        Test.startTest();
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        insert myaccount;
        List<contact> myContactList= new List<contact>();
        contact mycontact3 = testUtils.createContact('test 2', myaccount.Id, null);
        mycontact3.Phone ='45245';
        myContactList.add(mycontact3);
        contact mycontact4 = testUtils.createContact('test 3', myaccount.Id, null);
        mycontact4.Phone ='45245';
        myContactList.add(mycontact4);
        insert myContactList ;
        
        List<Contact_Satisfaction__c> listCs = new List<Contact_Satisfaction__c>();
        Contact_Satisfaction__c cs = new Contact_Satisfaction__c();
        cs.Contact__c = mycontact3.id;
        //cs.Annee__c = 2020;
        cs.IndicateurSatisfaction__c = '8/10';
        cs.Note_recommandation__c = '7/10';
        cs.NumeroEnquete__c = 2;
        listCs.add(cs);
        Contact_Satisfaction__c cs1 = new Contact_Satisfaction__c();
        cs1.Contact__c = mycontact4.id;
        //cs1.Annee__c = 2020;
        cs1.IndicateurSatisfaction__c = '7/10';
        cs1.Note_recommandation__c = '7/10';
        cs1.NumeroEnquete__c = 2;
        listCs.add(cs1);
        insert listCs;
        id BatchId = Database.executeBatch(new Batch102_NoteSatisfaction());
        Test.stopTest();
    }
}