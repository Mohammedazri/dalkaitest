/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EI-Technologies
Description: Calculer le volume d'activité CA Contrats / hors fils
Test Class: AP94_Contrat_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class AP94_Contrat {
    
    public static void majCAPartenaire(List<Contrat__c> lstOldContrats, List<Contrat__c> lstContrats)
    {
        Set<Id> partenaireIds = new set<Id>();
        
        for(Contrat__c cont : lstContrats)
        {
            partenaireIds.add(cont.NomPartenaire__c);
        }
        
        if(lstOldContrats != null)
        {
            for(Contrat__c cont : lstOldContrats)
            {
                partenaireIds.add(cont.NomPartenaire__c);
            }
        }
        List <Account> listAcc = [SELECT id, Tech_Contrat_Bypass__c, (SELECT id, TotalCABudgetP1P2P3P4__c, ContratCadre__c, NomPartenaire__c
                                                                      FROM Contrats1__r
                                                                      WHERE statut__c != :Label.ContratFerme
                                                                      AND TotalCABudgetP1P2P3P4__c != null) 
                                  FROM Account 
                                  WHERE id in:partenaireIds];
        
        //if we are deleting the last contrat on a account, set the values to 0
        if(partenaireIds.size() == 1 && listAcc[0].Contrats1__r.size() == 0)
        {
            Account acc = new Account();
            acc.Id = listAcc[0].id;
            acc.Tech_Contrat_Bypass__c=!listAcc[0].Tech_Contrat_Bypass__c;
            acc.Total_CA_Budget_P1_P2_P3_P4__c = 0;
            acc.VolumeActiviteCAContratsHorsPDA__c = 0;
            update acc;
            return;
        }
        
        Map<Id, List<Contrat__c>> mapPartenaireContrat = new Map<Id, List<Contrat__c>>();
        Map<Id, Account> mapPartenaire = new Map<Id, Account>();
        Map<id,Boolean> mapPartenaireBypassVR = new Map<Id,Boolean>();
        
        for(Account acc: listAcc){
            mapPartenaireContrat.put(acc.id,acc.Contrats1__r);
            mapPartenaireBypassVR.put(acc.id,!acc.Tech_Contrat_Bypass__c);
        }
        
        Map<Id,Decimal> mapPartenaireSommeCA = new Map<Id,Decimal>();
        Map<Id,Decimal> mapPartenaireSommeCAHorsFils = new Map<Id,Decimal>();
        
        for(Id partenaire : mapPartenaireContrat.keySet()) 
        {
            Decimal totalCA = 0;
            Decimal totalCAHorsFils = 0;
            
            for(Contrat__c cont : mapPartenaireContrat.get(partenaire))
            {
                totalCA = totalCA +  cont.TotalCABudgetP1P2P3P4__c;
                
                if(cont.ContratCadre__c == null)
                {
                    totalCAHorsFils = totalCAHorsFils + cont.TotalCABudgetP1P2P3P4__c; 
                }
            }
            
            mapPartenaireSommeCA.put(partenaire, totalCA);
            mapPartenaireSommeCAHorsFils.put(partenaire, totalCAHorsFils);
        }
        
        List<Account> lstAccToUpdate = new List<Account>();
        
        for(Id partenaire : partenaireIds)
        {
            Account acc = new Account();
            acc.id = partenaire;
            acc.Tech_Contrat_Bypass__c = mapPartenaireBypassVR.get(partenaire);
            if(mapPartenaireSommeCA.containsKey(partenaire) && mapPartenaireSommeCA.get(partenaire) != null)
            {
                acc.Total_CA_Budget_P1_P2_P3_P4__c = mapPartenaireSommeCA.get(partenaire);
            }
            
            if(mapPartenaireSommeCAHorsFils.containsKey(partenaire) && mapPartenaireSommeCAHorsFils.get(partenaire) != null)
            {
                acc.VolumeActiviteCAContratsHorsPDA__c = mapPartenaireSommeCAHorsFils.get(partenaire);
            }
            
            if(!mapPartenaireSommeCA.containsKey(partenaire) && !mapPartenaireSommeCAHorsFils.containsKey(partenaire))
            {
                acc.Total_CA_Budget_P1_P2_P3_P4__c = 0;
                acc.VolumeActiviteCAContratsHorsPDA__c = 0;
            }
            
            lstAccToUpdate.add(acc);
        }
        
        if(lstAccToUpdate.size() > 0)
        {
            update lstAccToUpdate;
        }
    }
}