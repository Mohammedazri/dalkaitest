/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Apex trigger OpportunityAfterDelete
Test Class: AP14_OppRollUpSummaryUtility_TEST
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger OpportunityAfterDelete on Opportunity (after Delete) {

    //we use the class AP14_OppRollUpSummaryUtility to recalculate the values of the fields CA_en_cours_en_K__c and CA_realis_en_K__c of the related Projet Commercial   
    if(PAD.canTrigger('AP14_OppRollUpSummaryUtility'))
    {
        list<opportunity> OpportunityList= new list<opportunity>();
        for(opportunity opp:trigger.old)
        {
            if(opp.CAEcartPrincipal__c!=null)
            {
                OpportunityList.add(opp);
            }
        }
        if(OpportunityList.size()>0)
        {
            list<AP14_OppRollUpSummaryUtility.fieldDefinition> fieldDefinitions = new list<AP14_OppRollUpSummaryUtility.fieldDefinition>();
            fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'Tech_CalculCApondere__c', 'CA_en_cours_en_K__c'));
            fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'Amount', 'CA_realis_en_K__c'));
            
            //this function does a roll up summary on the field mentioned above of the child object (Opportunity) 
            //and update the rollup fields of the parent record (ProjetCommercial__c) 
            AP14_OppRollUpSummaryUtility.rollUpTrigger(fieldDefinitions, OpportunityList,'Opportunity', 'ProjetCommercial__c', 'ProjetCommercial__c', '');         
        }
    }
    
    //mettre à jour le champ Ventes_Additionnelles__c de l'objectif du propriértaire de l'opportunité 
    if(PAD.CanTrigger('AP87_Objectif'))
    {
       AP87_Objectif.OppsCreeOuDeleteAuCoursAnnee(trigger.old);
    }
     //mettre à jour le champ VentesAdditionnellesDeLAgence__c de l'objectif de l'agence de l'opportunité  
    if(PAD.CanTrigger('AP90_Objectif'))
    {
       AP90_Objectif.OppsCreeOuDeleteAuCoursAnnee(trigger.old);
    }
}