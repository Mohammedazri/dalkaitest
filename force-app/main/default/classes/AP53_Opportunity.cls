/**
* @author: Jacques Akiki -EI Technologies
* @date: 17/04/2019
* @description: Class pour gerer le popup lors de la resiliation d'une opportunite de renouvellement
* @Test Class:AP53_Opportunity_test 
* @Coverage: 100%
*/
public class AP53_Opportunity 
{
/**
* @author: Jacques Akiki -EI Technologies
* @date: 17/04/2019
* @description: Méthode pour modifer le champ tech de visibilité
* @inputs: List<Opportunity> , Map<id,Opportunity>
* @Outputs: -
*/
    public static void UpdateVisionResiliation(List<Opportunity> ListOpp, Map<id,Opportunity> oldMap)
    {
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity Opp : ListOpp)
        {
            oppIds.add(opp.id);
        }
        List<Opportunity> oppConc = new List<Opportunity>();
        oppConc = [SELECT Id,OpportuniteDorigine__c 
                  FROM Opportunity
                  WHERE OpportuniteDorigine__c in : oppIds
                  AND Type_pers__c =: Label.PV_Opp_Type_Nouveau
                  AND OpportuniteDorigine__c!=null];
        
        Set<Id> oppWithConc = new Set<Id>();
        for(Opportunity opp : oppConc){
            oppWithConc.add(opp.OpportuniteDorigine__c);
        }
        
        for(Opportunity Opp : ListOpp)
        {
            system.debug(opp.LastModifiedDate);
            system.debug(oldMap.get(Opp.id).LastModifiedDate);
            if(opp.Statut__c <> Label.LC35_Statut && (oldMap.get(Opp.id).Statut__c ==Label.LC35_Statut || oldMap.get(Opp.id).Statut__c == 'Gagnée') && opp.Tech_ResilistionFirst__c)
            {
                opp.Tech_ResilistionFirst__c = false;
            }
            if(opp.Statut__c != 'Sans suite' && (oldMap.get(Opp.id).Statut__c == 'Sans suite' || oldMap.get(Opp.id).Statut__c == 'Gagnée') && opp.Tech_ResilistionFirst__c){
                opp.Tech_ResilistionFirst__c = false;
            }
            if(oppWithConc.contains(opp.id) && oldMap.get(Opp.id).StageName !='Réalisation' && opp.StageName == 'Réalisation'){
                opp.Tech_OpenConcurrente__c = false;
            }
        }
    }
}