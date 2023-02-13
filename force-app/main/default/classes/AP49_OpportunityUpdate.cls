/**
* @author: Jacques Akiki -EI Technologies
* @date: 03/04/2019
* @description: Update the values on opportunity when values on Budget are Updated 
* @Test Class: AP49_OpportunityUpdate_test 
* @Coverage: 95%
*/

public class AP49_OpportunityUpdate 
{
    /*
* @Author: Jacques Akiki -EI Technologies  
* @Description: This method Updates the fields Tech_Marge_Brute_Ecart__c and Tech_CA_Ecart__c on Opportunity when a modification is
done on the Budget Level.
* @Inputs: List<Budget__c>
* @Returns:- 
*/ 
    public static void UpdateOpportunities(List<Budget__c> lstBudget)
    {
        Set<id> SetId = new Set<Id>();
        for(Budget__c bdg:lstBudget)
        {
            SetId.add(bdg.id);
        }
        List<Fiche_de_synthese__c> listFDS = [SELECT id,name,Budget__c, Opportunit_commerciale__c, BudgetNSousTotP1234CaEcart__c, 
                                              BudgetNSousTotP1234MbEcart__c,Opportunit_commerciale__r.Tech_CA_Ecart__c ,
                                              Opportunit_commerciale__r.Tech_Marge_Brute_Ecart__c,ConditionsDeReference__c
                                              FROM Fiche_de_synthese__c
                                              WHERE Budget__c in:SetId AND ConditionsDeReference__c=:Label.LC12_Budget];
        
        List<Opportunity> listOpp = new List<Opportunity>();
        for (Fiche_de_synthese__c fds : listFDS)
        {
            if(fds.Opportunit_commerciale__r.Tech_Marge_Brute_Ecart__c <> fds.BudgetNSousTotP1234MbEcart__c
               ||fds.Opportunit_commerciale__r.Tech_CA_Ecart__c <> fds.BudgetNSousTotP1234CaEcart__c )
            {
                Opportunity Opp = new Opportunity();
                Opp.Id = fds.Opportunit_commerciale__c;
                Opp.Tech_Marge_Brute_Ecart__c = fds.BudgetNSousTotP1234MbEcart__c; // copy the value from fiche de synthese to opportunity
                Opp.Tech_CA_Ecart__c = fds.BudgetNSousTotP1234CaEcart__c; 
                listOpp.add(Opp);
            }
        }
        if (listOpp<>NULL && listOpp.size()>0)
        {
            try
            {
                update listOpp;  
            }
            catch (Exception e)
            {
                System.debug('Erreur suivante est produite lors du changement sur Budget'+e.getMessage());
            }
        }
        
    }
}