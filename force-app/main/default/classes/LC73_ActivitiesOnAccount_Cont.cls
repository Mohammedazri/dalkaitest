/** 
* @author Jacques Akiki
* @date 27/10/2020 
* @Controller of lightning Component LC73
* @Test Class LC73_ActivitiesOnAccount_Test 88%
*/
public without sharing class LC73_ActivitiesOnAccount_Cont {
    /** 
* @author Jacques Akiki
* @date 27/10/2020
* @Function that queries contrats related to certain Account and all account beneah in hierarchy.
* @param Id AccId: id of the Account
* @return List<wrapperClass>  
*/
 @AuraEnabled
    public static list<wrapperClass> getAllContrats(Id AccId ) {
        
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
        list<wrapperClass> wrapperList=new list<wrapperClass>();
          for(Contrat__c cont:[Select id, Name,LibelleRegion__c , techOwner__c,Nom_d_Agence__c,TotalCABudgetP1P2P3P4__c,NomPartenaire__r.Name 
                               FROM Contrat__c 
                               WHERE NomPartenaire__c in:setAccId and statut__c !=:Label.ContratFerme])
            {
              wrapperList.add(new wrapperClass(false,cont));
            }
        return wrapperList;
    }
    
    public static List<Account> getAccounts (Set<id> setAccId)
    {
        return [SELECT id FROM Account where ParentId in :setAccId];
    }
 
    public class wrapperClass {
        @AuraEnabled
        public boolean check {
            get;
            set;
        }
        @AuraEnabled
        public Contrat__c obj{
            get;
            set;
        }
        public wrapperClass(boolean check, Contrat__c obj) {
            this.check = check;
            this.obj = obj;
        }

    }

}