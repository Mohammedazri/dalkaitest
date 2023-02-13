/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EIT Mena
Description: Apex trigger CaseAfterUpdate
History
<Date>      <Authors Name>      <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger CaseAfterUpdate on Case (after update) {

Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                     .get('Demande_de_depannage').getRecordTypeId();
                            
                            
list <Case> lstCaseForMSAD = new list <Case>();
list <Case> lstCaseForTempov2 = new list <Case>();

    //check if can delete case
    if(PAD.CanTrigger('AP117_Case')){
       AP117_Case.checkIfCanDeleteCase(trigger.old);
    }
    
   for(Case cas : Trigger.new) 
   
   
        {
          if ((Trigger.oldmap.get(cas.id).Status != Trigger.newmap.get(cas.id).Status) 
            || (Trigger.oldmap.get(cas.id).Emplacement__c != Trigger.newmap.get(cas.id).Emplacement__c && Trigger.newmap.get(cas.id).Origin == 'Espace Client') 
            || (Trigger.oldmap.get(cas.id).Emplacement__c != Trigger.newmap.get(cas.id).Emplacement__c && Trigger.newmap.get(cas.id).Origin != 'Espace Client')
            || (Trigger.oldmap.get(cas.id).Motif_de_cloture__c != Trigger.newmap.get(cas.id).Motif_de_cloture__c && Trigger.newmap.get(cas.id).Motif_de_cloture__c != 'Demande résolue')
            &&  cas.RecordtypeId == RT_DemandeDepannage)   

          {
           lstCaseForMSAD.add(cas);
          }
          
          
          //critere de declenchement pour appeler Tempov2
          if (Trigger.oldmap.get(cas.id).Status != Trigger.newmap.get(cas.id).Status 
              //&& Trigger.newmap.get(cas.id).Status == 'A traiter' 
              &&  cas.RecordtypeId == RT_DemandeDepannage 
              && (Trigger.newmap.get(cas.Id).Criticite__c == '2' || Trigger.newmap.get(cas.Id).Criticite__c == '3' || Trigger.newmap.get(cas.Id).Criticite__c == '4')) 
          {
           lstCaseForTempov2.add(cas);
          }
           
          
       }
  if (lstCaseForMSAD.size() >0) {               
         AP118_CalloutAPIGateway.handleList(trigger.new);  
      }  
    
  if (lstCaseForTempov2.size() >0) {               
         AP_CalloutAPITempo.handleList(trigger.new);  // Classe a créer faisant appel a AP118_ConnecteurDACRC_Old
      }    
}