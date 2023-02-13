/** 
* @author Dona Kfoury
* @date 18/2/2020 
* @description maj du user après modif agence, region et siège
* @Test class: AP75_Agence_Test
*/
public class AP75_Agence {
    /** 
* @author Dona Kfoury
* @date  18/2/2020 
* @description filtre les agences modifiés pour envoyés les utilisateurs affectés
* @param List<Agence__c> agenceList nouvelle version des agences modifiées
* @param map<id, Agence__c>mapOldAgence ancienne version des agences modifiées
* @return void
*/
    public static void getAgenceChanged(List<Agence__c> agenceList, map<id, Agence__c>mapOldAgence){
        set<string> setAgenceCodes = new set<String>();
        map<string,Agence__c> mapCodeAgence = new map<string,Agence__c>();
        for(Agence__c myAgence:agenceList)
        {
            if(myAgence.Code_Agence__c	!= mapOldAgence.get(myAgence.Id).Code_Agence__c ||
               myAgence.Name != mapOldAgence.get(myAgence.Id).Name ||
               myAgence.Region__c != mapOldAgence.get(myAgence.Id).Region__c){
                   setAgenceCodes.add(myAgence.DkCode__c);
               }
        }
        
        if(setAgenceCodes != null && setAgenceCodes.size()>0){
            List<User> listAffectedUsers = [Select ID, Tech_Code_Agence__c, Nom_agence__c, Nom_region__c, Tech_Code_Region__c, Nom_siege__c, 
                                            Tech_Code_Siege__c, Contrats_Nationaux__c, Grands_Comptes__c,Organisation__c
                                            FROM user
                                            WHERE Organisation__c in:setAgenceCodes
                                            and Organisation__c != null 
                                            and Organisation__c !=''];
            modifyUsers(listAffectedUsers);
        }
    }
    
    /** 
* @author Dona Kfoury
* @date  18/2/2020 
* @description filtre les régions modifiés pour envoyés les utilisateurs affectés
* @param List<Region__c> regionList nouvelle version des régions modifiées
* @param map<id, Region__c>mapOldRegion ancienne version des régions modifiées
* @return void
*/
    public static void getRegionChanged(List<Region__c> regionList, map<id, Region__c>mapOldRegion){
        set<string> setCodes = new set<String>();
        set<string> setRegionIds = new set<String>();
        for(Region__c myRegion:regionList)
        {
            if(myRegion.Code_Region__c	!= mapOldRegion.get(myRegion.Id).Code_Region__c ||
               myRegion.Name	!= mapOldRegion.get(myRegion.Id).Name ||
               myRegion.Siege__c	!= mapOldRegion.get(myRegion.Id).Siege__c){
                   setRegionIds.add(myRegion.Id);
               }
        }
        
        if(setRegionIds != null && setRegionIds.size()>0){
            List<agence__c> listAffectedAgence = [Select id, DkCode__c
                                                  FROM agence__c
                                                  WHERE region__c in:setRegionIds];
            for(agence__c myAgence:listAffectedAgence){
                setCodes.adD(myAgence.DkCode__c);
            }
            List<User> listAffectedUsers = [Select ID, Tech_Code_Agence__c, Nom_agence__c, Nom_region__c, Tech_Code_Region__c, Nom_siege__c, 
                                            Tech_Code_Siege__c, Contrats_Nationaux__c, Grands_Comptes__c,Organisation__c
                                            FROM user
                                            WHERE Organisation__c in:setCodes
                                            and Organisation__c != null 
                                            and Organisation__c !=''];
            modifyUsers(listAffectedUsers);
        }
    }
    
    /** 
* @author Dona Kfoury
* @date  18/2/2020 
* @description filtre les sièges modifiés pour envoyés les utilisateurs affectés
* @param List<Siege__c> siegeList nouvelle version des sièges modifiées
* @param map<id, Siege__c>mapOldSiege ancienne version des sièges modifiées
* @return void
*/
    public static void getSiegeChanged(List<Siege__c> siegeList, map<id, Siege__c>mapOldSiege){
        set<string> setCodes = new set<String>();
        set<string> setSiegeIds = new set<String>();
        for(siege__c mySiege:siegeList)
        {
            if(mySiege.Code_Siege__c != mapOldSiege.get(mySiege.Id).Code_Siege__c ||
               mySiege.Name	!= mapOldSiege.get(mySiege.Id).Name){
                   setSiegeIds.add(mySiege.Id);
               }
        }
        
        if((setSiegeIds != null && setSiegeIds.size()>0)){
            List<agence__c> listAffectedAgence = [Select id, DkCode__c
                                                  FROM agence__c
                                                  WHERE region__r.siege__c in:setSiegeIds];
            for(agence__c myAgence:listAffectedAgence){
                setCodes.adD(myAgence.DkCode__c);
            }
            
            List<User> listAffectedUsers = [Select ID, Tech_Code_Agence__c, Nom_agence__c, Nom_region__c, Tech_Code_Region__c, Nom_siege__c, 
                                            Tech_Code_Siege__c, Contrats_Nationaux__c, Grands_Comptes__c,Organisation__c,Code_d_Appartenance__c 
                                            FROM user
                                            WHERE Organisation__c in:setCodes];
            system.debug('listAffectedUsers' +listAffectedUsers);
            modifyUsers(listAffectedUsers);
        }
    }
    /** 
* @author Dona Kfoury
* @date  18/2/2020 
* @description methode qui met à jours les utilisateurs qui appartiennet aux agences modifiés
* @param List<User> usersList liste des utilisateurs affectés qui vont être mises à jour
* @return void
*/
    Public static void modifyUsers(List<User> usersList){
        system.debug('usersList' + usersList);
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
            if (!mapCodeAgence.containsKey(agence.dkcode__c)){
                mapCodeAgence.put(agence.dkcode__c,agence);
            }
        }
        
        for(User thisUser: UsersList)
        {
            if (thisUser.Organisation__c != null &&
                mapCodeAgence.containsKey(thisUser.Organisation__c)
                && mapCodeAgence.get(thisUser.Organisation__c)!=null)
            {
                Agence__c thisAgence = mapCodeAgence.get(thisUser.Organisation__c);
                SetUserCHanged.add(thisUser.Id);
                SetUser.add(thisUser);
                thisUser.Code_d_Appartenance__c = thisAgence.Code_Agence__c;
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
        System.debug('updated SetUser ' + SetUser);
        List <User> listUserUpdate = new List<User>();
        listUserUpdate.addAll(SetUser);
        update listUserUpdate;
    }
}