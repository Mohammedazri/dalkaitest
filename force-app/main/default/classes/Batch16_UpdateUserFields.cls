/*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran 
Company: EI-Technologies
Description: batch used to responsible of applying the functionality of AP09_User .
Test Class: Batch16_UpdateUserFields_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
1/10/2018   Hussein Farran      Creation
--------------------------------------------------------------------------------------------------------------------------*/
global class Batch16_UpdateUserFields implements Database.Batchable<sObject>{
    Set<Id> setIds = new Set<Id>();
    global Batch16_UpdateUserFields (Set<Id> setIds){
        this.setIds = setIds;
    }
    global Batch16_UpdateUserFields (){
        
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query ='SELECT Tech_Code_Agence__c, Nom_agence__c, Nom_region__c, Tech_Code_Region__c, Nom_siege__c, Tech_Code_Siege__c, Contrats_Nationaux__c, Grands_Comptes__c,'
            + 'Organisation__c FROM User where Organisation__c!=NULL';
        if(setIds!=null && setIds.size()>0){
            query = query + ' and id in :setIds';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> UsersList)
    {
        system.debug('##UsersList '+ UsersList);
        set<string> SetAppartenace= new set<string>();
        set<Id>SetUserCHanged=new set<Id>();
        set<user> SetUser = new set<user>();
        
        for(User thisUser: UsersList)
        {
            SetAppartenace.add(thisUser.Organisation__c);
        }
        
        List<Agence__c> AgenceList=[SELECT id, name, Code_Agence__c, Agence_Parent__c, Code_de_direction__c, Nom_de_direction__c, 
                                    Region__r.Name, Region__r.Region_Parent__c, Region__r.Code_Region__c,Region__c ,
                                    Region__r.siege__c, Region__r.siege__r.Name, Region__r.siege__r.Siege_Parent__c, Region__r.siege__r.Code_Siege__c,dkcode__c
                                    FROM Agence__c
                                    WHERE DkCode__c in:SetAppartenace];
        map<string,Agence__c> mapCodeAgence = new map<string,Agence__c>();
        for(Agence__c agence :AgenceList)
        {
            if (!mapCodeAgence.containsKey(agence.dkcode__c))
                mapCodeAgence.put(agence.dkcode__c,agence);
        }
        
        for(User thisUser: UsersList)
        {
            if (mapCodeAgence.containsKey(thisUser.Organisation__c)
               && mapCodeAgence.get(thisUser.Organisation__c)!=null)
            {
                Agence__c thisAgence = mapCodeAgence.get(thisUser.Organisation__c);
                SetUserCHanged.add(thisUser.Id);
                SetUser.add(thisUser);
                thisUser.Tech_Code_Agence__c=thisAgence.dkcode__c;
                thisUser.Nom_agence__c=thisAgence.Name;
                thisUser.Nom_region__c=thisAgence.Region__r.Name;
                thisUser.Tech_Code_Region__c=thisAgence.Region__r.Code_Region__c;
                thisUser.Nom_siege__c=thisAgence.Region__r.siege__r.Name;
                thisUser.Tech_Code_Siege__c=thisAgence.Region__r.siege__r.Code_Siege__c;
                thisUser.Contrats_Nationaux__c=false;
                thisUser.Grands_Comptes__c=false;
            }
        }
        
        system.debug('##SetUserCHanged '+ SetUserCHanged);
        List<User> UsersListRegion= new List<User>();
        SetAppartenace.clear();
        for(User thisUser: UsersList)
        {
            if(!SetUserCHanged.contains(thisUser.Id))
            {
                UsersListRegion.add(thisUser);
                SetAppartenace.add(thisUser.Organisation__c);
            }
        }
        system.debug('##UsersListRegion '+ UsersListRegion);
        List<Region__c> RegionList=[SELECT id, Name, Region_Parent__c, Code_Region__c,
                                    siege__c, siege__r.Name, siege__r.Siege_Parent__c, siege__r.Code_Siege__c,dkcode__c
                                    FROM region__c
                                    WHERE DkCode__c in:SetAppartenace];
         map<string,region__c> mapCodeRegion = new map<string,region__c>();
        for(region__c region :RegionList)
        {
            if (!mapCodeRegion.containsKey(region.dkcode__c))
                mapCodeRegion.put(region.dkcode__c,region);
        }
        SetUserCHanged.clear();
        for(User thisUser: UsersListRegion)
        {
            if (mapCodeRegion.containsKey(thisUser.Organisation__c)
               && mapCodeRegion.get(thisUser.Organisation__c)!=null)
            {
                    SetUserCHanged.add(thisUser.Id);
                    SetUser.add(thisUser);
                    region__c thisRegion = mapCodeRegion.get(thisUser.Organisation__c);
                    thisUser.Tech_Code_Agence__c=null;
                    thisUser.Nom_agence__c=null;
                    thisUser.Nom_region__c=thisRegion.Name;
                    thisUser.Tech_Code_Region__c=thisRegion.dkcode__c;
                    thisUser.Nom_siege__c=thisRegion.siege__r.Name;
                    thisUser.Tech_Code_Siege__c=thisRegion.siege__r.Code_Siege__c;
                    thisUser.Contrats_Nationaux__c=false;
                    thisUser.Grands_Comptes__c=false;
            }
        }
        
        List<User> UsersListSiege= new List<User>();
        SetAppartenace.clear();
        for(User thisUser: UsersListRegion)
        {
            if(!SetUserCHanged.contains(thisUser.Id))
            {
                UsersListSiege.add(thisUser);
                SetAppartenace.add(thisUser.Organisation__c);
            }
        }
        
        List<Siege__c> SiegeList=[SELECT id, Name, Siege_Parent__c, Code_Siege__c, Grands_Comptes__c, Contrats_Nationaux__c
                                  FROM siege__c
                                  WHERE Code_Siege__c in:SetAppartenace];
        
        map<string,siege__c> mapCodeSiege = new map<string,siege__c>();
        for(siege__c siege :SiegeList)
        {
            if (!mapCodeSiege.containsKey(siege.Code_Siege__c))
                mapCodeSiege.put(siege.Code_Siege__c,siege);
        }
        SetUserCHanged.clear();
        for(User thisUser: UsersListSiege)
        {
            if (mapCodeSiege.containsKey(thisUser.Organisation__c)
               && mapCodeSiege.get(thisUser.Organisation__c)!=null)
            {
                    SetUserCHanged.add(thisUser.Id);
                    SetUser.add(thisUser);
                    siege__c thisSiege = mapCodeSiege.get(thisUser.Organisation__c);
                    thisUser.Tech_Code_Agence__c=null;
                    thisUser.Nom_agence__c=null;
                    thisUser.Nom_region__c=null;
                    thisUser.Tech_Code_Region__c=null;
                    thisUser.Nom_siege__c=thisSiege.Name;
                    thisUser.Tech_Code_Siege__c=thisSiege.Code_Siege__c;
                    thisUser.Contrats_Nationaux__c=thisSiege.Contrats_Nationaux__c;
                    thisUser.Grands_Comptes__c=thisSiege.Grands_Comptes__c;

            }
        }
        
        for(User thisUser: UsersListSiege)
        {
            if(!SetUserCHanged.contains(thisUser.Id))
            {
                thisUser.Tech_Code_Agence__c=null;
                thisUser.Nom_agence__c=null;
                thisUser.Nom_region__c=null;
                thisUser.Tech_Code_Region__c=null;
                thisUser.Nom_siege__c=null;
                thisUser.Tech_Code_Siege__c=null;
                thisUser.Contrats_Nationaux__c=false;
                thisUser.Grands_Comptes__c=false;
            }
        }
        System.debug('updated UsersList ' + UsersList);
        System.debug('updated UsersListRegion ' + UsersListRegion);
        System.debug('updated UsersListSiege ' + UsersListSiege);
        List <User> listUserUpdate = new List<User>();
        listUserUpdate.addAll(SetUser);
        update listUserUpdate;
    } 
    
    global void finish(Database.BatchableContext BC) 
    {
    }
    
}