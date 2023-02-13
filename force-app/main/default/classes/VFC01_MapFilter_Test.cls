/**
 * This class contains unit tests for validating the behavior of the Apex class VFC01_MapFilter
 */
@isTest
private class VFC01_MapFilter_Test {
   
    @isTest
    static void testController() {
        VFC01_MapFilter controller = new VFC01_MapFilter();
        controller.Load_Marker_Wrapper(); 
    }
}