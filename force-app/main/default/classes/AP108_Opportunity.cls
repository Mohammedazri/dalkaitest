/** 
* @author: Jacques Akiki
* @date: 15/04/2022 
* @description:Ne pas permettre aux utilisateurs dont le profil n'est pas dans l'etiquette ProfilsCanDeleteContact de supprimer des contacts 
* @Test: Class AP108AP109_test
*/
public without sharing class AP108_Opportunity {
/*Methode pour verifier si une opportunité a des contacts actifs à la realisation ou au passage à proposition*/
public static void contactObligatoire(list<Opportunity> listNewOpp, Map<id,Opportunity> mapOldOpp) {
    map<id,Integer> mapOppContact = new map<id,Integer>();
    for(Opportunity opp:listNewOpp){
        if(opp.StageName != mapOldOpp.get(opp.id).StageName && (opp.StageName ==Label.LC28_Proposition || opp.StageName ==Label.PV_Realisation )){
            mapOppContact.put(opp.id,0);
        }
    }   
    if (mapOppContact!=NULL && mapOppContact.keyset().size()>0){
        AggregateResult[] listOppCont = [SELECT count(id)numberContact,Opportunite__c FROM OpportuniteContact__c WHERE Opportunite__c in:mapOppContact.keyset() and Contact__r.Statut__c=:Label.PV_Contact_Actif group by Opportunite__c];
        if(listOppCont!=NULL){
            for(AggregateResult agg : listOppCont){
                mapOppContact.put((id)agg.get('Opportunite__c'),(integer)agg.get('numberContact'));
            }
            for(Opportunity opp:listNewOpp){
                if(!mapOppContact.containsKey(opp.id) || mapOppContact.get(opp.id)==0){
                    opp.addError(label.AP108_Erreur);
                }
            }
        }
    else{
        for(Opportunity opp:listNewOpp){
            opp.addError(label.AP108_Erreur);
        }
    }
    }
}
}