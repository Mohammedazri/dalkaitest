/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: Trigger After Update on the fiche_de_synthese__c object
Test Class: AP30_UpdateCAEcartMBrute_test
History
<Date>      <Authors Name>   <Brief Description of Change>
18/09/2018	Jacques Akiki	Creation
26/09/2018  Jacques Akiki	Modification related to the changes made on the FDS not related to change of picklist value
--------------------------------------------------------------------------------------------------------------------------*/
trigger FicheDeSyntheseAfterUpdate on Fiche_de_synthese__c (after update)
{
    List<fiche_de_synthese__c> AP30_ListFDS = new List<fiche_de_synthese__c>();
    for (Fiche_de_synthese__c fds:Trigger.new)
    { 
       
        if ((((Trigger.oldMap.get(fds.id).BudgetNSousTotP1234CaEcart__c != fds.BudgetNSousTotP1234CaEcart__c ) || (Trigger.oldMap.get(fds.id).BudgetNSousTotP1234MbEcart__c != fds.BudgetNSousTotP1234MbEcart__c)) && fds.ConditionsDeReference__c==Label.LC12_Budget)
            || (((Trigger.oldMap.get(fds.id).SaisieRefSousTotP1234CaEcart__c != fds.SaisieRefSousTotP1234CaEcart__c ) || (Trigger.oldMap.get(fds.id).SaisieRefSousTotP1234MbEcart__c != fds.SaisieRefSousTotP1234MbEcart__c)) && fds.ConditionsDeReference__c==Label.LC12_Saisie)
            || (((Trigger.oldMap.get(fds.id).EcartNbHP2SelonConditionReference__c != fds.EcartNbHP2SelonConditionReference__c )))
            || fds.Budget__c!=Trigger.oldMap.get(fds.Id).Budget__c || fds.Budget_Realise__c!=Trigger.oldMap.get(fds.Id).Budget_Realise__c)
        {
            AP30_ListFDS.add(fds);
        }   
    }
    
    if(PAD.CanTrigger('AP30_UpdateCAEcartMBrute')&& AP30_ListFDS!=NULL && AP30_ListFDS.size()>0)  
    {
        AP30_UpdateCAEcartMBrute.UpdateValues(AP30_ListFDS); // ajouter les modif dans la classe AP30- 26/09/2018
    }
}