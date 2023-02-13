/** 
* @author Jacques Akiki
* @date 28/10/2020 
* @Controller of lightning Component LC82
* @Test Class LC82_RecapitulatifRegion_Test 94%
*/
public without sharing class LC82_RecapitulatifRegion_Cont {
        /** 
* @author Jacques Akiki
* @date 28/10/2020
* @Function that queries contrats ouverts by region
* @param Id AccId: id of the Account
* @return List<WrapperRegion>  
*/
    @AuraEnabled
    public static List<WrapperRegion> getContratByRegion(Id AccId) 
    {
        set<Id> setAccId = new set<id>();
        set<id> setTempParent = new set<id>();
        setAccId.add(AccId);
        setTempParent.add(AccId);
        while(setTempParent!=NULL && setTempParent.size()>0)
        {
            list<Account> listAcc = getAccounts(setTempParent);
            setTempParent.clear();
            for (Account acc:listAcc)
            {
                setAccId.add(acc.id);
                setTempParent.add(acc.id);
            }
        }
        Map<String,List<Contrat__c>> mapRegionContrat = new Map<String,List<Contrat__c>>();
        
        List<Contrat__c> listcont=[SELECT id,LibelleRegion__c ,TotalCABudgetP1P2P3P4__c 
                                   FROM Contrat__c 
                                   WHERE NomPartenaire__c in:setAccId and statut__c !=:Label.ContratFerme];
        for(Contrat__c cont:listcont)
        {
            if(cont.LibelleRegion__c!=NULL)
            {
                if(!mapRegionContrat.containskey(cont.LibelleRegion__c))
                {
                    mapRegionContrat.put(cont.LibelleRegion__c,new list<Contrat__c>());
                }
                mapRegionContrat.get(cont.LibelleRegion__c).add(cont);  
            }
            else
            {
                if(!mapRegionContrat.containskey(Label.LC82_SansRegion))
                {
                    mapRegionContrat.put(Label.LC82_SansRegion,new list<Contrat__c>());
                }
                mapRegionContrat.get(Label.LC82_SansRegion).add(cont); 
            }
            
        }
        List<WrapperRegion> listParRegion = new list<WrapperRegion>();
        Integer totalContrat = 0;
        Decimal totalCAP1234 = 0;
        for(String reg:mapRegionContrat.keyset())
        {
            WrapperRegion wr = new WrapperRegion();
            wr.RegionName = reg;
            wr.NumbContrat = mapRegionContrat.get(reg).size();
            totalContrat = totalContrat+wr.NumbContrat;
            wr.TotalP1P2P3P4 = 0;
            for(Contrat__c contr:mapRegionContrat.get(reg))
            {
                wr.TotalP1P2P3P4 = wr.TotalP1P2P3P4+ contr.TotalCABudgetP1P2P3P4__c;
            }
            wr.StyleBold = false;
            totalCAP1234 = totalCAP1234+ wr.TotalP1P2P3P4;
            listParRegion.add(wr);
        }
        WrapperRegion wr = new WrapperRegion();
        wr.RegionName = 'TOTAL';
        wr.NumbContrat = totalContrat;
        wr.TotalP1P2P3P4 = totalCAP1234;
        wr.StyleBold = true;
        listParRegion.add(wr);
        
        return listParRegion; 
    }
/** 
* @author Jacques Akiki
* @date 28/10/2020
* @Function that queries contrats ouverts by region
* @param set<Id> set of account ids
* @return List<Account>  
*/
    public static List<Account> getAccounts (Set<id> setAccId)
    {
        return [SELECT id FROM Account where ParentId in :setAccId];
    }
    
/** 
* @author Jacques Akiki
* @date 28/10/2020
* @Wrapper class  
*/    
    
    public class WrapperRegion {
        
        @AuraEnabled
        public String RegionName{get;set;}
        @AuraEnabled
        public Decimal TotalP1P2P3P4{get;set;}
        @AuraEnabled
        public Integer NumbContrat{get;set;}
        @AuraEnabled
        public Boolean StyleBold{get;set;}
        
    }
}