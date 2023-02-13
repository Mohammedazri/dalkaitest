/**
* @author: Jacques Akiki -EI Technologies
* @date: 23/07/2019
* @description: Set the probability  to 100 if opportunity is realised 
* @Test Class: AP65_OppProbability_Test  
* @Coverage:  100% 
*/
public class AP65_OppProbability 
{
    public static void setOppProbability(List<opportunity> listOpp)
    {
        for(Opportunity opp : listOpp)
        {
            if(opp.stagename == Label.PV_Realisation)    
            {
                opp.probabilite__c = 100;
            }
        }
    }
}