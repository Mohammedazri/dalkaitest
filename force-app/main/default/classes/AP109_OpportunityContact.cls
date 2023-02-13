/** 
* @author: Jacques Akiki
* @date: 19/04/2022 
* @description: Ne pas permettre la supression des enregistrement de opportunités contact pour les opp prop ou realisé si pas d'autre contact actif
* @Test: AP108AP109_test
*/
public with sharing class AP109_OpportunityContact {
    public static void contactObligatoire(list<OpportuniteContact__c>listOppContact) {
        map<id,Integer>mapOppCount = new map<id,Integer>();
        for(OpportuniteContact__c oc:listOppContact){
            mapOppCount.put(oc.Opportunite__c,0);
        }
        if(mapOppCount!=NULL && mapOppCount.keyset().size()>0){
            set<id> setocId = new set<id>();
            list<OpportuniteContact__c>listOppContactActif = [SELECT id,Opportunite__r.StageName,Opportunite__c FROM OpportuniteContact__c WHERE Opportunite__c in:mapOppCount.keyset() and Contact__r.Statut__c=:Label.PV_Contact_Actif and (Opportunite__r.StageName=:Label.LC28_Proposition OR Opportunite__r.StageName=:Label.PV_Realisation)];
            for(OpportuniteContact__c oc:listOppContactActif){
                setocId.add(oc.id);
                mapOppCount.put(oc.Opportunite__c,mapOppCount.get(oc.Opportunite__c)+1);
            }
            for(OpportuniteContact__c oc:listOppContact){
                if(mapOppCount.get(oc.Opportunite__c)==1 && setocId.contains(oc.id)){
                    oc.addError(Label.AP109_Error); 
                }
            }
        }
    }
}