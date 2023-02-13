/**
* @author: Rita Bejjani - EI Technologies
* @date: 07/05/2019
* @description: Test Class for "Batch46_UpdateUserAgc" 
*/

@isTest
public class Batch46_UpdateUserAgc_Test {
    
    @isTest
    static void UpdateUserAgcTest() 
    {
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User usr = testUtils.CreateUser('BatchR', 'BacthR@testorg.com', 'BatchRT', p.Id, 'BatchR@testorg.com');
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        usr.IsActive = true;
        usr.Code_d_Appartenance__c = 'DCIST';
        usr.Nom_agence__c = 'test1';
        usr.Organisation__c = '12345';
        insert usr; // inserting user to test
        
        Siege__c siege = new Siege__c();
        siege.Name = 'Dalkia';
        siege.Code_Siege__c = 'SIE12';
        
        insert siege;
        
        Region__c reg = new Region__c();
        reg.Name = 'Paris';
        reg.Siege__c = siege.Id;
        reg.Code_Region__c = 'REG12';
        
        insert reg;
        
        Agence__c agc1 =  new Agence__c();
        agc1.Name = 'agence1';
        agc1.Code_Agence__c = 'DCIST';
        agc1.Region__c = reg.Id;
        agc1.DkCode__c ='12345';
        insert agc1;
        
        test.startTest();
        Id batchJobId  = Database.executeBatch(new Batch46_UpdateUserAgc('and id = \''+usr.id+'\''));
        test.stopTest();
        
        User usrT = [SELECT id, Nom_agence__c, Nom_region__c, Nom_siege__c
                     FROM User
                     WHERE id = :usr.Id];
        
        //to view updated field values : agence1, Paris, Dalkia
        system.debug('------'+ usrT.Nom_agence__c + ' ' + usrT.Nom_region__c + ' ' + usrT.Nom_siege__c +'------');
    }
}