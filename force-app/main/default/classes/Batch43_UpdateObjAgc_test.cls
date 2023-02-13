/**
* @author: Rita Bejjani -EI Technologies
* @date: 23/04/2019
* @description: Test Class for "Batch43_UpdateObjAgc" 
*/
@istest
public class Batch43_UpdateObjAgc_test {
    @istest
    public static void UpdateObjAgcTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        List<User> listUsers = new List<User>();
        User usr = testUtils.CreateUser('BatchR', 'BacthR@testorg.com', 'BatchRT', p.Id, 'BatchR@testorg.com');
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        listUsers.add(usr);
        
        User usr2 = testUtils.CreateUser('BatchRt', 'BacthRt@testorg.com', 'BatchRTt', p.Id, 'BatchRt@testorg.com');
        usr2.BypassValidationRules__c = true;
        usr2.Bypass_Workflow__c = true;
        listUsers.add(usr2);
        
        try{
            insert listUsers;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }
        
        System.runAs(usr) 
        {
            List<Agence__c> listAgc = new List<Agence__c>();
            List<ObjectifAgence__c> listObjAgc = new List<ObjectifAgence__c>();
            List<Objectif__c> listObj = new List<Objectif__c>();
            
            Agence__c agc1 =  new Agence__c();
            agc1.Name = 'test1';
            listAgc.add(agc1);
            
            Agence__c agc2 =  new Agence__c();
            agc2.Name = 'test2';
            listAgc.add(agc2);
            
            try{
                insert listAgc;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
            }
            
            ObjectifAgence__c objAgc1 = new ObjectifAgence__c();
            objAgc1.AgenceId__c = agc1.id;
            objAgc1.Annee__c = '2019';
            objAgc1.tech_AgenceAnnee__c = agc1.id+'2019';
            listObjAgc.add(objAgc1);
            
            ObjectifAgence__c objAgc2 = new ObjectifAgence__c();
            objAgc2.AgenceId__c = agc2.id;
            objAgc2.Annee__c = '2018';
            objAgc2.tech_AgenceAnnee__c = agc2.id+'2018';
            listObjAgc.add(objAgc2);
            
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
            
            
            Objectif__c obj3 = testUtils.CreateObjectif('testObj3', label.Objectif_RT_Commercial,'2018');
            obj3.Commercial__c = usr.Id;
            obj3.ObjectifAgenceId__c = objAgc2.id;
            obj3.ObjectifsenCA__c = 15;
            obj3.ObjectifsenMB__c = 10;
            ListObj.add(obj3);
            
            Objectif__c obj4 = testUtils.CreateObjectif('testObj4', label.Objectif_RT_Commercial,'2018');
            obj4.Commercial__c = usr2.Id;
            obj4.ObjectifAgenceId__c = objAgc2.id;
            obj4.ObjectifsenCA__c = 20;
            obj4.ObjectifsenMB__c = 12;
            ListObj.add(obj4);
            
            try{
                insert listObj;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
            }
            
            set<id> setObjAgcID = new set<id>();
            List<Objectif__c> listObjID = [select ObjectifAgenceId__c from Objectif__c];
            for(Objectif__c obj : listObjID){
                setObjAgcID.add(obj.ObjectifAgenceId__c);
            }
            
            test.startTest();
            Id batchJobId  = Database.executeBatch(new Batch43_UpdateObjAgc(setObjAgcID));
            test.stopTest();
            
            integer count = 0;
            List<ObjectifAgence__c> listAfterTest = [select Total_objectifs_en_CA__c,Total_objectifs_en_MB__c from ObjectifAgence__c];
            for(ObjectifAgence__c objAgcTest : listAfterTest){
                system.debug('Objectif Agence '+count+'  totals: '+ objAgcTest.Total_objectifs_en_CA__c+' '+objAgcTest.Total_objectifs_en_MB__c);
                count++;
            }
            count = 0;
            List<Objectif__c> listObjAfterTest = [select Total_objectifs_en_CA__c,Total_objectifs_en_MB__c from Objectif__c];
            for(Objectif__c objTest : listObjAfterTest){
                system.debug('Objectif '+count+'  totals: '+ objTest.Total_objectifs_en_CA__c+' '+objTest.Total_objectifs_en_MB__c);
                count++;
            }
            
        }
    }
    
}