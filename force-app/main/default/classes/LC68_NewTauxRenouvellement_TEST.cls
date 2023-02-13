@isTest
public class LC68_NewTauxRenouvellement_TEST {
    
    @testSetup static void CreateObjects() {
        
        List<Agence__c> listAgc = new List<Agence__c>();
        List<ObjectifAgence__c> listObjAgc = new List<ObjectifAgence__c>();
        
        Agence__c agc1 =  new Agence__c();
        agc1.Name = 'Agence1';
        agc1.Code_Agence__c = 'DCIST';
        agc1.dkcode__c='1234';
        listAgc.add(agc1);
        
        Agence__c agc2 =  new Agence__c();
        agc2.Name = 'Agence2';
        agc2.Code_Agence__c = 'DCN';
        agc2.DkCode__c='1235';
        listAgc.add(agc2);
        
        try{
            insert listAgc;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        CodeAgence_Region__c cr = new CodeAgence_Region__c();
        cr.Name = 'test';
        cr.Code__c = 'DCN';
        cr.DkCode__c = '1234';
        insert cr;
        
        Region__c reg = new Region__c();
        reg.name = 'testReg';
        reg.DkCode__c = '1234';
        insert reg;
        
        ObjectifAgence__c objAgc1 = new ObjectifAgence__c();
        objAgc1.AgenceId__c = agc1.id;
        objAgc1.Annee__c = '2019';
        objAgc1.name = '2019';
        objAgc1.tech_AgenceAnnee__c = agc1.id+'2019';
        listObjAgc.add(objAgc1);
        
        ObjectifAgence__c objAgc2 = new ObjectifAgence__c();
        objAgc2.AgenceId__c = agc2.id;
        objAgc2.Annee__c = '2018';
        objAgc2.name = '2018';
        objAgc2.tech_AgenceAnnee__c = agc2.id+'2018';
        listObjAgc.add(objAgc2);
        
        try{
            insert listObjAgc;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        
    }
    @isTest
    public static void LC68_TEST(){
        List<User> listUsers = new List<User>();
        List<Objectif__c> listObj = new List<Objectif__c>();
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User usr = testUtils.CreateUser('tusr1', 'user1@testorgdalkia2.com', 'user1T', p.Id, 'user1@testorgdalkia2.com');
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        usr.Code_d_Appartenance__c = 'DCIST';
        usr.Nom_agence__c = 'Agence1';
        usr.Organisation__c='1234';
        listUsers.add(usr);
        
        User usr2 = testUtils.CreateUser('tusr2', 'user2@testorgdalkia2.com', 'user2T', p.Id, 'user2@testorgdalkia2.com');
        usr2.BypassValidationRules__c = true;
        usr2.Bypass_Workflow__c = true;
        usr2.Code_d_Appartenance__c = 'DCN';
        usr2.Nom_agence__c = 'Agence2';
        usr2.Organisation__c='1235';
        listUsers.add(usr2);
        
        insert listUsers;
        
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
        
        test.startTest();
        
        insert listObj;
        LC68_NewTauxRenouvellement.getTauxRenouv();
        LC68_NewTauxRenouvellement.getRapport();
        test.stopTest();
    }
}