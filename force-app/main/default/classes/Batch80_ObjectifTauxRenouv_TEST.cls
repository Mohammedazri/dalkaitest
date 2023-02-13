@istest
public class Batch80_ObjectifTauxRenouv_TEST {
@istest
    public static void UpdateTauxObjTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        Profile DAC = [SELECT Id FROM Profile WHERE Name=:label.Profile_DACFirst];
        List<User> listUsers = new List<User>();
        User usr = testUtils.CreateUser('BatchR', 'BacthR@testorg.com', 'BatchRT', p.Id, 'BatchR@testorg.com');
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        listUsers.add(usr);
        
        User usr2 = testUtils.CreateUser('BatchRt', 'BacthRt@testorg.com', 'BatchRTt', DAC.Id, 'BatchRt@testorg.com');
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
            List<Objectif__c> listObj = new List<Objectif__c>();
            Objectif__c obj1 = testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial,'2019');
            obj1.Commercial__c = usr2.Id;
            obj1.ObjectifsenCA__c = 10;
            obj1.ObjectifsenMB__c = 5;
            string currentYear = string.valueOf(System.Today().year());
            obj1.Annee__c = currentYear;
            ListObj.add(obj1);
            
            insert ListObj;
            
            test.startTest();
            Id batchJobId  = Database.executeBatch(new Batch80_ObjectifTauxRenouv());
            test.stopTest();
        }
    }
}