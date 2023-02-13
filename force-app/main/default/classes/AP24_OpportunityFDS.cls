/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: This Class change the name of the FDS related to the opportunity and change the Opportunity name to uppercase letters
Test Class: AP24_OpportunityFDS_Test
History
10/04/2018 Johny Kassis  added the marked lines that changes the opportunity name to uppercase letters
--------------------------------------------------------------------------------------------------------------------------*/
public class AP24_OpportunityFDS {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: change the name of the FDS related to the Opportunity
Inputs: list of modified Opportunities
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static void changeFDSName(List<Opportunity> Opportunitylist)
    {
        
        Set<id> oppIDs= new Set<ID>();
        For(Opportunity opp:Opportunitylist)
        {
            oppIDs.add(opp.id);
        }
        List<Fiche_de_synthese__c> FichesList= [SELECT ID, name ,Opportunit_commerciale__r.name, ByPassFdsWFs__c
                                                FROM Fiche_de_synthese__c
                                                WHERE Opportunit_commerciale__c In :oppIDs];
        
        if(FichesList.size()>0)
        {
            for(Fiche_de_synthese__c ficheDeSyn:FichesList)
            {
                ficheDeSyn.Name=Label.AP24_nameFDS+' '+ficheDeSyn.Opportunit_commerciale__r.name;
                ficheDeSyn.ByPassFdsWFs__c=!ficheDeSyn.ByPassFdsWFs__c;
            }
            update FichesList;
        }
    }
     /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: change the Opportunity name to uppercase letters 
Inputs: list of modified Opportunities
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
       
     public static void changeOppName(List<Opportunity> Opportunitylist)
    {
        
        For(Opportunity opp:Opportunitylist)
        {
            String oppName =opp.Name;
            opp.Name=oppName.toUpperCase();  
        }
    }
    
    
}