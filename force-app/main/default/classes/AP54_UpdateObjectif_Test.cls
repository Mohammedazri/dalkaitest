/**
* @author: Rita Bejjani -EI Technologies
* @date: 24/04/2019
* @description: Test Class for "AP54_UpdateObjectif" 
*/
@isTest
public class AP54_UpdateObjectif_Test {
    
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
    public static void AddObjAgcIDTest(){
        
        List<User> listUsers = new List<User>();
        List<Objectif__c> listObj = new List<Objectif__c>();
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User usr = testUtils.CreateUser('tusr1', 'user1@testorg-Dalkia.com', 'user1T', p.Id, 'user1@testorg-Dalkia.com');
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        usr.Code_d_Appartenance__c = 'DCIST';
        usr.Nom_agence__c = 'Agence1';
        usr.Organisation__c='1234';
        listUsers.add(usr);
        
        User usr2 = testUtils.CreateUser('tusr2', 'user2@testorg-Dalkia.com', 'user2T', p.Id, 'user2@testorg-Dalkia.com');
        usr2.BypassValidationRules__c = true;
        usr2.Bypass_Workflow__c = true;
        usr2.Code_d_Appartenance__c = 'DCN';
        usr2.Nom_agence__c = 'Agence2';
        usr2.Organisation__c='1235';
        listUsers.add(usr2);
        
        try{
            insert listUsers;}
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
        
        test.startTest();
        
        insert listObj;
        
        test.stopTest();
        
        //AP54_UpdateObjectif.AddObjAgcID([select id,name,Nom_de_l_agence_du_commercial__c,Annee__c,ObjectifAgenceId__c from objectif__c]);
        
        integer count = 0;
        Agence__c agc2 = [select id,name from Agence__c where name = 'Agence2'];
        agc2.Name = 'Agence2';
        update agc2;
        
        List<ObjectifAgence__c> listAfterTest = [select id,name from ObjectifAgence__c];
        for(ObjectifAgence__c objAgcTest : listAfterTest){
            system.debug('Objectif Agence '+count+' : '+ objAgcTest.id+' '+objAgcTest.name); // to test if new objectifAgence are created
            count++;
        }
        
        /*count = 0;
        List<Objectif__c> listObjAfterTest = [select id,name,ObjectifAgenceId__c from Objectif__c];
        for(Objectif__c objTest : listObjAfterTest){
            system.debug('Objectif '+count+' : '+ objTest.name+' '+objTest.ObjectifAgenceId__c);// to check if the field are updated
            count++;
        }*/
        
    }
}