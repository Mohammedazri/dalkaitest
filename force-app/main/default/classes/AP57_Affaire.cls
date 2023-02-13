/**
*@author Alain Ghoussoub
*@date 17/5/2019
*@description Update affaire on opportunity 
*/
public class AP57_Affaire {
        /**
*@author Alain Ghoussoub
*@date 17/5/2019
*@description Update affaire on opportunity 
*@param List opportunity
*@return void
*/
    public static void updateOpportunityAffaire(List<Opportunity> listOpp){
        system.debug('In AP57');
        Set<Id> contIds = new Set<Id>();
        for(Opportunity opp : listOpp){
            if(String.isNotBlank(opp.ContratOrigine__c)){
                contIds.add(opp.ContratOrigine__c);
            }
        }
        system.debug('contIds ' + contIds);
        List<Contrat__c> listCont = [SELECT id,AffaireContrat__c
                                     FROM Contrat__c
                                     where id in: contIds];
        system.debug('listCont ' + listCont);
        Map<String,String> contratAffaire = new Map<String,String>();
        for(Contrat__c cont : listCont){
            contratAffaire.put(cont.id,cont.AffaireContrat__c);
        }
        system.debug('contratAffaire ' + contratAffaire);
        for(Opportunity opp : listOpp){
            if(String.isNotBlank(opp.ContratOrigine__c)){
                opp.Affaire__c = contratAffaire.get(opp.ContratOrigine__c);
            }
        }
        system.debug('listOpp ' + listOpp);
    }
}