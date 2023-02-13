public without sharing class AP08_Opportunity {
    public static void CreateProjetCOmmercial(list<Opportunity> listOpportunities){
        system.debug('###in AP08');
        set<Id>AccountIds= new set<Id>();
        for(opportunity thisOpp:listOpportunities )
        {
            AccountIds.add(thisOpp.AccountId);
        }
        List<Account> ListAccounts=[SELECT id, Name, BillingCity,BillingPostalCode
                                    FROM Account
                                    Where id in:AccountIds];
        /*listOpportunities=[SELECT id, Name, OwnerId, Type, ProjetCommercial__c, CreerNouveauProjetCommercial__c, Account.BillingCity, Account.BillingPostalCode 
FROM Opportunity 
WHERE id in: listOpportunities];*/
        
        list<ProjetCommercial__c> listProjetCommercials = new list<ProjetCommercial__c>();
        for(Opportunity opp : listOpportunities){
            if(opp.ProjetCommercial__c == null && opp.CreerNouveauProjetCommercial__c)
            {
                string ProjectName='';
                if (Trigger.isInsert) 
                {
                    Account OppAccount=new Account();
                    for(account thisAccount:ListAccounts )
                    {
                        if(thisAccount.Id ==opp.AccountId)
                        {
                            OppAccount=thisAccount;
                        }
                    }
                    if(opp.Type_pers__c=='Nouveau')
                    {
                        system.debug('in nouveau ' );
                        ProjectName='PROJ ';
                        ProjectName+= ((OppAccount.BillingCity!= null)?(OppAccount.BillingCity.length()>10?((OppAccount.BillingCity).toUpperCase()).substring(0, 10):(OppAccount.BillingCity).toUpperCase()):'');
                        ProjectName+=' (';
                        ProjectName+=(OppAccount.BillingPostalCode!= null)?(OppAccount.BillingPostalCode).left(2):'';
                        if (opp.name.length()>52)
                        {ProjectName+=') '+'PPAL'+ ' - '+(Opp.Name.substring(0,52)).toUpperCase();}
                        else
                        {
                            ProjectName+=') '+'PPAL'+ ' - '+(Opp.Name).toUpperCase();
                        }
                        system.debug('ProjectName ' + ProjectName);
                    }
                    else
                    {
                        system.debug('in not nouveau ' );
                        ProjectName='PROJ ';
                        ProjectName+=((OppAccount.BillingCity!= null)?(OppAccount.BillingCity.length()>10?((OppAccount.BillingCity).toUpperCase()).substring(0, 10):(OppAccount.BillingCity).toUpperCase()):'');
                        ProjectName+=' (';
                        ProjectName+=(OppAccount.BillingPostalCode!= null)?(OppAccount.BillingPostalCode).left(2):'';
                        if (opp.name.length()>52)
                        {
                        ProjectName+=') '+' - '+ (Opp.Name.substring(0,52)).toUpperCase();
                        }
                        else
                        {
                            ProjectName+=') '+' - '+ (Opp.Name).toUpperCase();
                        }
                        system.debug('ProjectName ' + ProjectName);
                    }
                }
                else
                {
                    system.debug('in else insert ' );
                    ProjectName='PROJ '; 
                    if (opp.name.length()>52)
                        {
                    ProjectName+= Opp.Name.substring(0,52); 
                        }
                    else
                    {
                       ProjectName+= Opp.Name;  
                    }
                    system.debug('ProjectName ' + ProjectName);
                }
                listProjetCommercials.add(new ProjetCommercial__c(
                    //Name = 'PC -' + opp.Name,
                    Name=ProjectName,
                    OpportunitCommerciale__c = opp.Id,
                    ResponsableProjet__c=opp.OwnerId,
                    Statut__c = 'Ouvert'
                ));
            }
        }
        system.debug('listProjetCommercials ' + listProjetCommercials);
        if(listProjetCommercials.size() > 0){
            system.debug('#####listProjetCommercials' + listProjetCommercials);
            insert listProjetCommercials;
            system.debug('#####listProjetCommercials' + listProjetCommercials);
            map<Id, FicheGoNoGo__c> mapOpp_FIche =new map<Id, FicheGoNoGo__c>();
            for(FicheGoNoGo__c fiche : [SELECT Id, Projet_commercial__c, ProjetCommercial__c FROM FicheGoNoGo__c WHERE Projet_commercial__c IN :listOpportunities]){
                mapOpp_FIche.put(fiche.Projet_commercial__c, fiche);
            }
            
            list<Opportunity> listOpportunities2 = new list<Opportunity>();
            for(ProjetCommercial__c pc : listProjetCommercials){
                listOpportunities2.add(new Opportunity(Id = pc.OpportunitCommerciale__c, ProjetCommercial__c = pc.Id));
                if(mapOpp_FIche.containskey(pc.OpportunitCommerciale__c))
                    mapOpp_FIche.get(pc.OpportunitCommerciale__c).ProjetCommercial__c = pc.Id;
            }
            update listOpportunities2; 
            if(mapOpp_FIche.size() > 0)
                update mapOpp_FIche.values();
        }
    }
    
    public static void UpdateNomProjetCOmmercial(list<Opportunity> listOpportunities){
        Set<Id>SetOppId= new Set<Id>();
        List<ProjetCommercial__c>ListProjetForUpdate= new List<ProjetCommercial__c>();
        for(opportunity thisOpp:listOpportunities )
        {
            SetOppId.Add(thisOpp.Id);
        }
        List<ProjetCommercial__c> ProjetsList=[SELECT id, Name, OpportunitCommerciale__r.Name, OpportunitCommerciale__r.Type_pers__c
                                               FROM ProjetCommercial__c
                                               WHERE OpportunitCommerciale__c in:SetOppId];
        system.debug('##ProjetsList '+ ProjetsList);
        for(ProjetCommercial__c thisProjet: ProjetsList)
        {
            string ProjectName=thisProjet.Name;
            if(thisProjet.OpportunitCommerciale__r.Type_pers__c=='Nouveau')
            {
                if(!ProjectName.contains('PPAL'))
                {
                    Integer PPALPosition = ProjectName.lastIndexOf('-');
                    string s1=ProjectName.substringBefore(' - ');
                    string s2=ProjectName.substringAfter(' - ');
                    ProjectName=s1 + ' PPAL'+ ' - '+ s2;
                    thisProjet.Name=ProjectName;
                    ListProjetForUpdate.add(thisProjet);
                }
            }
            else
            {
                if(ProjectName.contains('PPAL'))
                {
                    ProjectName=ProjectName.remove('PPAL ');
                    thisProjet.Name=ProjectName;
                    ListProjetForUpdate.add(thisProjet);
                }
            }
        }
        update ListProjetForUpdate;
    }
}