/**
* This class contains unit tests for validating the behavior of the batch Batch16_UpdateUserFields
* Coverage 100%
*/
@isTest
public class Batch16_UpdateUserFields_Test 
{
    @isTest
    static void  Batch16_UpdateUserFieldsTest() 
    {
        // query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        // create the user
        User u3 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u3.BypassValidationRules__c =true;//add bypass 
        u3.Bypass_Triggers__c  = 'AP09_User';
        u3.Code_d_Appartenance__c = 'OCECOM';
        u3.Organisation__c='OCECOM';
        insert u3;// insert the user
        
        User u4 = testUtils.CreateUser('standt29', 'user21311@testorg2.com', 'Testing3', p.Id, 'user3rrr@testorg2.com'); 
        u4.BypassValidationRules__c =true;//add bypass 
        u4.Bypass_Triggers__c  = 'AP09_User';
        u4.Code_d_Appartenance__c = 'OCEDIR';
        u4.Organisation__c='OCEDIR';
        insert u4;// insert the user
        
        User u5 = testUtils.CreateUser('standt30', 'user21121@testorg2.com', 'Testing4', p.Id, 'user4rrr@testorg2.com'); 
        u5.BypassValidationRules__c =true;//add bypass 
        u5.Bypass_Triggers__c  = 'AP09_User';
        u5.Code_d_Appartenance__c = 'OCETEST';
        u5.Organisation__c='OCETEST';
        insert u5;// insert the user
        
        //create siège
        Siege__c sg = new Siege__c();
        sg.Name = 'GROUPE DALKIA Test';
        sg.Code_Siege__c = 'OCETEST';
        sg.NV_CODE_SIEGE_REF__c = 'ODKDG';
        insert sg;
        //create region
        Region__c rg = new Region__c();
        rg.Name = 'DALKIA FRANCE REGION TEST';
        rg.Code_Region__c = 'OCEDIR';
        rg.Siege__c = sg.Id;
        rg.DkCode__c = 'OCEDIR';
        insert rg;
        Agence__c ag = new Agence__c();
        ag.Name = 'DIRECTION TEST';
        ag.Code_Agence__c = 'OCECOM';
        ag.Nom_de_direction__c = 'GROUPE DALKIA';
        ag.Code_de_direction__c = 'ODKDG';
        ag.Region__c = rg.Id;
        ag.DkCode__c = 'OCECOM';
        insert ag;
        
        Test.startTest(); 
        // Starting the tests
        Set<Id> setIds= new Set<Id>();
        setIds.add(u3.id);
        setIds.add(u4.id);
        setIds.add(u5.id);
        //Initialiazing and calling the batch
        Batch16_UpdateUserFields testBatch=new Batch16_UpdateUserFields(setIds);
        DataBase.executeBatch(testBatch);
        
        Test.stopTest();
    }

    
}