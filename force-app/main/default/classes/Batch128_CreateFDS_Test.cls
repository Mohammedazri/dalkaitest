/**
* @author Jimmy Khalil - EIT Mena
* @date 26/07/2022
* @description Test Class Batch128_CreateFDS
*/

@isTest
public class Batch128_CreateFDS_Test {
    
    @isTest
    static void  testBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.Bypass_triggers__c = 'AP116_Opportunity';
        insert u2;
        
        u2 = [SELECT id, Bypass_triggers__c
              FROM User
              WHERE id=:u2.Id];
        
        PAD.PAD_BypassTrigger=';'+u2.Bypass_Triggers__c+';'; 
        
        String myOpp2Id;
        
        
        System.runAs(u2) 
        {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = 'OUV';
            insert myaccount;
            
            //Opps at Etude or Piste wihtout FDS -> Bypass on "AP116_Opportunity"
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
            myOpp2.AccountId=myaccount.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.Amount=3;
            myOpp2.Type_pers__c = Label.PV_Opp_Type_Nouveau;
            insert myOpp2;
            
            myOpp2Id = myOpp2.Id;
            
        }
        
        List<Fiche_de_synthese__c> relatedFDS= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__r.Id =: myOpp2Id];
        System.assertEquals(0, relatedFDS.size());
        
        Test.startTest();
        Id BatchId = Database.executeBatch(new Batch128_CreateFDS());
        Test.stopTest();
        
        relatedFDS= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__r.Id =: myOpp2Id];
        System.assertEquals(1, relatedFDS.size());
        
        
    }
    
}