/** 
* @author Jacques Akiki - Ei technologies
* @date 23/12/2020 
* @description Batch qui met a jour le champ de satisfaction sur partenaire
* @Test Class Batch102_NoteSatisfaction_TEST
*/
global class Batch107_UpdateSatisfactionPartenaire implements Database.Batchable<SObject>  {
    
    global set<id> setAccId = new set<id>();

    global Batch107_UpdateSatisfactionPartenaire(set<id> setId) 
    {
        if(setId!=null && setId.size()>0)
        {
            setAccId = setId;
        }
    }
    /** 
* @author Jacques Akiki
* @date 23/12/2020  
* @chercher les partenaires
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id From Account WHERE id in:setAccId OR Satisfaction_client__c!=NULL';
        return Database.getQueryLocator(query);
    }
    
    /** 
* @author Jacques Akiki  
* @date 23/12/2020
* @Met a jour les partenaires par la satisfaction des clients
* @param Database.BatchableContext and list of account
* @return void
*/
     global void execute (Database.BatchableContext bc , List<Account> listAcc)
    {
        Set<Id> setAccountIds = new Set<Id>();
        for(Account acc: listAcc)
        {
            acc.Satisfaction_client__c = null; //Vider le champ satisfaction client de tout les comptes
            setAccountIds.add(acc.id);
        }
        
        List<Contact> listContact = [SELECT id,Indicateur_de_satisfaction__c,AccountId
                                     FROM Contact
                                     WHERE AccountId in :setAccountIds];
        
        Map<Id,String> mapAccountSatisfaction = new Map<Id,String>();//Map du compte avec la plus basse note de satisfaction de ces partenaires
        
        
        for(Contact cont : listContact){
            //Présent dans la map
            if(mapAccountSatisfaction.containsKey(cont.AccountId))
            {
                //Valeur de satisfaction inferieure a la valeur de satisfaction du partenaire dans la map
                if(mapAccountSatisfaction.get(cont.AccountId) != null && cont.Indicateur_de_satisfaction__c != null
                   && Integer.valueOf(cont.Indicateur_de_satisfaction__c.split('/')[0]) < Integer.valueOf(mapAccountSatisfaction.get(cont.AccountId).split('/')[0]) )
                {
                       mapAccountSatisfaction.put(cont.AccountId,cont.Indicateur_de_satisfaction__c);
                   }
            }
            else
            {
                mapAccountSatisfaction.put(cont.AccountId,cont.Indicateur_de_satisfaction__c);
            }
        }
        
        //Mettre a jour le champ Satisfaction_client__c si le partenaire est dans la map mapAccountSatisfaction
        for(account acc: listAcc)
        {
            if(mapAccountSatisfaction.containsKey(acc.id) &&  mapAccountSatisfaction.get(acc.id) != null)
            {
                acc.Satisfaction_client__c = mapAccountSatisfaction.get(acc.id);
            }
        }
        
        //Mettre a jour la liste des partenaires
        if(listAcc != null && listAcc.size() > 0)
        {
            update listAcc;
        }
    
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}