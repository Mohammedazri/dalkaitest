trigger ConventionService on ConventionService__c (after insert) {
                            
list <LienConventionEmplacement__c> lstLienConventionEmplacements  = new list <LienConventionEmplacement__c>();



      for(ConventionService__c cvs : trigger.new)
        {
           upsert cvs;
          }
/*       
  if (lstLienConventionEmplacements.size() >0) {               
         AP121_Emplacement.getServiceByInsertion(trigger.new);  
      }
 */         
  }