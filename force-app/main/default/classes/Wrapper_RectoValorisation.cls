/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: wrapper class used by the Lightning controller LC34_RectoValorisation_Controller  
to facilitate the display of the table. each line in the table is represented by an instance of this class
Test Class:  LC34_RectoValorisation_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
03/07/2018   Johny Kassis      Created
--------------------------------------------------------------------------------------------------------------------------*/
global class Wrapper_RectoValorisation implements Comparable {
    
    @AuraEnabled   
    public Decimal Realise;			//value of the first element in the line 
    @AuraEnabled   
    public Decimal Budget;			//value of the second element in the line 
    @AuraEnabled   
    public Decimal Saisie;    		//value of the third element in the line 
    @AuraEnabled   
    public Decimal Offre;			//value of the forth element in the line 
    @AuraEnabled   
    public Decimal Ecart;			//value of the fifth element in the line
    @AuraEnabled   
    public String ApiNameSaisie;   	//API name of the field in whose value is displayed in the third element 
    @AuraEnabled   
    public String ApiNameOffre; 	//API name of the field in whose value is displayed in the forth element 
    @AuraEnabled   
    public String ApiNameBudget;   	//API name of the field in whose value is displayed in the second element 
    @AuraEnabled   
    public String ApiNameRealise;  	//API name of the field in whose value is displayed in the first element 
    @AuraEnabled   
    public String ApiNameEcart;  	//API name of the field in whose value is displayed in the fifth element
    @AuraEnabled   
    public boolean editable;   		//field that indicates if the last 2 elements can be edited
    
    @AuraEnabled   
    public Integer lineNumber;		// variable that indicates the line number
    @AuraEnabled   
    public String Title ;			// variable that indicates the title of the line
    @AuraEnabled   
    public String Title1 ;			// variable that indicates the title of the section
    @AuraEnabled   
    public integer rowspan ;		// variable that indicates how many line in the section
    
    @AuraEnabled   
    public String symbol1;			//variable containing the symbol that is going to be displayed after the first element
    @AuraEnabled   
    public String symbol2;			//variable containing the symbol that is going to be displayed after the first element
    @AuraEnabled   
    public String symbol3;			//variable containing the symbol that is going to be displayed after the first element
    @AuraEnabled   
    public String symbol4;			//variable containing the symbol that is going to be displayed after the first element
    
    @AuraEnabled   
    public String budgetYear;      //variable containing the year of the Budget 
    @AuraEnabled   
    public String realiseYear;      //variable containing the year of the realise  
    
    @AuraEnabled   
    public String PreviousChanges;      //String containing the changed fields
    
    
    // method used when calling the function sort(). So that the list will be sorted based on the line number
    global  Integer compareTo(Object compareTo)
    {
        Wrapper_RectoValorisation compareToEmp = (Wrapper_RectoValorisation)compareTo;
        if (lineNumber > compareToEmp.lineNumber) return 1;
        else return -1;   
    }
    
}