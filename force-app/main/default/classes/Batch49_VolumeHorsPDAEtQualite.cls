/**
* @author Jacques Akiki -EI Technologies
* @date 08/07/2019
* @description Calculate the value of VolumeActiviteCAContratsHorsPDA__c that makes the roll up summary of the field
               TotalCABudgetP1P2P3P4__c on Budget
* @Test Class: Batch49_VolumeHorsPDAEtQualite_test
* @Coverage: 100%
*/
global class Batch49_VolumeHorsPDAEtQualite implements Database.Batchable<SObject>,Database.stateful
{
    global string limt;
    global set<id> setTarget = new set<id>();
    
    global Batch49_VolumeHorsPDAEtQualite(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id,VolumeActiviteCAContratsHorsPDA__c FROM Account'; 
        
        if(limt<>'' && limt<>null)
        {
            query = query+ limt; 
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Account> listAcc)
    {
        Set<id> setAccId = new Set<id>();
        List<Account> listAccUpdate = new List<Account>(); // list of account to update
        for (Account acc : listAcc)
        {
            setAccId.add(acc.id); // id of accounts
        }
        if (setAccId!=Null && setAccId.size()>0)
        {
            list<Budget__c> listBdg = new List<Budget__c>();
            /*List of Budgets related to the accounts wher contrat is not closed*/
            listBdg = [SELECT id , name , NomContrat__r.NomPartenaire__r.id, NomContrat__r.Statut__c, TotalCABudgetP1P2P3P4__c,AnneeBudget__c,NomContrat__r.ContratCadre__c  
                       FROM Budget__c
                       WHERE NomContrat__r.NomPartenaire__r.id in: setAccId AND NomContrat__r.Statut__c <>:Label.ContratFerme];
            
            Boolean found =false;
            if (listBdg!=NULL && listBdg.size()>0)
            {
                for(Id accId : setAccId)
                {
                    for (Budget__c bdg: listBdg )
                    {
                        if(bdg.NomContrat__r.NomPartenaire__r.id == accId)
                        {
                            found = true;
                        }
                    }
                    if(!found)
                    {
                        Account acc = new Account();
                        acc.id = accId;
                        acc.Total_CA_Budget_P1_P2_P3_P4__c = 0;
                        acc.VolumeActiviteCAContratsHorsPDA__c = 0;
                        listAccUpdate.add(acc);
                    }
                    found = false;
                }
                
                system.debug('listBdg in the condition');
                
                Map<id,decimal> mapAccountTotal = new Map<id,decimal>();
                Map<id,decimal> mapAccountTotalHorsPDA = new Map<id,decimal>();

                Map <Contrat__c,Budget__c> mapContBudget = new Map <Contrat__c,Budget__c>();
                for (Budget__c bdg: listBdg )
                {
                    Contrat__c Cont = bdg.NomContrat__r;
                    if (mapContBudget.containskey(Cont))
                    {
                        if (Integer.valueOf(mapContBudget.get(Cont).AnneeBudget__c)<Integer.valueOf(bdg.AnneeBudget__c))
                        {
                            mapContBudget.put(Cont,bdg);  
                        }
                    }
                    else
                    {
                        system.debug('put in the map');
                        mapContBudget.put(Cont,bdg); 
                    }
                }
                for (Budget__c bdg: mapContBudget.values() )
                {
                    Id accId = bdg.NomContrat__r.NomPartenaire__c;
                    if(mapAccountTotal.containsKey(accId))
                    {
                        mapAccountTotal.put(accId,mapAccountTotal.get(accId)+ bdg.TotalCABudgetP1P2P3P4__c);
                    }
                    else
                    {
                        mapAccountTotal.put(accId,bdg.TotalCABudgetP1P2P3P4__c); 
                        system.debug('total budget ' + bdg.TotalCABudgetP1P2P3P4__c);
                    }
                    if (bdg.NomContrat__r.ContratCadre__c==null)
                    {
                        if(mapAccountTotalHorsPDA.containsKey(accId))
                        {
                            mapAccountTotalHorsPDA.put(accId,mapAccountTotalHorsPDA.get(accId)+ bdg.TotalCABudgetP1P2P3P4__c);
                        }
                        else
                        {
                            mapAccountTotalHorsPDA.put(accId,bdg.TotalCABudgetP1P2P3P4__c); 
                        }  
                    }
                    
                }
                for(Id accId : mapAccountTotal.keyset())
                {             
                    Account acc = new Account();
                    acc.id = accId;
                    acc.Total_CA_Budget_P1_P2_P3_P4__c = mapAccountTotal.get(accId);
                    acc.VolumeActiviteCAContratsHorsPDA__c = mapAccountTotalHorsPDA.get(accId);
                    if (mapAccountTotalHorsPDA.get(accId)<50000 && mapAccountTotalHorsPDA.get(accId)>0)
                    {
                        acc.Qualification__c = label.Qual_First; // qualification of account based on VolumeActiviteCAContratsHorsPDA__c
                    }
                    else
                    {
                         acc.Qualification__c = label.Qual_NA;
                    }
                    listAccUpdate.add(acc);
                }
                System.debug('List of account to update:' + listAccUpdate);
               
                update listAccUpdate;
            }
            else
            {
                for(Id accId : setAccId)
                {
                    Account acc = new Account();
                    acc.id = accId;
                    acc.Total_CA_Budget_P1_P2_P3_P4__c = 0;
                    acc.VolumeActiviteCAContratsHorsPDA__c = 0;
                    listAccUpdate.add(acc);
                }
                update listAccUpdate;
            }
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}