/**
* This class contains unit tests for validating the behavior of Apex classes
*/
@isTest
private class VFC03_AccountFilterComponent_Test {
    
    @isTest
    static void testController() {
        wrapperMarker wrp= new wrapperMarker();
        wrp.Name='test';
        wrp.Id='test';
        wrp.Street='test';
        wrp.City='test';
        wrp.State='test';
        wrp.Country='test';
        wrp.isCurrent=true;
        wrp.isRacine=true;
        list<wrapperMarker> Markers = new list<wrapperMarker> ();
        Markers.add(wrp);
             
        VFC03_AccountFilterComponent controller = new VFC03_AccountFilterComponent();
        controller.listAccountMarkers=Markers;
        controller.UpdateMarkers();
    }
}