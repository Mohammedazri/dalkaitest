/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Test Class for Batch08_UnlockFDS
History
<Date>      <Authors Name>   <Brief Description of Change>
26-07-2018   Johny Kassis      Created
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch08_UnlockFDS_test 
{
    
    @isTest
    static void testBudget()
    {
        //query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create user and	 add bypass
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.Bypass_Triggers__c='AP05_Opportunity;AP14_OppRollUpSummaryUtility';
        insert u2;
        
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.ManagerId=u2.id;
        u1.BypassValidationRules__c =true;
        u1.Bypass_Triggers__c='AP05_Opportunity;AP14_OppRollUpSummaryUtility';
        insert u1;
        
        //run test as user 
        System.runAs(u1) 
        {
            //create and insert Account
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            //create and insert Contract
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            insert c1;
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.OwnerID=u1.id;
            myOpp.ContratOrigine__c=c1.Id;
            myOpp.Type_pers__c= Label.PV_Evolution;
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Annee_de_signature__c='2017';
            insert myOpp;
            
            //create Fiche_de_synthese__c
            /*Fiche_de_synthese__c Fiche1= New Fiche_de_synthese__c();
            Fiche1.Name='testFiche1';
            Fiche1.Opportunit_commerciale__c=myOpp.Id;
            Fiche1.P6MbOf__c=12;
            
            //insert  Fiche1
            insert Fiche1;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c myfds:listFDS){
                myfds.P6MbOf__c=12;
            }
            update listFDS;
            // lock the record 
            Approval.lock(listFDS[0].id);
            //call and execute the batch 
            Batch08_UnlockFDS testBatch=new Batch08_UnlockFDS();
            DataBase.executeBatch(testBatch);  
        }
        
    }
}