/**
* @author Jacques Akiki -EI Technologies
* @date 12/07/2019
* @description Batch that Creates Approbation__c records to map the old model 
* @Test Class: Batch50_UpdateNomBudget_test
* @Coverage: 95%
*/
global class Batch50_UpdateNomBudget implements Database.Batchable<SObject>,Database.stateful
{
    global string limt;
    global set<id> setTarget = new set<id>();
    
    global Batch50_UpdateNomBudget(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id , BudgetReference__c FROM Contrat__c where BudgetReference__c = NULL'; 
        if(limt<>'' && limt<>null)
        {
            query = query+ limt; 
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Contrat__c> listCont)
    {
        set<id> setContId = new set<id>();
        for(Contrat__c cont:listCont)
        {
            setContId.add(cont.id);
        }
        List<Budget__c> listBudget = [ SELECT Id,name,AnneeBudget__c, TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c ,NomContrat__c
                                      FROM Budget__c
                                      WHERE NomContrat__c IN :setContId];
        Map<Id,Budget__c> MapContIdRecentBudget = new  Map<Id,Budget__c>();
        
        for (Id contId : setContId  )
        {
            Integer recentYear = 0;
            Budget__c RecentBudget ;
            
            for ( Budget__c bgt : listBudget){
                Integer thisBgtRecentYear = Integer.valueOf(bgt.AnneeBudget__c);
                if( bgt.NomContrat__c == contId  && thisBgtRecentYear > recentYear){
                    recentYear = thisBgtRecentYear;
                    RecentBudget = bgt;
                } 
            }
            
            if(RecentBudget != null){
                MapContIdRecentBudget.put(contId, RecentBudget);    
            }
        }
        
        if (MapContIdRecentBudget.size()>0 ) 
        {
            List <Contrat__c> listContUpdate = new List<Contrat__c>();
            for (Id contId : MapContIdRecentBudget.keySet())
            {
                Contrat__c cont = new Contrat__c();
                cont.Id = contId;
                cont.BudgetReference__c = MapContIdRecentBudget.get(contId).name;
                cont.TechTotalCABudgetP1P2P3P4__c = MapContIdRecentBudget.get(contId).TotalCABudgetP1P2P3P4__c;
                cont.TechTotalMBBudgetP1P2P3P4__c = MapContIdRecentBudget.get(contId).TotalMBBudgetP1P2P3P4__c;
                listContUpdate.add(cont);
            }
            update listContUpdate;
        } 
    }
    global void finish(Database.BatchableContext bc)
    {
        
    }
}