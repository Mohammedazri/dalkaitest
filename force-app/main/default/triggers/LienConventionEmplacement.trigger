trigger LienConventionEmplacement on LienConventionEmplacement__c (after insert, after update, after delete) {
                            
list <LienConventionEmplacement__c> lstLienConventionEmplacements  = new list <LienConventionEmplacement__c>();



if (trigger.Isinsert) {  
      for(LienConventionEmplacement__c lce : trigger.new)
        {
           lstLienConventionEmplacements.add(lce);
          }
       
  if (lstLienConventionEmplacements.size() >0) {               
         AP121_Emplacement.getServiceOnEmplacementByInsertionEmplacementAssocie(trigger.new);  
      } 
   }
    /*
 else if (trigger.Isupdate){
    for(LienConventionEmplacement__c lce : trigger.new) {
     if ((Trigger.oldmap.get(lce.id).StatutLien__c != Trigger.newmap.get(lce.id).StatutLien__c) && Trigger.newmap.get(lce.id).StatutLien__c == false) { 
        {
           lstLienConventionEmplacements.add(lce);
         }
       }  
     }
         
   if (lstLienConventionEmplacements.size()>0) {
     AP121_Emplacement.deleteEmplacementAssocie(trigger.new); 
    }      
  }  
       */ 
  else if (trigger.Isdelete) {  
      for(LienConventionEmplacement__c lce : trigger.old)
        {
           lstLienConventionEmplacements.add(lce);
          }
       
  if (lstLienConventionEmplacements.size() >0) {               
         AP121_Emplacement.getServiceOnEmplacementByDeletionEmplacementAssocie(trigger.old);  
      } 
   } 
   
 }