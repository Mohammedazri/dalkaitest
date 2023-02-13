/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Apex trigger FicheDeSyntheseBeforeInsert
Test Class: AP15_Budget_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
26/06/2018   Johny Kassis      Commented AP15
--------------------------------------------------------------------------------------------------------------------------*/
trigger FicheDeSyntheseBeforeInsert on Fiche_de_synthese__c (before insert) 
{
    //relate the "Fiche_de_synthese__c" records to their right Budget__c
    if(PAD.CanTrigger('AP15_Budget'))
      AP15_Budget.UpdateBudgetOnFicheDeSyntheseBeforeInsert(trigger.new);
    
    //enters the value of the field THO__c of the fiche de syntèse 
   /*  if(PAD.CanTrigger('AP23_ThoFicheDeSynthese'))
      AP23_ThoFicheDeSynthese.UpdateThoSurFDS(trigger.new, false);*/
}