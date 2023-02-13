/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Test Class for AP04_Contrat
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP04_Contrat_Test {
    @isTest
    static void ContractAfterInsertTest() {
        Test.startTest(); 
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCESCOM2';
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.BillingCity='test';
            myaccount.BillingPostalCode='111';
            insert myaccount;
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            //myOpp.Record_type__c=Label.OppType_EvRen;
            myOpp.accountId=myaccount.Id;
            insert myOpp;
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            Fiche1.Name='testFiche1';
            Fiche1.P1CaOf__c=8;
            Fiche1.P6MbOf__c=12;
            Fiche1.P6CaOf__c=11;
            update Fiche1;
            contrat__c mycontrat = new contrat__c();
            mycontrat.OpportuniteCommerciale__c=myOpp.Id;
            mycontrat.NomPartenaire__c=myaccount.Id;
            insert mycontrat;
            Test.stopTest();
        }
    }
    
}