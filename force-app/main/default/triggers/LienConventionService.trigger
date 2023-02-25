trigger LienConventionService on LienConventionService__c (after insert, after update, after delete) {
                           
list <LienConventionService__c> lstLienConventionServices  = new list <LienConventionService__c>();



if (trigger.Isinsert) {  
      for(LienConventionService__c lcs : trigger.new)
        {
           lstLienConventionServices.add(lcs);
          }
       
  if (lstLienConventionServices.size() >0) {               
         AP121_Emplacement.getServiceOnEmplacementByInsertionServiceAssocie(trigger.new);  
      } 
    } 
  /**  
 else if (trigger.Isupdate){
    for(LienConventionService__c lcs : trigger.new) {
     if ((Trigger.oldmap.get(lcs.id).StatutLien__c != Trigger.newmap.get(lcs.id).StatutLien__c) && Trigger.newmap.get(lcs.id).StatutLien__c == false) { 
        {
           lstLienConventionServices.add(lcs);
         }
       }  
     }
         
   if (lstLienConventionServices.size()>0) {
     AP121_Emplacement.deleteServiceAssocie(trigger.new); 
    }      
  }
       
 */
else if (trigger.Isdelete) {  
      for(LienConventionService__c lcs : trigger.old)
        {
           lstLienConventionServices.add(lcs);
          }
       
  if (lstLienConventionServices.size() >0) {               
         AP121_Emplacement.getServiceOnEmplacementByDeletionServiceAssocie(trigger.old);  
      } 
   }     
  }