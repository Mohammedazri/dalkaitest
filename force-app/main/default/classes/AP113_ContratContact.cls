/** 
* @author Charbel Khoury Hanna
* @date 21/06/2022
* @description verifier qu'il reste au moins un contact actif rattaché au contrat
* @Test Class AP113_ContratContact_Test (100%)
*/
public class AP113_ContratContact {
    
    /** 
* @author Charbel Khoury Hanna
* @date 21/06/2022
* @description verifier qu'il reste au moins un contact actif rattaché au contrat
* @param listOldContratContact: list of ContratContact__c that are being deleted
* @return void
*/  
    public static void checkContactContratSize (List<ContratContact__c> listOldContratContact)
    {
        Map<Id,List<Id>> mapCCToDelete = new Map<Id,List<Id>>();
        Map<Id,List<ContratContact__c>> mapCCToAlert = new Map<Id,List<ContratContact__c>>();
        Set<Id> oldContratIds = new Set<Id>();
        
        for(ContratContact__c cc : listOldContratContact)
        {
            if(!mapCCToDelete.containsKey(cc.Contrat__c))
            {
                mapCCToDelete.put(cc.Contrat__c, new List<Id>());
            }
            mapCCToDelete.get(cc.Contrat__c).add(cc.Contact__c);
            
            oldContratIds.add(cc.Contrat__c);
        }
        
        Map<Id,ContratContact__c> mapExistingCC = new Map<Id,ContratContact__c>([SELECT id, Contrat__c, Contact__c, Contact__r.Statut__c
                                                                                 FROM ContratContact__c
                                                                                 WHERE Contrat__c in : oldContratIds
                                                                                 AND Contact__r.Statut__c =: Label.AP114_ContratActif
                                                                                 AND Contrat__r.Statut__c != :Label.ContratFerme]);
        for(ContratContact__c cc : listOldContratContact)
        {
            if(mapExistingCC.containsKey(cc.Id))
            {
                if(!mapCCToAlert.containsKey(cc.Contrat__c))
                {
                    mapCCToAlert.put(cc.Contrat__c, new List<ContratContact__c>());
                }
                mapCCToAlert.get(cc.Contrat__c).add(cc);
            }
        }
        
        Map<Id,List<ContratContact__c>> mapExistingCCSize = new Map<Id,List<ContratContact__c>>();
        
        for(ContratContact__c cc : mapExistingCC.Values())
        {
            if(!mapExistingCCSize.containsKey(cc.Contrat__c))
            {
                mapExistingCCSize.put(cc.Contrat__c, new List<ContratContact__c>());
            }
            mapExistingCCSize.get(cc.Contrat__c).add(cc);
        }
        
        for(ContratContact__c cc : listOldContratContact)
        {
            if(mapExistingCCSize.containsKey(cc.Contrat__c) && mapCCToAlert.containsKey(cc.Contrat__c)
               && mapExistingCCSize.get(cc.Contrat__c).size() == mapCCToAlert.get(cc.Contrat__c).size())
            {
                cc.addError(Label.AP113_ErrorMSg);
            }
        }
    }
}