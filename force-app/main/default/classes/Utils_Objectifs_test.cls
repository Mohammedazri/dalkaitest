/**
* @author Jacques Akiki -EI Technologies
* @date 04/11/2020
* @description Test Class for Utils_Objectifs
*/
@isTest
public class Utils_Objectifs_test {
    @isTest
    static void testObjectif() 
    {
        Profile p = [SELECT Id FROM Profile WHERE name='Commercial'];
        User u1 = testUtils.CreateUser('testUsr', 'userTest@testorg-dalkia.com', 'Testing2', p.Id, 'userTest@testorg-dalkia.com');
        insert u1;
        
        
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.Annee_de_signature__c='2020';
        myOpp.OwnerId = u1.id;
        insert myOpp;
        
        Objectif__c myObj = testUtils.createObjectif('Test',Schema.SObjectType.Objectif__c.getRecordTypeInfosByDeveloperName().get('Objectif_Commercial').getRecordTypeId(),'2020');
        myObj.Commercial__c = u1.id;
        insert myObj;
        
        list<Objectif__c> listObj = new list<Objectif__c>();
        listObj.add(myObj);
        list<Opportunity> listOpp = new list<Opportunity>();
        listOpp.add(myOpp);
        
        Utils_Objectifs.UpdateLookupOfOpportunityCommercial(listObj,listOpp,true);
        Utils_Objectifs.UpdateLookupOfOpportunityCommercial(listObj,null,true);
        Utils_Objectifs.UpdateLookupOfOpportunityCommercial(listObj,listOpp,false);
        Utils_Objectifs.RemoveLookupOfOpportunityCommercial(listObj);
        
    }
}