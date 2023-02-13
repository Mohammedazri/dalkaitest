/** 
* @author Jacques Akiki
* @date 24/04/2020 
* @Class that stops user from creation 2 opportunites de renouvellement for same contract
* @Test Class AP81_Opportunity_Test
*/
public class AP81_OpportunityRenouv {
    /** 
* @author Jacques Akiki
* @date 24/04/2020
* @Function called on insert or update of opportunity to make sure that a contract has only 1 opportunity of renouvellement
* @param opportunityList: list Of Opportunities that are being updated , oldMap : old version od the updated oppotunities 
* @return void
*/
    public static void addErrorOnRenouvellement(List<Opportunity> opportunityList , Map<id,Opportunity> oldMap)
    {
        map<id,Opportunity> mapContOpp = new map<id,Opportunity>();
        for(Opportunity opp : opportunityList)
        {
            if(opp.ContratOrigine__c!=NULL && opp.Type_pers__c==Label.Renouvellement)
            {
                /*Update case*/
                if(oldMap!=Null && oldMap.keyset()!=Null && oldmap.keyset().size()>0
                  && (oldmap.get(opp.id).ContratOrigine__c!=opp.ContratOrigine__c ||oldmap.get(opp.id).Type_pers__c!=opp.Type_pers__c))
                {
                    if(!mapContOpp.containskey(opp.ContratOrigine__c)  )
                    {
                        mapContOpp.put(opp.ContratOrigine__c,opp);
                    }
                    else
                    {
                       opp.addError(Label.AP81_ErreurRenouvellement);
                    }
                }
                /*Insert Case*/
                else if(oldMap==Null)
                {
                    if(!mapContOpp.containskey(opp.ContratOrigine__c))
                    {
                        mapContOpp.put(opp.ContratOrigine__c,opp);
                    }
                    else
                    {
                        opp.addError(Label.AP81_ErreurRenouvellement);
                    }
                }
            }
        }
        if (mapContOpp!=NULL && mapContOpp.keyset() !=NULL && mapContOpp.keyset().size()>0)
        {
            List<opportunity> listOppRenouv = [SELECT id,ContratOrigine__c
                                               FROM Opportunity 
                                               WHERE ContratOrigine__c in:mapContOpp.keyset() AND Type_pers__c =:Label.Renouvellement];
            for (Opportunity opp : listOppRenouv)
            {
                if(mapContOpp.containsKey(opp.ContratOrigine__c))
                {
                    mapContOpp.get(opp.ContratOrigine__c).addError(Label.AP81_ErreurRenouvellement);
                }
            }
        }
    }
}