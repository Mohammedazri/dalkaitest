/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: Class responsible of entering the field Contact_du_partenaire__c on the converted opportunity when converting a lead
Test Class: AP20_LeadConversion_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class AP20_LeadConversion {    
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-technologies
Description: function that sets the field Contact_du_partenaire__c on the converted opportunity when converting a lead
Inputs: list of leads
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void updateOpportunityContact(list<lead> listLead){
        map<id,id> mapOpportunityContact = new map<id,id>();
        map<id,Lead> mapContactIdLead = new map<id,Lead>();
        for(Lead ld:listLead) {
            if (ld.IsConverted && ld.ConvertedContactId!=NULL){
                if(ld.ConvertedOpportunityId!=NULL){
                    mapOpportunityContact.put(ld.ConvertedOpportunityId , ld.ConvertedContactId);  
                }
                mapContactIdLead.put(ld.ConvertedContactId,ld);
            }           
        }
        list<Contact> listContact = [SELECT id, RecordTypeId FROM Contact WHERE id in:mapContactIdLead.keySet()];
        Id RT_ContactPRO = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_pro').getRecordTypeId();
        for(Contact cont:listContact){
            if(cont.RecordTypeId!=RT_ContactPRO){
                mapContactIdLead.get(cont.Id).addError(Label.AP20_MessageErreur);
            }
        }
        if(mapOpportunityContact!=NULL && mapOpportunityContact.keyset() !=NULL && mapOpportunityContact.keyset().size()>0){
            map<String,OpportuniteContact__c> mapOC = new map<String,OpportuniteContact__c>();
            set<String> setUniqueId = new set<string>();
            for(Id oppId : mapOpportunityContact.keyset())
            {
                if(mapOpportunityContact.get(oppId)!=NULL)
                {
                    OpportuniteContact__c oc = new OpportuniteContact__c();
                    oc.Opportunite__c = oppId;
                    oc.Contact__c = mapOpportunityContact.get(oppId);
                    oc.tech_Unique__c = String.ValueOf(oc.Contact__c)+String.ValueOf(oc.Opportunite__c);
                    setUniqueId.add(oc.tech_Unique__c);
                    mapOC.put(oc.tech_Unique__c,oc);
                }
            }  
            list<OpportuniteContact__c> listOppContct = [SELECT id,tech_Unique__c 
                                                         FROM OpportuniteContact__c 
                                                         WHERE tech_Unique__c in:setUniqueId];
            for(OpportuniteContact__c oc:listOppContct)
            {
                if (mapOC.containskey(oc.tech_Unique__c))
                {
                    mapOC.remove(oc.tech_Unique__c);
                }
            }
            
            if (mapOC!=NULL && mapOC.values()!=NULL && mapOC.values().size()>0)
            {
                insert mapOC.values();
            }
        }
    }
}