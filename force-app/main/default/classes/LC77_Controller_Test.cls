/**
* @author Dona Kfoury -EI Technologies
* @date 15/09/2020
* @description Test Class for LC77_AgenceTauxEspaceClient_Controller
*/
@isTest
public class LC77_Controller_Test {
    
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
        insert listAgc;
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
        
        insert listObjAgc;
    }
    @isTest
    public static void LC70_TEST(){
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
        Datetime dateToday = System.today();
        Objectif__c obj1 = testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.ValueOf(dateToday.year()));
        obj1.Commercial__c = usr.Id;
        listObj.add(obj1);
              
        test.startTest();
        
        insert listObj;
        LC77_AgenceTauxEspaceClient_Controller.getAgenceTauxEC();
        test.stopTest();
    }

}