/**
* @author: Rita Bejjani -EI Technologies
* @date: 23/04/2019
* @description: Test Class for "Batch42_CreateObjAgence" 
*/

@istest
public class Batch42_CreateObjAgence_Test {
    
    @istest
    static void CreateObjAgcTest() 
    {
        List<User> listUsers = new List<User>();
        List<Objectif__c> listObj = new List<Objectif__c>();
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User usr = testUtils.CreateUser('BatchR', 'BacthR@testorg.com', 'BatchRT', p.Id, 'BatchR@testorg.com');
        usr.BypassValidationRules__c = true;
        usr.Bypass_Triggers__c = 'AP55_ObjectifAgence';
        usr.Bypass_Workflow__c = true;
        usr.Code_d_Appartenance__c = 'DCIST';
        usr.Nom_agence__c = 'test1';
        usr.Organisation__c='1234';
        PAD.PAD_BypassTrigger+=usr.Bypass_Triggers__c;
        listUsers.add(usr);
        
        User usr2 = testUtils.CreateUser('tusr2', 'user2@testorg.com', 'user2T', p.Id, 'user2@testorg.com');
        usr2.BypassValidationRules__c = true;
        usr2.Bypass_Workflow__c = true;
        usr2.Bypass_Triggers__c = 'AP55_ObjectifAgence';
        usr2.Code_d_Appartenance__c = 'DCN';
        usr2.Nom_agence__c = 'test2';
        usr2.Organisation__c='1235';
        listUsers.add(usr2);
        
        try{
            insert listUsers;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        
        System.runAs(usr) 
        {
            List<Agence__c> listAgc = new List<Agence__c>();
            
            Agence__c agc1 =  new Agence__c();
            agc1.Name = 'test1';
            agc1.DkCode__c='1234';
            listAgc.add(agc1);
            
            Agence__c agc2 =  new Agence__c();
            agc2.Name = 'test2';
            agc2.DkCode__c='1235';
            listAgc.add(agc2);
            
            try{
                insert listAgc;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
            }
            
            Objectif__c obj1 = testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial,'2019');
            obj1.Commercial__c = usr.Id;
            listObj.add(obj1);
            
            Objectif__c obj2 = testUtils.CreateObjectif('testObj2', label.Objectif_RT_Commercial,'2019');
            obj2.Commercial__c = usr2.Id;
            listObj.add(obj2);
            
            Objectif__c obj3 = testUtils.CreateObjectif('testObj3', label.Objectif_RT_Commercial,'2018');
            obj3.Commercial__c = usr.Id;
            listObj.add(obj3);
            
            Objectif__c obj4 = testUtils.CreateObjectif('testObj4', label.Objectif_RT_Commercial,'2018');
            obj4.Commercial__c = usr2.Id;
            listObj.add(obj4);
            
            try{
                insert listObj;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
            }
            
            test.startTest();
            Id batchJobId  = Database.executeBatch(new Batch42_CreateObjAgence('2019'));
            test.stopTest();
            
        }
    }
    
}