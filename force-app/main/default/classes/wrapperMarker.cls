/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used in the class VFC02_Cartographie to define the markers on the map that is displayed by 
             the VF page VF02_Cartographie
Test Class: -
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class wrapperMarker {
    public string Name{get;set;}
    public string Id{get;set;}
    public string Street{get;set;}
    public string City{get;set;}
    public string State{get;set;}
    public string Country{get;set;} 
    public boolean isCurrent{get;set;}
    public boolean isRacine{get;set;} 
}