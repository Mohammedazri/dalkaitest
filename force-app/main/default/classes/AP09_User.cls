public class AP09_User {
    public static void UpdateUserFields(List<User> UsersList)
    {
        system.debug('##UsersList '+ UsersList);
        set<string> SetAppartenace= new set<string>();
        set<Id>SetUserCHanged=new set<Id>();
        for(User thisUser: UsersList)
        {
            SetAppartenace.add(thisUser.Organisation__c);
        }
        List<Agence__c> AgenceList=[SELECT id, name, Code_Agence__c, Agence_Parent__c, Code_de_direction__c, Nom_de_direction__c, DkCode__c	,
                         Region__r.Name, Region__r.Region_Parent__c, Region__r.Code_Region__c,Region__c ,
                         Region__r.siege__c, Region__r.siege__r.Name, Region__r.siege__r.Siege_Parent__c, Region__r.siege__r.Code_Siege__c 
                         FROM Agence__c
                         WHERE DkCode__c in:SetAppartenace];
        system.debug('AgenceList ' + AgenceList);
        for(Agence__c thisAgence:AgenceList )
        {
            for(User thisUser: UsersList)
            {       
                if(thisUser.Organisation__c != null && thisUser.Organisation__c==thisAgence.DkCode__c)
                {
                    SetUserCHanged.add(thisUser.Id);
                    //thisUser.Tech_Code_Agence__c=thisAgence.Code_Agence__c;
                    thisUser.Code_d_Appartenance__c = thisAgence.Code_Agence__c;
                    thisUser.Nom_agence__c=thisAgence.Name;
                    thisUser.Nom_region__c=thisAgence.Region__r.Name;
                    //thisUser.Tech_Code_Region__c=thisAgence.Region__r.Code_Region__c;
                    thisUser.Nom_siege__c=thisAgence.Region__r.siege__r.Name;
                    //thisUser.Tech_Code_Siege__c=thisAgence.Region__r.siege__r.Code_Siege__c;
                    thisUser.Contrats_Nationaux__c=false;
                    thisUser.Grands_Comptes__c=false;
                }
            }
        }
        //commenté par DKF parce que ld DKcode orga sur l'utilisateur ne convient qu'a un DKCode agence et pas région ni siège
        /*List<User> UsersListRegion= new List<User>();
        SetAppartenace.clear();
        for(User thisUser: UsersList)
        {
            if(!SetUserCHanged.contains(thisUser.Id))
            {
				UsersListRegion.add(thisUser);
                SetAppartenace.add(thisUser.Organisation__c);
            }
        }
        system.debug('UsersListRegion '+UsersListRegion);
        List<Region__c> RegionList=[SELECT id, Name, Region_Parent__c, Code_Region__c,DkCode__c,
                         siege__c, siege__r.Name, siege__r.Siege_Parent__c, siege__r.Code_Siege__c 
                         FROM region__c
                         WHERE DkCode__c in:SetAppartenace];
        SetUserCHanged.clear();
        for(Region__c thisRegion:RegionList )
        {
            for(User thisUser: UsersListRegion)
            {       
                if(thisUser.Organisation__c != null && thisUser.Organisation__c==thisRegion.DkCode__c)
                {
                    system.debug('here');
                    SetUserCHanged.add(thisUser.Id);
                    //thisUser.Tech_Code_Agence__c=null;
                    thisUser.Nom_agence__c=null;
                    thisUser.Nom_region__c=thisRegion.Name;
                    thisUser.Code_d_Appartenance__c =thisRegion.Code_Region__c;
                    thisUser.Nom_siege__c=thisRegion.siege__r.Name;
                    //thisUser.Tech_Code_Siege__c=thisRegion.siege__r.Code_Siege__c;
                    thisUser.Contrats_Nationaux__c=false;
                    thisUser.Grands_Comptes__c=false;
                }
            }
        }
        
        List<User> UsersListSiege= new List<User>();
        SetAppartenace.clear();
        system.debug('SetUserCHanged '+SetUserCHanged);
        for(User thisUser: UsersListRegion)
        {
            if(!SetUserCHanged.contains(thisUser.Id))
            {
                system.debug('in !SetUserCHanged');
				UsersListSiege.add(thisUser);
                SetAppartenace.add(thisUser.Code_d_Appartenance__c);
            }
        }
        system.debug('UsersListSiege '+UsersListSiege);
        List<Siege__c> SiegeList=[SELECT id, Name, Siege_Parent__c, Code_Siege__c, Grands_Comptes__c, Contrats_Nationaux__c
                         FROM siege__c
                         WHERE Code_Siege__c in:SetAppartenace];
        SetUserCHanged.clear();
        for(Siege__c thisSiege:SiegeList )
        {
            for(User thisUser: UsersListSiege)
            { 
                if(thisUser.Code_d_Appartenance__c==thisSiege.Code_Siege__c)
                {
                    SetUserCHanged.add(thisUser.Id);
                    thisUser.Tech_Code_Agence__c=null;
                    thisUser.Nom_agence__c=null;
                    thisUser.Nom_region__c=null;
                    thisUser.Tech_Code_Region__c=null;
                    thisUser.Nom_siege__c=thisSiege.Name;
                    thisUser.Code_d_Appartenance__c=thisSiege.Code_Siege__c;
                    thisUser.Tech_Code_Siege__c=thisSiege.Code_Siege__c;
                    thisUser.Contrats_Nationaux__c=thisSiege.Contrats_Nationaux__c;
                    thisUser.Grands_Comptes__c=thisSiege.Grands_Comptes__c;
                    system.debug('thisUser '+thisUser);
                }
            }
        }
		        
        for(User thisUser: UsersListSiege)*/
        for(User thisUser: UsersList)
        {
            if(!SetUserCHanged.contains(thisUser.Id))
            {
                system.debug('null thisUser '+thisUser);
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
        
    }

}