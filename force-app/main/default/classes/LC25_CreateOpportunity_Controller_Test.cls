/**
* This class contains unit tests for validating the behavior of Apex classes LC25_CreateOpportunity_Controller
*/
@isTest
public class LC25_CreateOpportunity_Controller_Test {
    
    @isTest
    static  void CreationOpportunity() {
        Test.startTest();
        LC25_CreateOpportunity_Controller.canCreateOpp();
        LC25_CreateOpportunity_Controller.getRecordTypes();
        Test.stopTest();
    }
    
}