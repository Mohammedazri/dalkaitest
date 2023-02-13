/**
* @author Dona Kfoury -EI Technologies
* @date 11/09/2020
* @description Test Class for AP92_Objectif
*/
@isTest
public class AP97_ContactSatisfaction_test {
    @isTest
    static void testContact() {
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
        Contact_Satisfaction__c cs = new Contact_Satisfaction__c (contact__c = listCont[0].id,
                                                                  name = Label.EnqSMILE , 
                                                                  NumeroEnquete__c = Null , 
                                                                  IndicateurSatisfaction__c = '8/10' ,
                                                                  Note_recommandation__c = '7/10');
        Contact_Satisfaction__c cs1 = new Contact_Satisfaction__c (contact__c = listCont[1].id,
                                                                  name = Label.EnqSMILE , 
                                                                  NumeroEnquete__c = Null , 
                                                                  IndicateurSatisfaction__c = '8/10' ,
                                                                  Note_recommandation__c = '7/10');
        insert cs;
        insert cs1;
    }
}