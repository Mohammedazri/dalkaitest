/** 
* @author: Jimmy Khalil
* @date: 11/05/2022 
* @description: Ne pas autoriser l'ajout et la suppression d'un contact sur les opportunités réalisées (US C360-724)
* @Test: AP110_OpportuniteContact_test
*/
public without sharing class AP110_OpportuniteContact {
    public static void checkIfCanInsertOrDelete(list<OpportuniteContact__c>listOppContact){
        String currUserProfileId = UserInfo.getProfileId();
        //Retrieve profile name
        String userProfileName = [SELECT Name FROM Profile WHERE Id =: currUserProfileId].Name;
        
        //Only the profiles in the label can Insert/Delete Contacts on a Opportunity Realise
        if(!Label.AP110_ProfilesofAccess.contains(userProfileName)){
            Set<Id> setOppIds = new Set<Id>();
            for(OpportuniteContact__c oppContact:listOppContact){
                setOppIds.add(oppContact.Opportunite__c);
            }
            if(setOppIds.size()>0){
                Map<Id,Opportunity> mapRelatedOpp = new Map<Id,Opportunity> ([Select Id
                                                                              From Opportunity
                                                                              Where Id in: setOppIds
                                                                              And StageName=:Label.PV_Realisation]);
                for(OpportuniteContact__c oppContact:listOppContact){
                    if(mapRelatedOpp.containsKey(oppContact.Opportunite__c)){
                        oppContact.addError(Label.AP110_ErrorMessage); 
                    }
                }
            }
        }
    }
}