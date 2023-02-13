/*--------------------------------------------------------------------------------------------------------------------------
Author: Mohamed Hussein
Company: EI-Technologies
Description: test class for the class LC21_CreateEvent_Controller
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class LC21_CreateEvent_Controller_Test {
    @isTest
    static void  testController()
    {
        Event e = new Event();
        LC21_CreateEvent_Controller.SaveEvent(e);
        LC21_CreateEvent_Controller.getpickvalType();
        LC21_CreateEvent_Controller.getpickvalTypeActivity();
    }
}