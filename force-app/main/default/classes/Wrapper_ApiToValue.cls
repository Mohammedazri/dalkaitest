/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used by the Lightning controller LC34_RectoValorisation_Controller  
             to send the updated fields and their new values from the lightning component to the apex controller 
Test Class: -
History
<Date>      <Authors Name>   <Brief Description of Change>
03/07/2018   Johny Kassis      Created
--------------------------------------------------------------------------------------------------------------------------*/
public class Wrapper_ApiToValue {
    @AuraEnabled   
    public String ApiName{get;set;}			// variable used to store the API name	of the field
    @AuraEnabled   
    public Decimal FieldValue{get;set;}		// variable used to store the value of the field
}