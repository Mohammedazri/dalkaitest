/** 
* @author Jacques Akiki 
* @date 04/09/2020 
* @description Batch qui decoche la case est opp mère sur les opp de type Evolution
* @Test Class Batch92_UpdatePFContrat_test 93%
*/
global class Batch92_UpdatePFContrat implements Database.Batchable<SObject> {
    global string condition; // condition to change in query if we wish not to select all contrats
    /*Constructor*/
    global Batch92_UpdatePFContrat(string wCondition) 
    {
        if(wCondition<>'' && wCondition<>null)
        {
            condition = wCondition;
        }
    }
    /*default constructor*/
    global Batch92_UpdatePFContrat() 
    {
        condition =null;
    }
    /** 
* @author Jacques Akiki
* @date 04/09/2020   
* @chercher les liens contrat Tache Finance 
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='SELECT id, Projet_Finance__c FROM contrat__c ';
        if(condition!='' && condition<>null)
        {
            query = query+ condition; 
        }
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Jacques Akiki
* @date 04/09/2020  
* @ Method that calls AP91_Contrat Class to correct the field projet Finance on contrat
* @param List<contrat__c> that needs to update projet finance field
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Contrat__c> listCont)
    {
        set<id> setContId = new set<id>();
        set<id> setContIdUpdate = new set<id>();
        map<id,set<ProjetFinance__c>> mapContsetPF = new map<id,set<ProjetFinance__c>>();
        
        for(contrat__c cont:listCont)
        {
            setContId.add(cont.id);
        }
        List<LienContratTacheFinance__c> listLCT = [SELECT id,Contrat__c, ProjetFinance__c, ProjetFinance__r.DKcode__c ,ProjetFinance__r.Name   
                                                    FROM LienContratTacheFinance__c 
                                                    WHERE contrat__c in: setContId];
         for(LienContratTacheFinance__c lct:listLCT)
        {
            if(!mapContsetPF.containsKey(lct.contrat__c))
            {
                mapContsetPF.put(lct.contrat__c,new set<ProjetFinance__c>());
            }
            mapContsetPF.get(lct.contrat__c).add(new ProjetFinance__c(id=lct.ProjetFinance__c,Name=lct.projetFinance__r.Name , DKcode__c = lct.projetFinance__r.DkCode__c));
        }
        for (id contId : setContId)
        {
            if (!mapContsetPF.keyset().contains(contId))
            {
                setContIdUpdate.add(contId);
            }
        }
        if(mapContsetPF!=NULL && mapContsetPF.keyset().size()>0)
        {
            AP91_Contrat.setProjetFinance(mapContsetPF);
        }
        if(setContIdUpdate!=NULL && setContIdUpdate.size()>0)
        {
            AP91_Contrat.setProjetFinanceTFDel(setContIdUpdate);
        }
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}