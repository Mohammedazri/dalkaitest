/**
* This class contains unit tests for validating the behavior of Apex classes LC16_CreationObjectif_Controller
*/
@isTest
public class LC16_CreationObjectif_Controller_Test {
    
    @isTest
    static void CreationObjectif() {
        Test.startTest();
        LC16_CreationObjectif_Controller.canCreateObjectif(); 
        Test.stopTest();
    }
}