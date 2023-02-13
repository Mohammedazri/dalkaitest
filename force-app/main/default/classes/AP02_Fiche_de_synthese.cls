public class AP02_Fiche_de_synthese {
    
    public static void UpdateResponsableFields(List<Fiche_de_synthese__c> FichesList)
    {
        system.debug('##in AP02_Fiche_de_synthese UpdateResponsableFields');
        set<Id> UsersIds= New set<Id>();
		set<Id> OppsIds= New set<Id>();
		Map<Id, string>MapFicheOwner=new Map<Id, string>();        
        
        for(Fiche_de_synthese__c thisFiche:FichesList)
        {
            OppsIds.add(thisFiche.Opportunit_commerciale__c);
        }
        List<Opportunity> OppList=[SELECT id, Name, OwnerId
                                   FROM Opportunity
                                   where id in: OppsIds];
        for(Opportunity thisOpportunity: OppList)
        {
            UsersIds.add(thisOpportunity.OwnerId);
        }
        
        for(Fiche_de_synthese__c thisFiche:FichesList)
        {
            for(Opportunity thisOpportunity: OppList)
            {
                if(thisOpportunity.Id==thisFiche.Opportunit_commerciale__c)
                {
                    MapFicheOwner.put(thisFiche.Id, thisOpportunity.OwnerId);
                }
            }
        }
        

        List<User> CommercialUsers=[SELECT id, Name, ManagerId, Manager.ManagerId, Manager.Manager.ManagerId, Manager.Manager.Manager.ManagerId 
                                    FROM User
                                    WHERE id in:UsersIds];
        system.debug('##CommercialUsers' + CommercialUsers);
        
        for(Fiche_de_synthese__c thisFiche:FichesList)
        {
            for(user ThisUser:CommercialUsers)
            {
                if(MapFicheOwner.get(thisFiche.Id)==ThisUser.Id)
                {
                    thisFiche.TECH_DAC__c=ThisUser.ManagerId;
                    thisFiche.TECH_DC__c=ThisUser.Manager.ManagerId;
                    thisFiche.TECH_DR__c=ThisUser.Manager.Manager.ManagerId;
                    thisFiche.TECH_DG__c=ThisUser.Manager.Manager.Manager.ManagerId;
                }
            }
        }
        system.debug('%%FichesList' + FichesList);
    }
    
    public static void UpdateResponsableFieldsOppChanged(List<Opportunity> OppsList)
    {
        system.debug('##in AP02_Fiche_de_synthese UpdateResponsableFields');
        set<Id> UsersIds= New set<Id>();
        for(Opportunity thisOpp:OppsList)
        {
            UsersIds.add(thisOpp.OwnerId);
        }
        
        List<User> CommercialUsers=[SELECT id, Name, ManagerId, Manager.ManagerId, Manager.Manager.ManagerId, Manager.Manager.Manager.ManagerId 
                                    FROM User
                                    WHERE id in:UsersIds];
        system.debug('##CommercialUsers' + CommercialUsers);
        
        List<Fiche_de_synthese__c>FicheForUpdate=[SELECT Id, Name, Opportunit_commerciale__r.OwnerId, TECH_DC__c, TECH_DG__c, TECH_DAC__c, TECH_DR__c
                                      FROM Fiche_de_synthese__c
                                      Where Opportunit_commerciale__c in:OppsList];
        
        
        for(Fiche_de_synthese__c thisFiche:FicheForUpdate)
        {
            for(user ThisUser:CommercialUsers)
            {
                if(thisFiche.Opportunit_commerciale__r.OwnerId==ThisUser.Id)
                {
                    thisFiche.TECH_DAC__c=ThisUser.ManagerId;
                    thisFiche.TECH_DC__c=ThisUser.Manager.ManagerId;
                    thisFiche.TECH_DR__c=ThisUser.Manager.Manager.ManagerId;
                    thisFiche.TECH_DG__c=ThisUser.Manager.Manager.Manager.ManagerId;
                }
            }
        }
        update FicheForUpdate;
    }
    
    public static void ManagerChanged(List<User> UsersList)
    {
        system.debug('##in AP02_Fiche_de_synthese ManagerChanged');
        
        map<Id, User> mapUsersWithAllFields= new map<Id, User>([SELECT Id, Name,ManagerId, Manager.ManagerId, Manager.Manager.ManagerId, Manager.Manager.Manager.ManagerId
                                      FROM User
                                      Where id in:UsersList]);
        
        List<Fiche_de_synthese__c> FichesForUpdate=[SELECT Id, Name, Opportunit_commerciale__r.OwnerId, TECH_DC__c, TECH_DG__c, TECH_DAC__c, TECH_DR__c
                                                    FROM Fiche_de_synthese__c
                                                    WHERE Opportunit_commerciale__r.OwnerId in: UsersList
                                                    or TECH_DAC__c in: UsersList
                                                    or TECH_DC__c in: UsersList
                                                    or TECH_DG__c in: UsersList];
        
        system.debug('##FichesForUpdate  '+ FichesForUpdate );
        for (Fiche_de_synthese__c thisFiche:FichesForUpdate )
        {
                if(mapUsersWithAllFields.containskey(thisFiche.Opportunit_commerciale__r.OwnerId))
                {
                    user ThisUser = mapUsersWithAllFields.get(thisFiche.Opportunit_commerciale__r.OwnerId);
                    system.debug('##in owner'+ thisFiche.Name );
                    thisFiche.TECH_DAC__c=ThisUser.ManagerId;
                    thisFiche.TECH_DC__c=ThisUser.Manager.ManagerId;
                    thisFiche.TECH_DR__c=ThisUser.Manager.Manager.ManagerId;
                    thisFiche.TECH_DG__c=ThisUser.Manager.Manager.Manager.ManagerId;	
                }                
                else if(mapUsersWithAllFields.containskey(thisFiche.TECH_DAC__c))
                {
                    user ThisUser = mapUsersWithAllFields.get(thisFiche.TECH_DAC__c);
                    system.debug('##in DAC' + thisFiche.Name );
                    thisFiche.TECH_DC__c=ThisUser.ManagerId;
                    thisFiche.TECH_DR__c=ThisUser.Manager.ManagerId;
                    thisFiche.TECH_DG__c=ThisUser.Manager.Manager.ManagerId;
                }
                
                else if(mapUsersWithAllFields.containskey(thisFiche.TECH_DC__c))
                {
                    user ThisUser = mapUsersWithAllFields.get(thisFiche.TECH_DC__c);
                    system.debug('##in DC' + thisFiche.Name );
                    thisFiche.TECH_DR__c=ThisUser.ManagerId;
                    thisFiche.TECH_DG__c=ThisUser.Manager.ManagerId;
                }
                
                else if(mapUsersWithAllFields.containskey(thisFiche.TECH_DG__c))
                {
                    user ThisUser = mapUsersWithAllFields.get(thisFiche.TECH_DG__c);
                    system.debug('##in DG' + thisFiche.Name );
                    thisFiche.TECH_DG__c=ThisUser.ManagerId;
                }        
        }
        update FichesForUpdate;
        system.debug('##FichesForUpdate  ' + FichesForUpdate);
    }
}