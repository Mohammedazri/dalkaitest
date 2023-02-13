/**
 * This class contains unit tests for validating the behavior of Apex classes
 */
@isTest
private class VFC02_MapFilterComponent_Test {
    
    @isTest
    static void testController() {
        VFC02_MapFilterComponent controller = new VFC02_MapFilterComponent();
        controller.VFC01_MapFilter_instance = new VFC01_MapFilter();
        controller.Load_Marker_Wrapper();
    }
}