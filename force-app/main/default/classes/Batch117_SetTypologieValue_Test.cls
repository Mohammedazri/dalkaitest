/**
* @author Jimmy Khalil - Ei technologies
* @date 02/08/2021
* @description Test Class for Batch117_SetTypologieValue
*/
@isTest
public class Batch117_SetTypologieValue_Test {
    @isTest
    static void testTypologie() {
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        list<Contact> listCont = new list<Contact>();
        Contact cont = testUtils.createContact('Smith', a1.id, null);
        listCont.add(cont);
                Contact cont2 = testUtils.createContact('Jane', a1.id, null);
        listCont.add(cont2);
        insert listCont;
        list<Contact_Satisfaction__c> listContSat = new list<Contact_Satisfaction__c>();
        Contact_Satisfaction__c cs = new Contact_Satisfaction__c (contact__c = listCont[0].id,
                                                                  name = Label.EnqSMILE , 
                                                                  NumeroEnquete__c = Null , 
                                                                  IndicateurSatisfaction__c = '8/10' ,
                                                                  Note_recommandation__c = '7/10');
        listContSat.add(cs);
        Contact_Satisfaction__c cs1 = new Contact_Satisfaction__c (contact__c = listCont[1].id,
                                                                  name = 'Test' , 
                                                                  NumeroEnquete__c = Null , 
                                                                  IndicateurSatisfaction__c = '8/10' ,
                                                                  Note_recommandation__c = '7/10');
        listContSat.add(cs1);
        insert listContSat;
        Database.executeBatch(new Batch117_SetTypologieValue());
    }
}