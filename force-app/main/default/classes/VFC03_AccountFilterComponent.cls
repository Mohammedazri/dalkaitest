/*--------------------------------------------------------------------------------------------------------------------------
Author: Serouj Jamijian 
Company: EI-Technologies
Description: This class is used as a controller for the component that filters based on the name of the account
Test Class: VFC03_AccountFilterComponent_Test
Pages: C03_AccountFilterComponent
History
<Date> <Authors Name> <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class VFC03_AccountFilterComponent {
    public Account Filtres{get;set;}

    public list<wrapperMarker> listAccountMarkers{get;
        set{
            listAccountMarkers = value;            
        }
    }    
    
    public PageReference UpdateMarkers() {
        if(listAccountMarkers != null){
            wrapperMarker tempMarker = new wrapperMarker();
            tempMarker.Name = 'Test Account 1';
            tempMarker.Street = 'Allée de Fontainebleau';
            tempMarker.City= 'Paris';
            tempMarker.Country = 'France';
            listAccountMarkers.add(tempMarker);
        }
        return null;
    }
}