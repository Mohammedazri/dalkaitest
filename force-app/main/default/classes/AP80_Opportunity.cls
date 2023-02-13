/** 
* @author Jacques Akiki
* @date 23/04/2020 
* @description class that updates the field Pilote_realisation_lookup__c on opportunity
* @Test Class AP80_Opportunity_Test
*/
public class AP80_Opportunity {
    /** 
* @author Jacques Akiki
* @date 23/04/2020
* @vérification si nous pouvons supprimer le compte ou pas
* @param opportunityList: list Of Opportunities that are being updated , oldMap : old version od the updated oppotunities
* @return void
*/
    public static void setPiloteLorsRealisation(List<Opportunity> opportunityList , Map<id,Opportunity> oldMap)
    {
        for(Opportunity opp : opportunityList)
        {
            if(opp.StageName!=oldMap.get(opp.Id).StageName && opp.StageName ==Label.PV_Realisation && opp.Pilote_realisation_lookup__c==null)
            {
                opp.Pilote_realisation_lookup__c = opp.OwnerId;
            }
        }
    }
}