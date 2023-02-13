/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Apex controller for the lightning component LC04_Organigramme used on the account layout
              which is responsible of the section => Relation Client >> Organigramme
Test Class: LC04_Organigramme_Controller_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC04_Organigramme_Controller {
    
    public static map<Id, list<Contact>> mapContactId_Children;
    

  /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this function returns a list of contacts using the wrapper class wrapperVueMirroirRow.
             these contacts are related to the accountID 
Inputs: string AccountId
Returns:list of WrapperOrganigrammeRow
----------------------------------------------------------------------------------------------------------------------------*/      
    @AuraEnabled
    public static list<WrapperOrganigrammeRow> getAccountContacts(string AccountId){
        list<Contact> listContacts = [SELECT Id, Name, ReportsToId, Type_de_fonction__c, OwnerId, Owner.Name
                                      FROM Contact
                                      WHERE AccountId =:AccountId
                                      AND statut__c !=:Label.PV_Contact_Inactif];
        
        mapContactId_Children = new map<Id, list<Contact>>();
        for(Contact theContact : listContacts){
            if(!mapContactId_Children.containsKey(theContact.ReportsToId)){
                mapContactId_Children.put(theContact.ReportsToId, new list<Contact>());
            }
            mapContactId_Children.get(theContact.ReportsToId).add(theContact);
        }
        
        list<WrapperOrganigrammeRow> returnValue = getCreateWrapperOrganigramme(null);
        system.debug('returnValue: ' + returnValue);

        return returnValue;
    }
  /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this function is used to return the children contacts of the contact in the input using the wrapper class WrapperOrganigrammeRow
Inputs: string ContactId
Returns:list of WrapperOrganigrammeRow
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static list<WrapperOrganigrammeRow> getCreateWrapperOrganigramme(Id ContactId){
        
        list<WrapperOrganigrammeRow> returnValue = new list<WrapperOrganigrammeRow>();
        if(mapContactId_Children.containsKey(ContactId)){
            for(Contact theContact : mapContactId_Children.get(ContactId)){
                WrapperOrganigrammeRow newWrapperOrganigrammeRow = new WrapperOrganigrammeRow();
                newWrapperOrganigrammeRow.theContact = theContact;
                newWrapperOrganigrammeRow.listChildren = new list<WrapperOrganigrammeRow>();
                newWrapperOrganigrammeRow.listChildren.addAll(getCreateWrapperOrganigramme(theContact.Id));
                returnValue.add(newWrapperOrganigrammeRow);
            }        
        }
        return returnValue;
    }   
}