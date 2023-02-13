/** 
* @author Charbel Khoury Hanna
* @date 22/06/2022
* @description verifier qu'il reste au moins un contact actif rattaché au contrat
* @Test Class AP114_Contact_Test (100%)
*/
public class AP114_Contact {
    
    /** 
* @author Charbel Khoury Hanna
* @date 22/06/2022
* @description verifier qu'il reste au moins un contact actif rattaché au contrat
* @param listContactToUpadte: List of Contact that are being updated
* @return void
*/  
    public static void checkContactContratSize (List<Contact> listContactToUpadte, Map<Id,Contact> mapAllContacts)
    {
        List<ContratContact__c> listInactiveCC =[SELECT id, Contrat__c, Contact__c
                                                 FROM ContratContact__c
                                                 WHERE Contact__c in : listContactToUpadte
                                                   AND Contrat__r.Statut__c != :Label.ContratFerme];
        
        Set<Id> contratIds = new Set<Id>();
        
        for(ContratContact__c cc : listInactiveCC)
        {
            contratIds.add(cc.Contrat__c);
        }

        Map<Id,List<Id>> mapContactContrats = new Map<Id,List<Id>>();
        
        for(ContratContact__c cc : listInactiveCC)
        {
            if(!mapContactContrats.containsKey(cc.Contrat__c))
            {
                mapContactContrats.put(cc.Contrat__c, new List<Id>());
            }
            mapContactContrats.get(cc.Contrat__c).add(cc.Contact__c);
        }
        
        List<ContratContact__c> listActiveCC =[SELECT id, Contrat__c, Contact__c, Contact__r.Statut__c
                                               FROM ContratContact__c
                                               WHERE Contrat__c in : contratIds
                                               AND Contact__r.Statut__c != : Label.AP114_ContratInactif];

        Map<Id,List<Id>> mapActiveCC = new Map<Id,List<Id>>();
        
        for(ContratContact__c cc : listActiveCC)
        {
            if(!mapActiveCC.containsKey(cc.Contrat__c))
            {
                mapActiveCC.put(cc.Contrat__c, new List<Id>());
            }
            mapActiveCC.get(cc.Contrat__c).add(cc.Contact__c);
        }
        
        for(Id contrat : mapActiveCC.keySet())
        {
            if(mapContactContrats.containsKey(contrat) && mapActiveCC.get(contrat).size() == mapContactContrats.get(contrat).size())
            {
                for(Id cont : mapContactContrats.get(contrat))
                {
                    if(mapAllContacts.containsKey(cont))
                    {
                        if(Trigger.IsUpdate)
                        {
                         	mapAllContacts.get(cont).addError(Label.AP114_ErrorMsg);   
                        }
                        if(Trigger.IsDelete)
                        {
                            mapAllContacts.get(cont).addError(Label.AP114_ErrorMsgDelete);   
                        }
                    }
                }
            }
        }
    }
}