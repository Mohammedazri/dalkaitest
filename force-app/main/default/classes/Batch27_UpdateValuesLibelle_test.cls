/*------------------------------------------------------------------------------------------------------------------------------
Author: Chadi Geara
Company: EI-Technologies
Description: Test Class of Batch Batch27_UpdateValuesLibelle_test    
History
<Date>      <Authors Name>   <Brief Description of Change>
3/12/2018   Jacques Akiki      Creation
------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch27_UpdateValuesLibelle_test {
    
    @isTest
    static void  batch27_UpdateValuesLibelleTest() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Bypass_Workflow__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            Event Evnt = testUtils.createEvent(myaccount.id,null, Date.today()-1, 'Relationnel client', 5); 
            Evnt.Compterendu__c = 'Hello';
            Evnt.Rdvralise__c = false;
            insert Evnt;
            User u1 = [SELECT id, Bypass_Workflow__c from User where id =: u2.id];
            Event Evn1 = [SELECT id, Rdvralise__c from Event where id =: Evnt.id];
            
            //Create and insert an Opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.Renouvellement;
            myOpp.statut__c ='En cours';
            insert myOpp;
            
            Test.startTest(); 
            Batch27_UpdateValuesLibelle testBatch=new Batch27_UpdateValuesLibelle();
            DataBase.executeBatch(testBatch);  
            Test.stopTest();
        }
    }
}