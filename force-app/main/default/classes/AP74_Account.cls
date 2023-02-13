/** 
* @author Jacques AKiki
* @date 07/02/2020 
* @description class responsible of updating the check boxes Grand Compte EDF et Grand Compte Dalkia
* @Test Class AP74_Account_test 82%
*/
public class AP74_Account {
    
    public Static Id partRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.RT_ACC_Partenaire).getRecordTypeId();
    public Static Id soctRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.RT_Acc_Soc).getRecordTypeId();
    
    /** 
* @author Jacques Akiki
* @date 07/02/2020 
* @check all the accounts of type partenaire that are impacted by the change on société and update them.
* @param contactList: list of accounts being updated or deleted and map <id,account> of old version  
* @return void
*/
    public static void updateSocietePart(List<Account> accList , map<id,account> mapOld)
    {
        map <id,Boolean> mapAccGCEDF = new map<id,Boolean>();
        map <id,Boolean> mapAccGCDalkia = new map<id,Boolean>();
        
        if(mapOld<>null)
        {
            for(Account acc : accList)
            {
                if(acc.RecordTypeId==partRT||acc.RecordTypeId==soctRT)
                {
                    if(acc.Grand_compte_EDF__c<>mapOld.get(acc.id).Grand_compte_EDF__c)
                    {
                        mapAccGCEDF.put(acc.id,acc.Grand_compte_EDF__c);
                    }
                    if(acc.GrandCompteDalkia__c<>mapOld.get(acc.id).GrandCompteDalkia__c)
                    {
                        mapAccGCDalkia.put(acc.id,acc.GrandCompteDalkia__c);
                    }
                }
            }
        }
        
        if ((mapAccGCEDF!=NULL && mapAccGCEDF.Keyset().size()>0) 
            || (mapAccGCDalkia!=NULL && mapAccGCDalkia.Keyset().size()>0))
        {
            updateAccounts(mapAccGCEDF,mapAccGCDalkia);
        }
    }
    
    /** 
* @author Jacques Akiki
* @date 11/08/2020 
* @Methode qui met a jour les cases a cocher Grand Compte EDF et Grand Compte Dalkia Lorsqu'on met à jour la valeur sur une société ou partenaire
* @param map<id,Boolean> mapAccGC map des partenaire avec les valeurs des cases à cocher correspondantes.
* @return void
*/    
    
    public static void updateAccounts(map<id,Boolean> mapAccGCEDF, map<id,Boolean> mapAccGCDalkia)
    {
        set<id> setAccId = new set<id>();
        setAccId.addAll(mapAccGCEDF.keyset());
        setAccId.addAll(mapAccGCDalkia.keyset());
        list<Account> listAccEDFDalkia = getAccounts(setAccId);
        /*list of Accouts to be updated*/
        list<Account> listPartUpdate = new list<Account>();
        list<Account> listSocUpdate = new list<Account>();
        set<id> setIdsParentToRemove = new set<id>();
        
        do
        {
            for(Account acc:listAccEDFDalkia)
            {
                if(mapAccGCEDF.containskey(acc.ParentId))
                {
                    /*MAJ du champ Grand Compte EDF*/
                    acc.Grand_compte_EDF__c = mapAccGCEDF.get(acc.ParentId);
                    mapAccGCEDF.put(acc.id,acc.Grand_compte_EDF__c);
                }
                if (mapAccGCDalkia.containskey(acc.ParentId))
                    /*MAJ du champ Grand Compte Dalkia*/
                {
                    acc.GrandCompteDalkia__c =  mapAccGCDalkia.get(acc.ParentId) ;
                    mapAccGCDalkia.put(acc.id,acc.GrandCompteDalkia__c);
                }
                
                /*List Of Accounts to be Updated*/
                if(acc.RecordTypeId == partRT)
                {
                    listPartUpdate.add(acc); 
                }
                if(acc.RecordTypeId == soctRT)
                {
                    listSocUpdate.add(acc); 
                }
                /*Ids of parents to remove from Map */
                setIdsParentToRemove.add(acc.ParentId);
                
                
            }
            /*Remove parents from Map*/
            mapAccGCEDF.keyset().removeAll(setIdsParentToRemove);
            mapAccGCDalkia.keyset().removeAll(setIdsParentToRemove);
            setAccId.clear();
            setAccId.addAll(mapAccGCEDF.keyset());
            setAccId.addAll(mapAccGCDalkia.keyset());
            listAccEDFDalkia = getAccounts(setAccId);
        }
        while (listAccEDFDalkia!=NULL && listAccEDFDalkia.size()>0);
        
        try
        {
            PAD.PAD_BypassTrigger += 'AP74_Account';
            
            Database.UpsertResult[] resultsP = Database.upsert(listPartUpdate, false);
            for(Integer i=0;i<resultsP.size();i++)
            {
                if (!resultsP.get(i).isSuccess())
                {
                    Database.Error err = resultsP.get(i).getErrors().get(0);
                    System.debug('Error Partenaire -- '+err.getMessage());
                }
            }
            Database.UpsertResult[] resultsS = Database.upsert(listSocUpdate, false);
            list<Account> listSocAppel = new list<Account>();
            for(Integer i=0;i<resultsS.size();i++)
            {
                if (!resultsS.get(i).isSuccess())
                {
                    Database.Error err = resultsS.get(i).getErrors().get(0);
                    System.debug('Error Société  -- '+err.getMessage());
                }
                else
                {
                    listSocAppel.add(listSocUpdate[i]);
                }
            }
            AP45_AccountCallouts.handleList(listSocAppel, 'update');
        }
        catch(Exception e)
        {
            System.debug('Exception in update Account AP74...'+e.getMessage());
        }
    } 
    
    /** 
* @author Jacques Akiki
* @date 11/08/2020 
* @ Methode pour trouver l'hierarchie des comptes, les partenaires ou sociétés liés a un certain partenaire et lier la case a cocher convenable.
* @param : setAccId , set of account ids to find children Account
* @return list<Account>
*/   
    public static List<Account> getAccounts(set<id> setAccId)
    {
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap(); // Map API name to Fields
        set<String> fieldName = new set<String>();// API names of all non formulas fields
        for (String fieldNm:fieldMap.keySet())
        {
            if (!fieldMap.get(fieldNm).getDescribe().isCalculated()) // check if field is not formula to added to the map for querying
            {
                if(!fieldNm.contains('__pc'))
                {
                    fieldName.add(fieldNm); // add to non formula map
                }
            }
        }
        List<String> fieldNames =new List<String>(fieldName);
        
        // Build a Dynamic Query String.
        String soqlQuery = ' SELECT ' + string.join(fieldNames, ',') + ' FROM Account WHERE ParentId in:setAccId and (recordTypeId =:partRT OR recordTypeId =:soctRT)';
        
        List<Account> listAcc = Database.query(soqlQuery);
        return listAcc;
    }
    
    /** 
* @author Jacques Akiki
* @date 21/06/2020 
* @ class to wrap parent status
*/    
    public class GrandCompte
    {
        public Boolean grandCompteDalkia;
        public Boolean grandCompteEDF;
    }    
    
}