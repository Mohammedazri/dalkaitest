/*--------------------------------------------------------------------------------------------------------------------------
Author: Pierre-Joseph Bascourt
Company: EI-Technologies
Description: This class is responsible of creating and modifying Contact_User__c records when a contact is inserted or updated
Test Class: AP13_Contact_TEST
date: 23/11/2017
--------------------------------------------------------------------------------------------------------------------------*/
public class AP13_Contact {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Pierre-Joseph Bascourt
Company: EI-Technologies
Description: the following function is used in the trigger ContactAfterInsert and it creates Contact_User__c records
Inputs:List of Contacts
Returns: -
--------------------------------------------------------------------------------------------------------------------------*/
    public static void CreationRelationContactUser(List<contact> ListContacts){
        list<Contact_User__c> ContactUserList = new list<Contact_User__c>();
        
        //create a ContactUser record with the contact and his owner
        for(contact currentContact : listContacts) {
            Contact_User__c ContactUser = new Contact_User__c();
            ContactUser.Contact_Interne__c = currentContact.OwnerId;
            ContactUser.Contact_Client__c = currentContact.id;
            ContactUserList.add(ContactUser);
        }
        
        if(ContactUserList.size() > 0) {
            insert ContactUserList;
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Pierre-Joseph Bascourt
Company: EI-Technologies
Description: the following function is used in the trigger ContactAfterUpdate and it creates new Contact_User__c records and delete the old ones
Inputs:List of new Contacts and a Map of old Contacts
Returns: -
History: 17-5-2022 Modified By Jimmy to avoid AvoidSoqlInLoops
--------------------------------------------------------------------------------------------------------------------------*/
    public static void ModificationRelationContactUser(List<contact> ListNewContacts, Map<Id, Contact> OldMapcontacts){
        list<Contact_User__c> ContactUserList = new list<Contact_User__c>();
        List<Contact_User__c> ListContactUserToDelete = new List<Contact_User__c>();
        Map<Id, Id> mapIdContactOldOwner = new Map<Id, Id>();
        
        // if the contact's owner is updated, delete the relation with the former owner in the Contact_User__c
        //create a ContactUser record with the contact and his new owner
        for(contact currentContact : ListNewContacts) {
            Contact oldContact = OldMapcontacts.get(currentContact.Id);
            if(currentContact.OwnerId != oldContact.OwnerId) {
                Contact_User__c ContactUser = new Contact_User__c();
                ContactUser.Contact_Interne__c = currentContact.OwnerId;
                ContactUser.Contact_Client__c = currentContact.id;
                ContactUserList.add(ContactUser);
                mapIdContactOldOwner.put(currentContact.id, oldContact.OwnerId);
            }
        }
        
        if(mapIdContactOldOwner != null && mapIdContactOldOwner.size()>0){
            List<Contact_User__c> listOldContactUser = [Select id, Contact_Interne__c, Contact_Client__c
                                                        From Contact_User__c
                                                        Where Contact_Client__c = : mapIdContactOldOwner.keySet()
                                                        And Contact_Interne__c = : mapIdContactOldOwner.values()];
            
            For(Contact_User__c ContactUserTmp: listOldContactUser){
                if(ContactUserTmp.Contact_Interne__c == mapIdContactOldOwner.get(ContactUserTmp.Contact_Client__c)) {
                    ListContactUserToDelete.add(ContactUserTmp);
                }
            }
            
        }
        
        if(ContactUserList.size() > 0) {
            insert ContactUserList;
        }
        
        if(ListContactUserToDelete.size() > 0) {
            Delete ListContactUserToDelete;
        }
    }
}