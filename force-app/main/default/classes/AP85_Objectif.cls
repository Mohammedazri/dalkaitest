/** 
* @author: Dona Kfoury
* @date: 15/06/2020 
* @description:MAJ des contrats actifs et perdus en Nombre , CA et MB avec les valeurs en debut d'année au niveau du commercial.
* @Test: Class AP85_Objectif_Test
*/
public class AP85_Objectif {
    /** 
* @author: Dona Kfoury
* @date: 15/06/2020  
* @description: dans le cas de création d'un objectif, initialiser le champ ContratsActifsDebutAnnee__c par le champ ContratsActifsDebutAnnee__c de l'utilisateur concerné
* @param listObjectifs: list des objectifs créés
* @return: void
*/
    public static void ContratsActifsDebutAnnee(list<Objectif__c> listObjectifs){
        //uniquement prendre en consideration les objectifs de l'année courante
        string currentYear = string.valueOf(System.Today().year());
        //uniquement prendre en consideration les utilisaturs dont le profil est contenu dans la libellé Profils_TauxContrats
        //qui contient les profils dont on veut calculer le taux de renouvellement et de contact espace client
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<Id> setUserIds = new set<Id>();
        list<Objectif__c> listObjs = new List<Objectif__c>();
        for(objectif__c obj:listObjectifs){
            if(obj.Annee__c ==currentYear && setProfileNames.contains(obj.Profil_du_responsable__c)){
                setUserIds.add(obj.Commercial__c);
                listObjs.add(obj);
            }
        }
        if(listObjs!= null && listObjs.size()>0){
            //chercher les utilisateurs qui sont les commercials des objectifs créés
            map<id, User> mapUsers = new Map<ID, User>([Select id, ContratsActifsDebutAnnee__c , ContratsActifsDebutAnneeCA__c,ContratsActifsDebutAnneeMB__c
                                                        FROM user
                                                        where id in:setUserIds]);
            //chercher les contrats reliés
            List<Contrat__c> listContrats=[SELECT id,ownerid,AuMoinsUnContactEspaceClient__c,TotalCABudgetP1P2P3P4__c,TotalMBBudgetP1P2P3P4__c
                                           FROM contrat__c
                                           WHERE statut__c !=: label.ContratFerme
                                           AND ownerid in: setUserIds];
            List<Opportunity> listOpp = [SELECT id,ownerid,ContratOrigine__r.OwnerId, ContratOrigine__r.TotalCABudgetP1P2P3P4__c ,ContratOrigine__r.TotalMBBudgetP1P2P3P4__c
                                         FROM Opportunity
                                         WHERE Type_pers__c =:Label.Opp_type_Renewal 
                                         AND statut__c=:Label.PV_StatutPerdu 
                                         AND Annee_de_signature__c=:currentYear
                                         AND ContratOrigine__c!=NULL
                                         AND ContratOrigine__r.statut__c=:label.ContratFerme
                                         AND ContratOrigine__r.OwnerId in:setUserIds];

            //mapper pour chaque id de commercial le nombre de contrats actifs reliés à lui
            Map<id,Integer> mapUseridToContractsNumb = new Map<id,Integer>();
            //mapper pour chaque id de commercial, le nombre de contrats actifs ayant au moins un contact espace cliants, reliés à lui
            Map<id,Integer> mapUseridToContractsECNumb = new Map<id,Integer>();
            //mapper pour chaque id de commercial la somme des CA des contrats actifs reliés à lui
            Map<id,Decimal> mapUseridToContractsCA = new Map<id,Decimal>();
            //mapper pour chaque id de commercial la somme des MB des contrat actifs reliés à lui
            Map<id,Decimal> mapUseridToContractsMB = new Map<id,Decimal>();
            //mapper pour chaque id de commercial le nombre de contrats perdus reliés à lui
            Map<id,Integer> mapUseridToContratPerdusNb = new Map <id,Integer>();
            //mapper pour chaque id de commercial la somme des CA des contrats perdus reliés à lui
            Map<id,Decimal> mapUseridToContratPerdusCA = new Map <id,Decimal>();
            //mapper pour chaque id de commercial la somme des MB des contrat perdus reliés à lui
            Map<id,Decimal> mapUseridToContratPerdusMB = new Map <id,Decimal>();
            for(contrat__c con:listContrats){
                if(!mapUseridToContractsNumb.containsKey(con.ownerid)){
                    mapUseridToContractsNumb.put(con.ownerid,0);
                }
                if(!mapUseridToContractsECNumb.containsKey(con.ownerid)){
                    mapUseridToContractsECNumb.put(con.ownerid,0);
                }
                if(!mapUseridToContractsCA.containsKey(con.ownerid)){
                    mapUseridToContractsCA.put(con.ownerid,0);
                }
                if(!mapUseridToContractsMB.containsKey(con.ownerid)){
                    mapUseridToContractsMB.put(con.ownerid,0);
                }
                
                if(con.AuMoinsUnContactEspaceClient__c == true){
                    mapUseridToContractsECNumb.put(con.ownerid,mapUseridToContractsECNumb.get(con.ownerid)+1);
                }
                mapUseridToContractsNumb.put(con.ownerid,mapUseridToContractsNumb.get(con.ownerid)+1);
                mapUseridToContractsCA.put(con.ownerid,mapUseridToContractsCA.get(con.ownerid)+(con.TotalCABudgetP1P2P3P4__c==NULL?0:con.TotalCABudgetP1P2P3P4__c));
                mapUseridToContractsMB.put(con.ownerid,mapUseridToContractsMB.get(con.ownerid)+(con.TotalMBBudgetP1P2P3P4__c==NULL?0:con.TotalMBBudgetP1P2P3P4__c));
            }
            for (Opportunity opp : listOpp)
            {
                if(!mapUseridToContratPerdusNb.containsKey(Opp.ContratOrigine__r.OwnerId))
                {
                    mapUseridToContratPerdusNb.put(opp.ContratOrigine__r.OwnerId,0);
                }
                if(!mapUseridToContratPerdusCA.containsKey(opp.ContratOrigine__r.OwnerId))
                {
                    mapUseridToContratPerdusCA.put(opp.ContratOrigine__r.OwnerId,0);
                }
                if(!mapUseridToContratPerdusMB.containsKey(opp.ContratOrigine__r.OwnerId))
                {
                    mapUseridToContratPerdusMB.put(opp.ContratOrigine__r.OwnerId,0);
                }
                mapUseridToContratPerdusNb.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusNb.get(opp.ContratOrigine__r.OwnerId)+1);
                mapUseridToContratPerdusCA.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusCA.get(opp.ContratOrigine__r.OwnerId)+(opp.ContratOrigine__r.TotalCABudgetP1P2P3P4__c==NULL?0:opp.ContratOrigine__r.TotalCABudgetP1P2P3P4__c));
                mapUseridToContratPerdusMB.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusMB.get(opp.ContratOrigine__r.OwnerId)+(opp.ContratOrigine__r.TotalMBBudgetP1P2P3P4__c==NULL?0:opp.ContratOrigine__r.TotalMBBudgetP1P2P3P4__c));
            }
            for(Objectif__c myObj: listObjs){
                //initialiser ContratsActifsDebutAnnee__c
                if(mapUsers.containsKey(myObj.commercial__c)){
                    myObj.ContratsActifsDebutAnnee__c = mapUsers.get(myObj.commercial__c).ContratsActifsDebutAnnee__c;
                    myObj.ContratsActifsDebutAnneeUtilisCA__c =  mapUsers.get(myObj.commercial__c).ContratsActifsDebutAnneeCA__c;
                    myObj.ContratsActifsDebutAnneeUtilisMB__c =  mapUsers.get(myObj.commercial__c).ContratsActifsDebutAnneeMB__c;
                }
                else{
                    //mettre 1 au lieu de 0 parce que ca servira comme denominateur dans le calcul de taux de renouvellement
                    myObj.ContratsActifsDebutAnnee__c = 1;
                    myObj.ContratsActifsDebutAnneeUtilisCA__c = 1;
                    myObj.ContratsActifsDebutAnneeUtilisMB__c = 1;
                }
                //initialiser ContratsActifsEnCours__c
                if(mapUseridToContractsNumb.containskey(myObj.commercial__c)){
                    myObj.ContratsActifsEnCours__c = mapUseridToContractsNumb.get(myObj.commercial__c);
                    myObj.ContratsActifsEnCoursUtilisCA__c = mapUseridToContractsCA.get(myObj.commercial__c);
                    myObj.ContratsActifsEnCoursUtilisMB__c = mapUseridToContractsMB.get(myObj.commercial__c);
                    
                }
                else
                {
                    myObj.ContratsActifsEnCours__c = 0;
                    myObj.ContratsActifsEnCoursUtilisCA__c = 0;
                    myObj.ContratsActifsEnCoursUtilisMB__c = 0;
                }
                //initialiser les contrats perdus en cours
                if(mapUseridToContratPerdusNb.containskey(myObj.commercial__c))
                {
                    myObj.ContratsPerdusEnCoursUtilisEnNb__c = mapUseridToContratPerdusNb.get(myObj.commercial__c);
                    myObj.ContratsPerdusEnCoursUtilisEnCA__c = mapUseridToContratPerdusCA.get(myObj.commercial__c);
                    myObj.ContratsPerdusEnCoursUtilisEnMB__c = mapUseridToContratPerdusMB.get(myObj.commercial__c);
                }
                else
                {
                    myObj.ContratsPerdusEnCoursUtilisEnNb__c = 0;
                    myObj.ContratsPerdusEnCoursUtilisEnCA__c = 0;
                    myObj.ContratsPerdusEnCoursUtilisEnMB__c = 0;
                }
                //initialiser ContratsActifsAvecContactEC__c
                if(mapUseridToContractsECNumb.containskey(myObj.commercial__c)){
                    myObj.ContratsActifsAvecContactEC__c = mapUseridToContractsECNumb.get(myObj.commercial__c); 
                }
                else
                {
                    myObj.ContratsActifsAvecContactEC__c = 0;
                }
            }
        }
    }
    /** 
* @author: Dona Kfoury
* @date: 18/06/2020  
* @description: dans le cas de création d'un contrat, recalculer le champ ContratsActifsEnCours__c pour l'utilisateur commercial first concerné
* @param listContrats: list des contrats créés ou supprimés
* @return: void
*/
    public static void ContratsCreeOuDeleteAuCoursAnnee(list<contrat__c> listContrats){
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<Id> setAffectedUserIds = new set<Id>();
        for(contrat__c mycontrat:listContrats){
            if(mycontrat.statut__c != label.ContratFerme && setProfileNames.contains(mycontrat.zzz_TechProfilDuPropriertaire__c)){
                setAffectedUserIds.add(mycontrat.ownerid);
            }
        }
        if(setAffectedUserIds != null && setAffectedUserIds.size()>0){
            ContratsActifsAuCoursAnnee(setAffectedUserIds,false);
        }
    }

 /** 
* @author: Jacques Akiki
* @date: 18/03/2021
* @description: dans le cas de la réalisation d'une opportunité de renouvellement
* @param listOpportunites: nouvelle version des Opportunités modifiées
* @param mapOldOpportunite: ancienne version des Opportunités modifiées
* @return: void
*/
    public static void OppPerdueAuCoursAnnee(list<Opportunity> listOpportunites, map<id, Opportunity>mapOldOpportunite)
    {
        string currentYear = string.valueOf(System.Today().year());
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<id> setOppOwner = new set<id>();
        set<id> setAffectedUsers = new set<id>();
        for (Opportunity opp:listOpportunites)
        {
            if((opp.statut__c !=mapOldOpportunite.get(opp.id).statut__c)
               && (opp.statut__c == Label.PV_StatutPerdu || mapOldOpportunite.get(opp.id).statut__c == Label.PV_StatutPerdu)               
               && opp.ContratOrigine__c !=NULL
               && opp.Annee_de_signature__c == currentYear
               && opp.Type_pers__c == Label.Opp_type_Renewal)
            {
                setOppOwner.add(opp.TechPiloteContratOrigine__c);
                setOppOwner.add(mapOldOpportunite.get(opp.id).TechPiloteContratOrigine__c);
            }
        }
        for (user usr :[SELECT id FROM User WHERE id in:setOppOwner AND profile.Name in:setProfileNames])
        {
            setAffectedUsers.add(usr.id);
        }
        
        if(setAffectedUsers != null && setAffectedUsers.size()>0)
        {
            ContratsActifsAuCoursAnnee(setAffectedUsers,false);
        }
    }
    
    /** 
* @author: Jacques Akiki
* @date: 18/03/2021
* @description: dans le cas de modification d'une Opportunité, recalculer le champ ContratsActifsEnCours__c pour l'utilisateur commercial first concerné
* @param listOpportunites: nouvelle version des Opportunités modifiées
* @param mapOldOpportunite: ancienne version des Opportunités modifiées
* @return: void
*/
    public static void OppEditAuCoursAnnee(list<Opportunity> listOpportunites, map<id, Opportunity>mapOldOpportunite)
    {
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<id> setContId = new set<id>();
        for (Opportunity opp:listOpportunites)
        {
            if((opp.Amount !=mapOldOpportunite.get(opp.id).Amount || opp.MargeBruteOffre__c!=mapOldOpportunite.get(opp.id).MargeBruteOffre__c)
               && opp.Contrat_Genere_lookup__c!=NULL)
            {
                setContId.add(opp.Contrat_Genere_lookup__c);
            }
        }
        if(setContId!=NULL && setContId.size()!=0){
            set<id> setAffectedUserIds = new set<id>();
            for(Contrat__c cont:[SELECT id, OwnerId 
                                 FROM Contrat__c 
                                 WHERE  id in:setContId 
                                 AND zzz_TechProfilDuPropriertaire__c in:setProfileNames 
                                 AND TechTotalMBBudgetP1P2P3P4__c = NULL
                                 AND TechTotalCABudgetP1P2P3P4__c = NULL 
                                 AND statut__c !=:Label.ContratFerme])
            {
                setAffectedUserIds.add(cont.OwnerId); 
            }
            if(setAffectedUserIds != null && setAffectedUserIds.size()>0)
            {
                ContratsActifsAuCoursAnnee(setAffectedUserIds,false);
            }
        }
    }
    /** 
* @author: Dona Kfoury
* @date: 18/06/2020  
* @description: dans le cas de modification d'un contrat, recalculer le champ ContratsActifsEnCours__c pour l'utilisateur commercial first concerné
* @param listContratsString: nouvelle version des contrats modifiés
* @param mapOldContratsString: ancienne version des contrats modifiés
* @return: void
*/
    public static void ContratsEditAuCoursAnnee(list<contrat__c> listContrats, map<id, contrat__c>mapOldContrats){
        /*list<contrat__c> listContrats = (list<Contrat__c>)JSON.deserialize(listContratsString, List<Contrat__c>.class);
        map<id, contrat__c>mapOldContrats =(map<id, contrat__c>)JSON.deserialize(mapOldContratsString, map<id, contrat__c>.class);
        */
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<Id> setAffectedUserIds = new set<Id>();
        for(contrat__c mycontrat:listContrats){
            contrat__c oldContrat = mapOldContrats.get(mycontrat.Id);
            //si owner n'a pas changé et owner est commercial first et statut a changé à fermé ou depuis fermé
            if( mycontrat.ownerid == oldContrat.Ownerid &&
               setProfileNames.contains(mycontrat.zzz_TechProfilDuPropriertaire__c) &&(
                   ( mycontrat.Statut__c != oldContrat.Statut__c && (mycontrat.Statut__c == label.ContratFerme || oldContrat.Statut__c == label.ContratFerme))
                   ||(mycontrat.AuMoinsUnContactEspaceClient__c != oldContrat.AuMoinsUnContactEspaceClient__c))
                   || (mycontrat.TechTotalMBBudgetP1P2P3P4__c!=oldContrat.TechTotalMBBudgetP1P2P3P4__c 
                       ||mycontrat.TechTotalCABudgetP1P2P3P4__c!=oldContrat.TechTotalCABudgetP1P2P3P4__c)){
                       setAffectedUserIds.add(mycontrat.ownerid);
                   }
            //si owner a changé et il était ou devenu first
            if(mycontrat.ownerid != oldContrat.Ownerid
               && (setProfileNames.contains(mycontrat.zzz_TechProfilDuPropriertaire__c) || 
                   setProfileNames.contains(oldContrat.zzz_TechProfilDuPropriertaire__c))){
                       setAffectedUserIds.add(mycontrat.ownerid);
                       setAffectedUserIds.add(oldContrat.ownerid);
                   }
        }
        if(setAffectedUserIds != null && setAffectedUserIds.size()>0){
            ContratsEditAuCoursAnneeFuture(setAffectedUserIds,false);
        }
    }
    
    @future
    public static void ContratsEditAuCoursAnneeFuture(set<Id> setAffectedUserIds,boolean bl){
        ContratsActifsAuCoursAnnee(setAffectedUserIds,bl);
    }
    
    
    /** 
* @author: Dona Kfoury
* @date: 18/06/2020  
* @description: dans le cas de modification du profil d'un utilisateur à commercial first recalculé le champ ContratsActifsEnCours__c pour l'utilisateur commercial first concerné
* @param listUsers: nouvelle version des utilisateurs modifiés
* @param mapOldUsers: ancienne version des utilisateurs modifiés
* @return: void
*/
    public static void ContratsEditProfilAuCoursAnnee(list<user> listUsers, map<id, user>mapOldUsers){
        //profiles des taux des contrats
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        //profiles du taux de la vente additionelle
        string profiledVenteToInclude = label.Profils_TauxVenteAdd;
        list<string> listProfileVenteNames = profiledVenteToInclude.split('-');
        Set<String> setProfileVenteNames = new Set<String>(listProfileVenteNames);
        //set des taux des contrats
        set<Id> setNewFirstIds = new set<Id>();
        set<Id> setOldFirstIds = new set<Id>();
        //profiles du taux de la vente additionelle
        set<Id> setNewVenteFirstIds = new set<Id>();
        set<Id> setOldVenteFirstIds = new set<Id>();
        
        for(user myUser:listUsers){
            user oldUser = mapOldUsers.get(myUser.Id);
            // si le profil de l'utilisateur a changé et devient commercial first
            if(myUser.profileid != oldUser.profileid && 
               setProfileNames.contains(myUser.ZZZ_NomDuProfil__c) && !setProfileNames.contains(oldUser.ZZZ_NomDuProfil__c)){     
                   setNewFirstIds.add(myUser.Id);
               }
            else if(myUser.profileid != oldUser.profileid && 
                    setProfileNames.contains(oldUser.ZZZ_NomDuProfil__c) && !setProfileNames.contains(myUser.ZZZ_NomDuProfil__c)){
                        setOldFirstIds.add(myUser.Id);
                    }
            
            // si le profil de l'utilisateur a changé et devient un des profils du taux vente add
            if(myUser.profileid != oldUser.profileid && 
               setProfileVenteNames.contains(myUser.ZZZ_NomDuProfil__c) && !setProfileVenteNames.contains(oldUser.ZZZ_NomDuProfil__c)){     
                   setNewVenteFirstIds.add(myUser.Id);
               }
            else if(myUser.profileid != oldUser.profileid && 
                    setProfileVenteNames.contains(oldUser.ZZZ_NomDuProfil__c) && !setProfileVenteNames.contains(myUser.ZZZ_NomDuProfil__c)){
                        setOldVenteFirstIds.add(myUser.Id);
                    }
        }
        if((setNewFirstIds!= null && setNewFirstIds.size()>0) ||
           (setOldFirstIds!= null && setOldFirstIds.size()>0)){
               UpdateObjEditProfilAuCoursAnnee(setNewFirstIds, setOldFirstIds);
           }
        
        if((setNewVenteFirstIds!= null && setNewVenteFirstIds.size()>0) ||
           (setOldVenteFirstIds!= null && setOldVenteFirstIds.size()>0)){
               UpdateObjVenteEditProfilAuCoursAnnee(setNewVenteFirstIds, setOldVenteFirstIds);
           }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 26/08/2020  
* @description: methode utilisée pour faire update de l'objectif dans une methode future pour ne pas avoir mixed DML operation error
* @param setNewVenteFirstIds: ids des utilisateurs qui ont devenus commerciaux first
* @param setOldVenteFirstIds: ids des utilisateurs qui ne sont plus des commerciaux first
* @return: void
*/
    @future
    public static void UpdateObjVenteEditProfilAuCoursAnnee(set<Id> setNewVenteFirstIds,set<Id> setOldVenteFirstIds ){
        if(setNewVenteFirstIds != null && setNewVenteFirstIds.size()>0){
            AP87_Objectif.VentesAddAuCoursAnnee(setNewVenteFirstIds);
        }
        if(setOldVenteFirstIds != null && setOldVenteFirstIds.size()>0){
            ReinitialiseVenteNonfirstUser(setOldVenteFirstIds);
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 18/06/2020  
* @description: méthode utilisée pour faire update de l'objectif dans une methode future pour ne pas avoir mixed DML operation error
* @param setNewFirstIds: ids des utilisateurs qui ont devenus commerciaux first
* @param setOldFirstIds: ids des utilisateurs qui ne sont plus des commerciaux first
* @return: void
*/
    @future
    public static void UpdateObjEditProfilAuCoursAnnee(set<Id> setNewFirstIds,set<Id> setOldFirstIds ){
        if(setNewFirstIds != null && setNewFirstIds.size()>0){
            ContratsActifsAuCoursAnnee(setNewFirstIds, true);
        }
        if(setOldFirstIds != null && setOldFirstIds.size()>0){
            ReinitialiseNonfirstUser(setOldFirstIds);
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 26/08/2020  
* @description: dans le cas le user n'est plus commercial first reinitialiser le champ Ventes_Additionnelles__c de son objectif à 0
* @param setAffectedUserIds: set des ids des utilisateurs concernés
* @return: void
*/
    public static void ReinitialiseVenteNonfirstUser(set<Id> setOldVenteFirstIds){     
        string currentYear = string.valueOf(System.Today().year());
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id,  Commercial__c, Annee__c, Ventes_Additionnelles__c
                                                                  FROM Objectif__c
                                                                  WHERE Annee__c =: currentYear and Commercial__c in:setOldVenteFirstIds
                                                                 ]);
        map<Id, Id> mapCommerIdToObjId = new map<Id, Id>();
        for(Objectif__c obj: mapObjIds.values()){
            mapCommerIdToObjId.put(obj.Commercial__c, obj.Id);
        }
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(string userId:setOldVenteFirstIds){
            if(mapCommerIdToObjId.containskey(userId)){
                objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(userId));
                myObjectif.Ventes_Additionnelles__c = 0;
                listObjToUpdate.add(myObjectif);
            }
        }
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 18/06/2020  
* @description: dans le cas le user n'est plus commercial first reinitialiser le champ ContratsActifsEnCours__c de son objectif à 0
* @param setAffectedUserIds: set des ids des utilisateurs concernés
* @return: void
*/
    public static void ReinitialiseNonfirstUser(set<Id> setOldFirstIds){       
        string currentYear = string.valueOf(System.Today().year());
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id,  Commercial__c, Annee__c,
                                                                  ContratsActifsEnCours__c,ContratsActifsDebutAnnee__c,
                                                                  ContratsActifsEnCoursUtilisCA__c, ContratsActifsDebutAnneeUtilisCA__c,
                                                                  ContratsActifsEnCoursUtilisMB__c, ContratsActifsDebutAnneeUtilisMB__c,
                                                                  Ventes_Additionnelles__c,ContratsActifsAvecContactEC__c
                                                                  FROM Objectif__c
                                                                  WHERE Annee__c =: currentYear and Commercial__c in:setOldFirstIds
                                                                 ]);
        map<Id, Id> mapCommerIdToObjId = new map<Id, Id>();
        for(Objectif__c obj: mapObjIds.values()){
            mapCommerIdToObjId.put(obj.Commercial__c, obj.Id);
        }
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(string userId:setOldFirstIds){
            if(mapCommerIdToObjId.containskey(userId)){
                objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(userId));
                myObjectif.ContratsActifsEnCours__c = 0;
                myObjectif.ContratsActifsAvecContactEC__c = 0;
                myObjectif.ContratsActifsDebutAnnee__c = 1;
                myObjectif.ContratsActifsEnCoursUtilisCA__c = 0;
                myObjectif.ContratsActifsDebutAnneeUtilisCA__c = 1;
                myObjectif.ContratsActifsEnCoursUtilisMB__c = 0;
                myObjectif.ContratsActifsDebutAnneeUtilisMB__c = 1;
                myObjectif.ContratsPerdusEnCoursAgenceCA__c = 0;
                myObjectif.ContratsPerdusEnCoursAgenceMB__c = 0;
                myObjectif.ContratsPerdusEnCoursAgenceNB__c = 0;
                //myObjectif.Ventes_Additionnelles__c = 0;
                listObjToUpdate.add(myObjectif);
            }
        }
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
    }
    /** 
* @author: Dona Kfoury
* @date: 18/06/2020  
* @description: dans le cas de actions qui affectent le champ ContratsActifsEnCours__c, recalculer ce champ pour l'utilisateur concerné
* @param setAffectedUserIds: set des ids des utilisateurs concernés
* @return: void
*/
    public static void ContratsActifsAuCoursAnnee(set<Id> setAffectedUserIds, boolean ifchangeProfile){
        string currentYear = string.valueOf(System.Today().year());
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        //prendre les contrats actifs reliés au commerciaux first
        List<Contrat__c> listContrats=[SELECT id,ownerid,AuMoinsUnContactEspaceClient__c,TotalCABudgetP1P2P3P4__c,TotalMBBudgetP1P2P3P4__c
                                       FROM contrat__c
                                       WHERE statut__c !=: label.ContratFerme
                                       AND ownerid in: setAffectedUserIds];
        
          List<Opportunity> listOpp = [SELECT id,ownerid,ContratOrigine__r.OwnerId, ContratOrigine__r.TotalCABudgetP1P2P3P4__c ,ContratOrigine__r.TotalMBBudgetP1P2P3P4__c
                                         FROM Opportunity
                                         WHERE Type_pers__c =:Label.Opp_type_Renewal 
                                         AND statut__c=:Label.PV_StatutPerdu 
                                         AND Annee_de_signature__c=:currentYear
                                         AND ContratOrigine__c!=NULL
                                         AND ContratOrigine__r.statut__c=:label.ContratFerme
                                         AND ContratOrigine__r.OwnerId in:setAffectedUserIds];
        
        //mapper pour chaque id de commercial, le nombre de contrat actifs reliés à lui
        Map<id,Integer> mapUseridToContractsNumb = new Map<id,Integer>();
        //mapper pour chaque id de commercial, le nombre de contrat actifs ayant au moin un contact espace cliants, reliés à lui
        Map<id,Integer> mapUseridToContractsECNumb = new Map<id,Integer>();
        //mapper pour chaque id de commercial la somme des CA des contrats actifs reliés à lui
        Map<id,Decimal> mapUseridToContractsCA = new Map<id,Decimal>();
        //mapper pour chaque id de commercial la somme des MB des contrat actifs reliés à lui
        Map<id,Decimal> mapUseridToContractsMB = new Map<id,Decimal>();
        //mapper pour chaque id de commercial le nombre de contrats perdus reliés à lui
            Map<id,Integer> mapUseridToContratPerdusNb = new Map <id,Integer>();
            //mapper pour chaque id de commercial la somme des CA des contrats perdus reliés à lui
            Map<id,Decimal> mapUseridToContratPerdusCA = new Map <id,Decimal>();
            //mapper pour chaque id de commercial la somme des MB des contrat perdus reliés à lui
            Map<id,Decimal> mapUseridToContratPerdusMB = new Map <id,Decimal>();
        
        for(contrat__c con:listContrats){
            if(!mapUseridToContractsNumb.containsKey(con.ownerid)){
                mapUseridToContractsNumb.put(con.ownerid,0);
            }
            if(!mapUseridToContractsECNumb.containsKey(con.ownerid)){
                mapUseridToContractsECNumb.put(con.ownerid,0);
            }
            if(!mapUseridToContractsCA.containsKey(con.ownerid)){
                mapUseridToContractsCA.put(con.ownerid,0);
            }
            if(!mapUseridToContractsMB.containsKey(con.ownerid)){
                mapUseridToContractsMB.put(con.ownerid,0);
            }
            if(con.AuMoinsUnContactEspaceClient__c == true){
                mapUseridToContractsECNumb.put(con.ownerid,mapUseridToContractsECNumb.get(con.ownerid)+1);
            }
            mapUseridToContractsNumb.put(con.ownerid,mapUseridToContractsNumb.get(con.ownerid)+1);
            mapUseridToContractsCA.put(con.ownerid,mapUseridToContractsCA.get(con.ownerid)+(con.TotalCABudgetP1P2P3P4__c==NULL?0:con.TotalCABudgetP1P2P3P4__c));
            mapUseridToContractsMB.put(con.ownerid,mapUseridToContractsMB.get(con.ownerid)+(con.TotalMBBudgetP1P2P3P4__c==NULL?0:con.TotalMBBudgetP1P2P3P4__c));
        }
        for (Opportunity opp : listOpp)
            {
                if(!mapUseridToContratPerdusNb.containsKey(Opp.ContratOrigine__r.OwnerId))
                {
                    mapUseridToContratPerdusNb.put(opp.ContratOrigine__r.OwnerId,0);
                }
                if(!mapUseridToContratPerdusCA.containsKey(opp.ContratOrigine__r.OwnerId))
                {
                    mapUseridToContratPerdusCA.put(opp.ContratOrigine__r.OwnerId,0);
                }
                if(!mapUseridToContratPerdusMB.containsKey(opp.ContratOrigine__r.OwnerId))
                {
                    mapUseridToContratPerdusMB.put(opp.ContratOrigine__r.OwnerId,0);
                }
                mapUseridToContratPerdusNb.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusNb.get(opp.ContratOrigine__r.OwnerId)+1);
                mapUseridToContratPerdusCA.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusCA.get(opp.ContratOrigine__r.OwnerId)+(opp.ContratOrigine__r.TotalCABudgetP1P2P3P4__c==NULL?0:opp.ContratOrigine__r.TotalCABudgetP1P2P3P4__c));
                mapUseridToContratPerdusMB.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusMB.get(opp.ContratOrigine__r.OwnerId)+(opp.ContratOrigine__r.TotalMBBudgetP1P2P3P4__c==NULL?0:opp.ContratOrigine__r.TotalMBBudgetP1P2P3P4__c));
            }
        
        //chercher les objectifs de l'année courante affectés au commerciaux first
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id, ContratsActifsDebutAnnee__c, Commercial__c, Annee__c,ContratsActifsAvecContactEC__c,
                                                                         ContratsActifsEnCoursUtilisCA__c,ContratsActifsEnCoursUtilisMB__c,ContratsActifsEnCours__c,
                                                                         ContratsActifsDebutAnneeUtilisCA__c,ContratsActifsDebutAnneeUtilisMB__c,ContratsPerdusEnCoursUtilisEnNb__c,
                                                                         ContratsPerdusEnCoursUtilisEnCA__c,ContratsPerdusEnCoursUtilisEnMB__c
                                                                  FROM Objectif__c
                                                                  WHERE Annee__c =: currentYear and Commercial__c in:setAffectedUserIds and Profil_du_responsable__c in:setProfileNames
                                                                 ]);
        map<Id, Id> mapCommerIdToObjId = new map<Id, Id>();
        for(Objectif__c obj: mapObjIds.values()){
            mapCommerIdToObjId.put(obj.Commercial__c, obj.Id);
        }
        
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(string userId:setAffectedUserIds){
            if(mapCommerIdToObjId.containskey(userId)){
                objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(userId));
                //taux de renouvelelemnt
                if(mapUseridToContractsNumb.containskey(userId)){
                    if(myObjectif.ContratsActifsEnCours__c != mapUseridToContractsNumb.get(userId)){
                        myObjectif.ContratsActifsEnCours__c = mapUseridToContractsNumb.get(userId);
                    }
                    if(myObjectif.ContratsActifsEnCoursUtilisCA__c != mapUseridToContractsCA.get(userId)){
                        myObjectif.ContratsActifsEnCoursUtilisCA__c = mapUseridToContractsCA.get(userId);
                    }
                    if(myObjectif.ContratsActifsEnCoursUtilisMB__c != mapUseridToContractsMB.get(userId)){
                        myObjectif.ContratsActifsEnCoursUtilisMB__c = mapUseridToContractsMB.get(userId);
                    }
                    
                    
                }
                else
                {
                    if(myObjectif.ContratsActifsEnCours__c != 0){
                        myObjectif.ContratsActifsEnCours__c = 0;
                    }
                    if(myObjectif.ContratsActifsEnCoursUtilisCA__c!=0){
                        myObjectif.ContratsActifsEnCoursUtilisCA__c = 0;
                    }
                    if(myObjectif.ContratsActifsEnCoursUtilisMB__c!=0){
                        myObjectif.ContratsActifsEnCoursUtilisMB__c = 0;
                    }
                }
                if (mapUseridToContratPerdusNb.containskey(userId))
                {
                    if(myObjectif.ContratsPerdusEnCoursUtilisEnNb__c != mapUseridToContratPerdusNb.get(userId)){
                        myObjectif.ContratsPerdusEnCoursUtilisEnNb__c = mapUseridToContratPerdusNb.get(userId);
                    }
                    if(myObjectif.ContratsPerdusEnCoursUtilisEnCA__c != mapUseridToContratPerdusCA.get(userId)){
                        myObjectif.ContratsPerdusEnCoursUtilisEnCA__c = mapUseridToContratPerdusCA.get(userId);
                    }
                    if(myObjectif.ContratsPerdusEnCoursUtilisEnMB__c != mapUseridToContratPerdusMB.get(userId)){
                        myObjectif.ContratsPerdusEnCoursUtilisEnMB__c = mapUseridToContratPerdusMB.get(userId);
                    }
                }
                else
                {
                    if(myObjectif.ContratsPerdusEnCoursUtilisEnNb__c != 0){
                        myObjectif.ContratsPerdusEnCoursUtilisEnNb__c = 0;
                    }
                    if(myObjectif.ContratsPerdusEnCoursUtilisEnCA__c != 0){
                        myObjectif.ContratsPerdusEnCoursUtilisEnCA__c = 0;
                    }
                    if(myObjectif.ContratsPerdusEnCoursUtilisEnMB__c != 0){
                        myObjectif.ContratsPerdusEnCoursUtilisEnMB__c = 0;
                    }
                    
                }
                //taux contact espace client
                if(mapUseridToContractsECNumb.containskey(userId)){
                    if(myObjectif.ContratsActifsAvecContactEC__c != mapUseridToContractsECNumb.get(userId)){
                        myObjectif.ContratsActifsAvecContactEC__c = mapUseridToContractsECNumb.get(userId);
                    }
                }
                else
                {
                    if(myObjectif.ContratsActifsAvecContactEC__c != 0){
                        myObjectif.ContratsActifsAvecContactEC__c = 0;
                    }
                }
                
                //si passage au profil commercial au cours de l'année, reinitialiser ContratsActifsDebutAnnee__c à 1
                if(ifchangeProfile){
                    myObjectif.ContratsActifsDebutAnnee__c = 1;
                    myObjectif.ContratsActifsDebutAnneeUtilisCA__c = 1;
                    myObjectif.ContratsActifsDebutAnneeUtilisMB__c = 1;
                }
                listObjToUpdate.add(myObjectif);
            }
        }
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
        
    }
}