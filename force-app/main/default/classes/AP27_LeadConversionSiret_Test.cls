/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: test class for AP27_LeadConversionSiret
History
<Date>      <Authors Name>   <Brief Description of Change>
10-07-2018   Johny Kassis        Created
--------------------------------------------------------------------------------------------------------------------------*/
@istest
public class AP27_LeadConversionSiret_Test {
    
    // test method 
    @istest
    static void  AP27_MethodsTest()
    {
        // query the admin profil
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId]; 
        //create a user
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c=true;// add bypass privileges
        u2.BypassFilters__c = true ;
        insert u2;// insert the user
        // run test as user 
        System.runAs(u2) 
        {
            // Create a lead 
            lead leadTest = testUtils.CreateLead('test', 'Lead', 'test Company');
            leadTest.siret__c='392043';
            insert leadTest;
            
            test.startTest(); // start test
            leadTest.City = 'Explore';
            update leadTest;
            //Convert the lead
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(leadTest.id); 
            lc.setConvertedStatus('Converti');
            
            // Create the mock response based on a static resource
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('GetSireneForTestClass');
            mock.setStatusCode(200);
            mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
            
            // Associate the callout with a mock response
            Test.setMock(HttpCalloutMock.class, mock);        
            
            // assert method 
            try
            {
                Database.LeadConvertResult lcr = Database.convertLead(lc);// get the result of the converted lead 
            }
            Catch (Exception e)
            {
                System.assert(e.getMessage().contains(Label.AP27_ErrorMsg)); // catch the error message and check if itcontains the message added in the class AP27
            }
            
            test.stopTest();// stop the test
        }
    }
    
}