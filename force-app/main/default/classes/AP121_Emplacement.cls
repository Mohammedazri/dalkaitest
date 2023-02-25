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

    public static void getServiceOnEmplacementByInsertionEmplacementAssocie(list<LienConventionEmplacement__c> lstLienConventionEmplacements){
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
        
        List <Emplacement__c> listEmpl = [Select id, Service__c, CodeService__c, Service_TECH__c
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
         if (emp.Service__c == Null) {
          emp.Service__c = '';
          emp.Service_TECH__c = '';
          emp.CodeService__c = '';
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
              emp.Service__c = emp.Service__c + '\r' + liencvs.Service__r.Name;
              emp.Service_TECH__c = emp.Service_TECH__c + ' ; ' + liencvs.Service__r.Name;
              emp.CodeService__c = emp.CodeService__c + '\r' + liencvs.Service__r.CodeService__c;
              listEmplacementUpdated.add(emp);
              
                    
            }
           }
          }
         else { 
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
              //doublon
              if (!emp.Service__c.contains(liencvs.Service__r.Name)) {
              emp.Service__c = emp.Service__c + '\r' + liencvs.Service__r.Name;
              emp.Service_TECH__c = emp.Service_TECH__c + ' ; ' + liencvs.Service__r.Name;
              emp.CodeService__c = emp.CodeService__c + '\r' + liencvs.Service__r.CodeService__c;
              listEmplacementUpdated.add(emp);
             } 
                    
            }
         }
        } 
       
     //update listEmplacementUpdated;
     //update listEmpl;     
   }
   
   update /*listEmplacementUpdated*/ listEmpl;
  } 
  
  public static void deleteEmplacementAssocie(list<LienConventionEmplacement__c> lstLienConventionEmplacements){
        Set<Id> setEmplacementAssocieIDs = new Set<Id>();


        
        for (LienConventionEmplacement__c lce : lstLienConventionEmplacements) 
        {
            setEmplacementAssocieIDs.add(lce.Id);
         }
        
        List <LienConventionEmplacement__c> listEmplAssocies = [Select id From LienConventionEmplacement__c 
                                                                Where id in: setEmplacementAssocieIDs];
        if (listEmplAssocies.size() >0) {
        delete listEmplAssocies;                                         
        }
  } 
  
   public static void getServiceOnEmplacementByDeletionEmplacementAssocie(list<LienConventionEmplacement__c> lstLienConventionEmplacements){
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
        
        List <Emplacement__c> listEmpl = [Select id, Service__c, CodeService__c, Service_TECH__c 
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
          for (ConventionService__c conv : listConv) {
          lstLienConventionServiceARecuperer = conv.LiensConventionServiceToCV__r;
          system.debug('lstLienConventionServiceARecuperer :'+lstLienConventionServiceARecuperer); 
           for (LienConventionService__c liencvs : lstLienConventionServiceARecuperer)
            {
             if (emp.Service__c != Null) {
             if (emp.Service__c.contains(liencvs.Service__r.Name)) {
              emp.Service__c = emp.Service__c.remove(liencvs.Service__r.Name);
              emp.Service_TECH__c = emp.Service_TECH__c.remove(liencvs.Service__r.Name);
              }
             if (emp.CodeService__c.contains(liencvs.Service__r.CodeService__c)) {
              emp.CodeService__c = emp.CodeService__c.remove(liencvs.Service__r.CodeService__c);
              } 
              listEmplacementUpdated.add(emp);
             }       
            }
         }
        } 

     //update listEmplacementUpdated;
     update /*listEmplacementUpdated*/ listEmpl;     
   
  }
  
  public static void getServiceOnEmplacementByInsertionServiceAssocie(list<LienConventionService__c> lstLienConventionServices){
        Set<Id> setServiceIDs = new Set<Id>();
        Set<Id> setCVSIDs = new Set<Id>();
        Set<Id> setEmplacementIds = new set<Id>();
        
        list<LienConventionEmplacement__c> lstLienConventionEmplacementARecuperer;
        //list<Emplacement__c> listEmplacementUpdated = new list<Emplacement__c>();
        
        for (LienConventionService__c lcs : lstLienConventionServices) 
        {
            setServiceIDs.add(lcs.Service__c);
            setCVSIDs.add(lcs.ConventionService__c);
            //SetDeletedLienConventionEmplacementIds.add(lce.Id);
         }
        
        List <Service__c> listServ = [Select id, Name, CodeService__c
                                                   From Service__c
                                                   Where id in: setServiceIDs
                                                  ];
        system.debug('listServ :'+listServ);                                        
        List <ConventionService__c> listConv =  [Select id, 
                                                   (select Id, Emplacement__c, Emplacement__r.Service__c, Emplacement__r.CodeService__c
                                                    from LiensConventionEmplacementToCV__r)
                                                    //where Id in: SetDeletedLienConventionEmplacementIds)
                                                   From ConventionService__c cvs
                                                   Where cvs.id in: setCVSIDs
                                                  ]; 
        system.debug('listConv :'+listConv);  
      for (ConventionService__c conv : listConv) {
          lstLienConventionEmplacementARecuperer = conv.LiensConventionEmplacementToCV__r;
           for (LienConventionEmplacement__c lce : lstLienConventionEmplacementARecuperer) 
           {
            setEmplacementIDs.add(lce.Emplacement__c);
           }
         }  
         
       List <Emplacement__c> listEmpl = [Select id, Service__c, CodeService__c, Service_TECH__c
                                                   From Emplacement__c
                                                   Where id in: setEmplacementIDs
                                                  ];                                                                                                             
      
        for(Emplacement__c emp : listEmpl) {
          for (Service__c s : listServ) {
           if (emp.Service__c == Null) {
            emp.Service__c = '';
            emp.Service_TECH__c = '';
            emp.CodeService__c = '';
            emp.Service__c = emp.Service__c + '\r' + s.Name;
            emp.Service_TECH__c = emp.Service__c + ' ; ' + s.Name;
            emp.CodeService__c = emp.CodeService__c + '\r' + s.CodeService__c;                  
            }          
           else { 
            if (!emp.Service__c.contains(s.Name)) {
            emp.Service__c = emp.Service__c + '\r' + s.Name;
            emp.Service_TECH__c = emp.Service__c + ' ; ' + s.Name;
            emp.CodeService__c = emp.CodeService__c + '\r' + s.CodeService__c;
              }      
            }
         }
        } 
       
     update listEmpl;     
   }  
   
   public static void deleteServiceAssocie(list<LienConventionService__c> lstLienConventionServices){
        Set<Id> setServiceAssocieIDs = new Set<Id>();


        
        for (LienConventionService__c lcs : lstLienConventionServices) 
        {
            setServiceAssocieIDs.add(lcs.Id);
         }
        
        List <LienConventionService__c> listServAssocies = [Select id From LienConventionService__c
                                                                Where id in: setServiceAssocieIDs];
        if (listServAssocies.size() >0) {
        delete listServAssocies;                                         
        }
  } 
   
   public static void getServiceOnEmplacementByDeletionServiceAssocie(list<LienConventionService__c> lstLienConventionServices){
        Set<Id> setServiceIDs = new Set<Id>();
        Set<Id> setCVSIDs = new Set<Id>();
        Set<Id> setEmplacementIds = new set<Id>();
        
        list<LienConventionEmplacement__c> lstLienConventionEmplacementARecuperer;
        //list<Emplacement__c> listEmplacementUpdated = new list<Emplacement__c>();
        
        for (LienConventionService__c lcs : lstLienConventionServices) 
        {
            setServiceIDs.add(lcs.Service__c);
            setCVSIDs.add(lcs.ConventionService__c);
            //SetDeletedLienConventionEmplacementIds.add(lce.Id);
         }
        
        List <Service__c> listServ = [Select id, Name, CodeService__c
                                                   From Service__c
                                                   Where id in: setServiceIDs
                                                  ];
        system.debug('listServ :'+listServ);                                        
        List <ConventionService__c> listConv =  [Select id, 
                                                   (select Id, Emplacement__c, Emplacement__r.Service__c, Emplacement__r.CodeService__c
                                                    from LiensConventionEmplacementToCV__r)
                                                    //where Id in: SetDeletedLienConventionEmplacementIds)
                                                   From ConventionService__c cvs
                                                   Where cvs.id in: setCVSIDs
                                                  ]; 
        system.debug('listConv :'+listConv);  
      for (ConventionService__c conv : listConv) {
          lstLienConventionEmplacementARecuperer = conv.LiensConventionEmplacementToCV__r;
           for (LienConventionEmplacement__c lce : lstLienConventionEmplacementARecuperer) 
           {
            setEmplacementIDs.add(lce.Emplacement__c);
           }
         }  
         
       List <Emplacement__c> listEmpl = [Select id, Service__c, CodeService__c, Service_TECH__c
                                                   From Emplacement__c
                                                   Where id in: setEmplacementIDs
                                                  ];                                                                                                             
      
        for(Emplacement__c emp : listEmpl) {
          for (Service__c s : listServ) {
           if (emp.Service__c != Null) {
            if (emp.Service__c.contains(s.Name)) {
              emp.Service__c = emp.Service__c.remove(s.Name);
              emp.Service_TECH__c = emp.Service_TECH__c.remove(s.Name);
              }          
            if (emp.CodeService__c.contains(s.CodeService__c)) {
              emp.CodeService__c = emp.CodeService__c.remove(s.CodeService__c);
              } 
                    
            }
         } 
        } 
       
     update listEmpl;     
   }  
}