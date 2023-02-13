/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki  
Company: EI-Technologies
Description: Test Class for Class Batch28_UpdateChampVisionRelationAccount  
History
<Date>      <Authors Name>   <Brief Description of Change>
14/12/2018   Jacques AKiki      Creation
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP42_Account_test 
{
    @isTest
    static void  TestMeth() 
    {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c =true;
        insert u2;
        
        System.runAs(u2) 
        {
            //create Account
            account a1= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            //a1.QualitePartenaire__c = 'OPT';
            a1.Qualification__c = label.Qual_First;
            insert a1;
            Test.startTest(); 
            //a1.QualitePartenaire__c = 'PRE';
            a1.Qualification__c = label.Qual_NA;
            update a1;
            Test.stopTest();
        }
    }
}