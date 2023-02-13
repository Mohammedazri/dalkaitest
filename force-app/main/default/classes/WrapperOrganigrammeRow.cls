/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used by the Lightning controller LC04_Organigramme_Controller and the lightning component LC04_Organigramme
Test Class: -
--------------------------------------------------------------------------------------------------------------------------*/
public class WrapperOrganigrammeRow {
    @AuraEnabled
    public Contact theContact;
    @AuraEnabled
    public list<WrapperOrganigrammeRow> listChildren;
    
}