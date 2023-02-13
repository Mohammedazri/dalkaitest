/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EIT Mena
Description: Apex trigger CaseBeforeUpdate
History
<Date>      <Authors Name>      <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
trigger CaseBeforeUpdate on Case (before update) {

Id RT_DemandeDepannage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                     .get('Demande_de_depannage').getRecordTypeId();
                            
    //check if can delete case
    if(PAD.CanTrigger('AP117_Case')){
        AP117_Case.checkIfCanDeleteCase(trigger.new);
    }
 
 Set<String> ServiceFromCase = new Set<String>();
 Set<String> ServiceFromEmplacements = new Set<String>();
              
 for(Case cas : trigger.new) 
  
   
        {
           
          if ((Trigger.oldmap.get(cas.id).Service__c != Trigger.newmap.get(cas.id).Service__c) 
          || (Trigger.oldmap.get(cas.id).Emplacement__c != Trigger.newmap.get(cas.id).Emplacement__c) 
          &&  cas.RecordtypeId == RT_DemandeDepannage) 
          {
             ServiceFromCase.add(cas.Emplacement__c);
          }
        } 
       //for(Emplacement__c emp : [SELECT Id, Test_SERVICE__c FROM Emplacement__c Where Id  in :ServiceFromCase limit 1]){
        //ServiceFromEmplacements.add(emp.Test_SERVICE__c);
        //}  
        
        List<Emplacement__c> emp = [SELECT Id, Service__c, CodeService__c FROM Emplacement__c Where Id  in :ServiceFromCase Limit 1];
     
     for(case c : trigger.new){
     //Set<String> ServiceFromEmplacements = new Set<String>(){c.Emplacement__r.Test_Service__c};
     //ServiceFromEmplacements.add(emp[0].Test_Service__c);
     system.debug('c.Service :'+c.Service__c);
     //system.debug('emp[0].Test_SERVICE__c :'+emp[0].Test_SERVICE__c);
     //system.debug('ServiceFromEmplacements :'+ServiceFromEmplacements);
        //if(ServiceFromEmplacements.contains(c.Service__c)){
       if (emp.size() >0) {
        if (emp[0].CodeService__c != Null) { 
         if (!emp[0].CodeService__c.contains(c.Service__c)) {
            c.addError('Veuillez choisir un des services associés à cet Emplacement : '+emp[0].Service__c);
        }
      }
     }
     
     }     
 }