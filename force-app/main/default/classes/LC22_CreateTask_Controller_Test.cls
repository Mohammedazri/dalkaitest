/**
* This class contains unit tests for validating the behavior of Apex classes LC22_CreateTask_Controller
*/
@isTest
public class LC22_CreateTask_Controller_Test {
    
    @isTest
    static void  testController()
    {
        Task t = new Task();
        LC22_CreateTask_Controller.SaveTask(t);
        LC22_CreateTask_Controller.getpickvalActivityType();
        LC22_CreateTask_Controller.getpickvalPriority();
        LC22_CreateTask_Controller.getpickvalStatus();
    }
}