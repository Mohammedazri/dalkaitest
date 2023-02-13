/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Apex controller for the lightning component LC32_OpportunityContrat 
Test Class: LC32_OpportunityContrat_Controller_test
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC32_OpportunityContrat_Controller 
{
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this function returns updated fields labels in a string 
Inputs: Opportunity ID
Returns: String
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static String Displaymessage(Id FicheId)
    {
        Opportunity myFiche=[SELECT id,Tech_updatedFields__c
                             FROM Opportunity
                             Where id=:FicheId];
        return myFiche.Tech_updatedFields__c;
    }
/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this function initialize the field Tech_updatedFields__c
Inputs: Opportunity ID
Returns: string containing OK or the error
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static String changeTechField(Id FicheId)
    {
        Opportunity opp=[SELECT id,Tech_updatedFields__c
                         FROM Opportunity
                         Where id=:FicheId];
        opp.Tech_updatedFields__c=null;
        //opp.Tech_Objectif_Bypass__c=!opp.Tech_Objectif_Bypass__c;
        try
        {
            update opp;
            return 'OK';
        }
        catch(System.DMLException e)
        { 
            return e.getMessage().remove('</b>').remove('<b>').replaceAll('<br>', '. ').substringAfter('EXCEPTION, ').substringBefore(': []');
        }
    }
    
    
}