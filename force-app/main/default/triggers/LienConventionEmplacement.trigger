trigger LienConventionEmplacement on LienConventionEmplacement__c (after insert, after delete) {
                            
list <LienConventionEmplacement__c> lstLienConventionEmplacements  = new list <LienConventionEmplacement__c>();



if (trigger.Isinsert) {  
      for(LienConventionEmplacement__c lce : trigger.new)
        {
           lstLienConventionEmplacements.add(lce);
          }
       
  if (lstLienConventionEmplacements.size() >0) {               
         AP121_Emplacement.getServiceByInsertion(trigger.new);  
      } 
     } 
 /*    
  else {  
      for(LienConventionEmplacement__c lce : trigger.old)
        {
           lstLienConventionEmplacements.add(lce);
          }
       
  if (lstLienConventionEmplacements.size() >0) {               
         AP121_Emplacement.getServiceByInsertion(trigger.old);  
      } 
     } 
    */      
  }