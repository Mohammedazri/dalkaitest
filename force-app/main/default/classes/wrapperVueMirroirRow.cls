/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used by the Lightning controller LC03_VueMirroir_Controller and the lightning component LC03_VueMirroir 
to facilitate the display of the contact information.
Test Class: -
--------------------------------------------------------------------------------------------------------------------------*/
public class wrapperVueMirroirRow {
    @AuraEnabled
    public Contact theContact;
    @AuraEnabled
    public list<Contact_User__c> listInternes;
    @AuraEnabled
    public list<wrapperVueMirroirRow> listChildren;
    @AuraEnabled
    public list<wrapperEvent> listEvents;
    @AuraEnabled
    public Integer NbreEventRealise; 
    @AuraEnabled
    public Boolean isSearched;
    @AuraEnabled
    public Boolean isParentOfSearched;
    @AuraEnabled
    public string DerniereRencontre;
    @AuraEnabled
    public string SatisfactionyUrl;
    @AuraEnabled
    public Boolean isRoot;
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: wrapper class used to store the events of the contact 
Test Class: -
--------------------------------------------------------------------------------------------------------------------------*/
    public class wrapperEvent{
        @AuraEnabled
        public ID theEventID;
        @AuraEnabled
        public Event theEventObj;
        @AuraEnabled
        public list<ContentDocumentLink> AttachedFiles;
        
    }
}