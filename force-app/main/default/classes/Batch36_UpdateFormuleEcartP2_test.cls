/**
* @author: Jacques Akiki -EI Technologies
* @date: 05/03/2019
* @description: 
*/
@istest
public class Batch36_UpdateFormuleEcartP2_test {
     @isTest
    static void testBudget()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u1.BypassFilters__c = true;
        insert u1;
        
        System.runAs(u1) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.OwnerID=u1.id;
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.Annee_de_signature__c='2017';
            myOpp.Statut__c = 'En cours';
            insert myOpp;
            
            //create Fiche_de_synthese__c
            /*Fiche_de_synthese__c Fiche1= New Fiche_de_synthese__c();
            Fiche1.Name='testFiche1';
            Fiche1.Opportunit_commerciale__c=myOpp.Id;
            insert Fiche1;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.P6MbOf__c=12;
                fds.P6CaOf__c=11;
            }
            Update listFDS;
            
            Batch36_UpdateFormuleEcartP2 testBatch=new Batch36_UpdateFormuleEcartP2();
            DataBase.executeBatch(testBatch);  
        }
        
    }
 
}