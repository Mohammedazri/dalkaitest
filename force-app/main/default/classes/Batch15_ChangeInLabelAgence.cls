/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Batch that queries the fields Libelle_Agence__c , Tech_Libelle_Agence__c to fill them with the correct values
Test Class: Batch15_ChangeInLabelAgence_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
19/09/2018  Jacques AKiki   Creation of Batch
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch15_ChangeInLabelAgence implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String part = 'Select Id,Libelle_Agence__c,Tech_Libelle_Agence__c,Contrat_Genere_lookup__c,Contrat_Genere_lookup__r.Libelle_Agence__c  From Opportunity ';
        String Condition ='Where (Libelle_Agence__c = NULL and Tech_Libelle_agence__c <> null) OR (Contrat_Genere_lookup__r.Libelle_Agence__c=null AND Tech_Libelle_agence__c <> null AND Contrat_Genere_lookup__c<>null)';
        String query = part + Condition ;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope){
        set<string> setAgName = new set<String>();
        Map<String,id> magAgNameId = new Map<String,id>();
        List<opportunity> listOpp = new List<opportunity>();
        List<Contrat__c> listCont = new List<Contrat__c>();
        for(Opportunity opp : (Opportunity[]) scope)
        {
            setAgName.add(opp.Tech_Libelle_agence__c);
        }
        list<agence__c> listAgc = [SELECT id,name from Agence__c where name in :setAgName];
        for(Agence__c ag:listAgc)
        {
            magAgNameId.put(ag.name,ag.id);
        }
        for(Opportunity opp : (Opportunity[]) scope)
        {
            if (opp.Libelle_Agence__c == null && opp.Tech_Libelle_agence__c <> null)
            {
                if(magAgNameId.containsKey(opp.Tech_Libelle_agence__c))
                {                
                    opp.Libelle_Agence__c = magAgNameId.get(opp.Tech_Libelle_agence__c); 
                    listOpp.add(opp);
                }
            }
            if (opp.Contrat_Genere_lookup__r.Libelle_Agence__c == null && opp.Tech_Libelle_agence__c <> null &&opp.Contrat_Genere_lookup__c <> null )
            {
                if(magAgNameId.containsKey(opp.Tech_Libelle_agence__c))
                { 
                    Contrat__c cont = new Contrat__c();
                    cont.Id = opp.Contrat_Genere_lookup__c;
                    cont.Libelle_Agence__c = magAgNameId.get(opp.Tech_Libelle_agence__c);
                    listCont.add(cont);
                }
            }
        }
        if (listOpp<> null && listOpp.size()>0)
        {
            update listOpp;
        }
        if(listCont<> null && listCont.size()>0)
        {
            update listCont;
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}