/**
* @author: Rita Bejjani -EI Technologies
* @date: 25/04/2019
* @description: Test Class for "AP56_UserAgence" 
*/
@isTest
public class AP56_UserAgence_Test {
    
    @isTest
    public static void CheckUserAgenceTest()
    {
        List<Agence__c> listAgc = new List<Agence__c>();
        List<ObjectifAgence__c> listObjAgc = new List<ObjectifAgence__c>();
        List<Objectif__c> listObj = new List<Objectif__c>();
        
        Agence__c agc1 =  new Agence__c();
        agc1.Name = 'agence2';
        agc1.DkCode__c='1234';
        listAgc.add(agc1);
        
        Agence__c agc2 =  new Agence__c();
        agc2.Name = 'agence2';
        agc2.DkCode__c='1235';
        listAgc.add(agc2);
        
        try{
            insert listAgc;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        List<User> listUsers = new List<User>();
        User usr = testUtils.CreateUser('BatchR', 'BacthR@testorg.com', 'BatchRT', p.Id, 'BatchR@testorg.com');
        usr.Nom_agence__c = 'agence1';
        usr.Organisation__c='1234';
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        listUsers.add(usr);
        
        User usr2 = testUtils.CreateUser('BatchRt', 'BacthRt@testorg.com', 'BatchRTt', p.Id, 'BatchRt@testorg.com');
        usr2.BypassValidationRules__c = true;
        usr2.Organisation__c='1235';
        usr2.Bypass_Workflow__c = true;
        usr2.Nom_agence__c = 'agence2';
        listUsers.add(usr2);
        
        try{
            insert listUsers;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        
        ObjectifAgence__c objAgc1 = new ObjectifAgence__c();
        objAgc1.AgenceId__c = agc1.id;
        objAgc1.Annee__c = '2019';
        objAgc1.tech_AgenceAnnee__c = agc1.id+'2019';
        listObjAgc.add(objAgc1);
        
        try{
            insert listObjAgc;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        
        Objectif__c obj1 = testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial,'2019');
        obj1.Commercial__c = usr.Id;
        obj1.ObjectifAgenceId__c = objAgc1.id;
        obj1.ObjectifsenCA__c = 10;
        obj1.ObjectifsenMB__c = 5;
        ListObj.add(obj1);
        
        Objectif__c obj2 = testUtils.CreateObjectif('testObj2', label.Objectif_RT_Commercial,'2019');
        obj2.Commercial__c = usr2.Id;
        obj2.ObjectifAgenceId__c = objAgc1.id;
        obj2.ObjectifsenCA__c = 10;
        obj2.ObjectifsenMB__c = 5;
        ListObj.add(obj2);
        
        try{
            insert ListObj;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        
        usr2.Nom_agence__c = 'agence1';
        usr2.Organisation__c='1234';
        update usr2;
    }

}