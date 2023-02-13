/*--------------------------------------------------------------------------------------------------------------------------
   Author: Hatem Lahmadi
   Company: Cognizant
   Description: Class used by Lien Convention Emplacement triggers LienConventionEmplacementAfterInsert to get Services On Convention Service (CVS)
   Test Class:
   History
   <Date>
   11/01/2023  
   --------------------------------------------------------------------------------------------------------------------------*/

public without sharing class AP121_Emplacement {

    public static void getServiceByInsertion(list<LienConventionEmplacement__c> lstLienConventionEmplacements){
        Set<Id> setEmplacementIDs = new Set<Id>();
        Set<Id> setCVSIDs = new Set<Id>();
        Set<Id> SetDeletedLienConventionEmplacementIds = new set<Id>();
        
        list<LienConventionService__c> lstLienConventionServiceARecuperer;
        list<Emplacement__c> listEmplacementUpdated = new list<Emplacement__c>();
        
        for (LienConventionEmplacement__c lce : lstLienConventionEmplacements) 
        {
            setEmplacementIDs.add(lce.Emplacement__c);
            setCVSIDs.add(lce.ConventionService__c);
            //SetDeletedLienConventionEmplacementIds.add(lce.Id);
         }
        
        List <Emplacement__c> listEmpl = [Select id, Service__c, CodeService__c
                                                   From Emplacement__c
                                                   Where id in: setEmplacementIDs
                                                  ];
        system.debug('listEmpl :'+listEmpl);                                        
        List <ConventionService__c> listConv =  [Select id, 
                                                   (select Id, ServiceLibelle__c, Service__r.Name, Service__r.CodeService__c
                                                    from LiensConventionServiceToCV__r)
                                                    //where Id in: SetDeletedLienConventionEmplacementIds)
                                                   From ConventionService__c cvs
                                                   Where cvs.id in: setCVSIDs
                                                  ];
        system.debug('listConv :'+listConv);                                                                                                             

        for(Emplacement__c emp : listEmpl) {
        //if (Trigger.isInsert) {
         if (emp.Service__c == Null) {
          emp.Service__c = '';
          emp.CodeService__c = '';
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
              //emp.Test_SERVICE__c = emp.Test_SERVICE__c + '\r' + liencvs.ServiceLibelle__c;
              emp.Service__c = emp.Service__c + '\r' + liencvs.Service__r.Name;
              emp.CodeService__c = emp.CodeService__c + '\r' + liencvs.Service__r.CodeService__c;
              //listEmplacementUpdated.add(emp);
                    
            }
           }
          }
         else { 
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
              emp.Service__c = emp.Service__c + '\r' + liencvs.Service__r.Name;
              emp.CodeService__c = emp.CodeService__c + '\r' + liencvs.Service__r.CodeService__c;
                    
            }
         }
        } 
       //}
      /*else {
       //if (emp.Service__c == Null) {
          //emp.Service__c = '';
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
              //emp.Test_SERVICE__c = emp.Test_SERVICE__c + '\r' + liencvs.ServiceLibelle__c;
              //emp.Service__c = emp.Service__c + '\r' + liencvs.Service__r.Name;
              emp.Service__c = emp.Service__c.replace('Fourniture de gaz','');
              //emp.CodeService__c = emp.CodeService__c + '\r' + liencvs.Service__r.CodeService__c;
              //listEmplacementUpdated.add(emp);
                    
            }
           }
      //}  
     }*/
     //update listEmplacementUpdated;
     update listEmpl;     
   }
  } 
  
   /*public static void getServiceByDeletion(list<LienConventionEmplacement__c> lstLienConventionEmplacements){
        Set<Id> setEmplacementIDs = new Set<Id>();
        Set<Id> setCVSIDs = new Set<Id>();
        Set<Id> SetDeletedLienConventionEmplacementIds = new set<Id>();
        
        list<LienConventionService__c> lstLienConventionServiceARecuperer;
        list<Emplacement__c> listEmplacementUpdated = new list<Emplacement__c>();
        
        for (LienConventionEmplacement__c lce : lstLienConventionEmplacements) 
        {
            setEmplacementIDs.add(lce.Emplacement__c);
            //setCVSIDs.add(lce.ConventionService__c);
            //SetDeletedLienConventionEmplacementIds.add(lce.Id);
         }
        
        List <Emplacement__c> listEmpl = [Select id, Service__c, CodeService__c
                                                   From Emplacement__c
                                                   Where id in: setEmplacementIDs
                                                  ];
        system.debug('listEmpl :'+listEmpl);                                        
        List <LienConventionEmplacement__c > listConvEmp =  [Select id, ConventionService__c
                                                    from LiensConventionServiceToCV__c
                                                    where Id not in: SetDeletedLienConventionEmplacementIds)
                                                   From ConventionService__c cvs
                                                   Where cvs.id in: setCVSIDs
                                                  ];
        system.debug('listConv :'+listConv);                                                                                                             

        for(Emplacement__c emp : listEmpl) {
        if (Trigger.isInsert) {
         if (emp.Service__c == Null) {
          emp.Service__c = '';
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
              //emp.Test_SERVICE__c = emp.Test_SERVICE__c + '\r' + liencvs.ServiceLibelle__c;
              emp.Service__c = emp.Service__c + '\r' + liencvs.Service__r.Name;
              emp.CodeService__c = emp.CodeService__c + '\r' + liencvs.Service__r.CodeService__c;
              //listEmplacementUpdated.add(emp);
                    
            }
           }
          }
         else { 
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
              emp.Service__c = emp.Service__c + '\r' + liencvs.Service__r.Name;
              emp.CodeService__c = emp.CodeService__c + '\r' + liencvs.Service__r.CodeService__c;
                    
            }
         }
        } 
       }

     //update listEmplacementUpdated;
     update listEmpl;     
   }
  }*/ 
}